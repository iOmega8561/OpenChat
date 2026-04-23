//
//  OpenAIService.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct OpenAIService: Sendable {
    
    private let endpoint: EndpointConfiguration
    
    private let session = SessionManager.shared.session
    
    private func performRequest<
        EndpointModel: OpenAIModel
    >(
        _ request: OpenAIRequest<EndpointModel>
        
    ) async throws -> EndpointModel.ResponseBodyType {
        
        let (data, response) = try await session.data(
            for: request.build(for: endpoint)
        )
        
        try OpenAIError.detectError(from: response)
                
        do {
            return try JSONDecoder().decode(EndpointModel.ResponseBodyType.self, from: data)
        } catch {
            throw OpenAIError.invalidResponse
        }
    }
    
    func fetchModels() async throws -> [Model] {
        let response = try await self.performRequest(
            .models
        )
        
        return response.data
    }
    
    func sendChat(messages: [Message], model: Model) async throws -> Message {
        
        let response = try await self.performRequest(
            .chatCompletions(messages: messages, model: model)
        )
        
        guard let messageContent = response.choices.first?.message?.content else {
            throw OpenAIError.invalidResponse
        }
        
        return Message(role: .assistant, content: messageContent)
    }
    
    func streamChat(messages: [Message], model: Model) async throws -> AsyncThrowingStream<ChatCompletion.ResponseBodyType.Choice.MessageChunk, Error> {
        
        let request = OpenAIRequest.chatCompletions(
            messages: messages,
            model: model,
            stream: true
        )
        
        let (bytes, response) = try await session.bytes(
            for: request.build(for: endpoint)
        )
        
        try OpenAIError.detectError(from: response)
        
        var iterator = bytes.lines.makeAsyncIterator()
        
        return AsyncThrowingStream<ChatCompletion.ResponseBodyType.Choice.MessageChunk, Error> { @Sendable in
            
            while let line: String = try await { @MainActor in
                return try await iterator.next()
            }() {                
                guard line.hasPrefix("data: ") else {
                    continue
                }
                                
                let json = line.replacingOccurrences(of: "data: ", with: "")
                if json == "[DONE]" { break }
                                
                guard let data = json.data(using: .utf8) else {
                    continue
                }
                                
                let chunk = try JSONDecoder().decode(ChatCompletion.ResponseBodyType.self, from: data)
                                
                if let delta = chunk.choices.first?.delta {
                    return delta
                }
            }
            
            return nil
        }
    }
    
    init(_ endpoint: EndpointConfiguration) { self.endpoint = endpoint }
}
