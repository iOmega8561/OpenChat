//
//  OpenAIService.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct OpenAIService: Sendable {
    
    private typealias StreamedSequence<EndpointModel: OpenAIModel> = AsyncThrowingCompactMapSequence<
        AsyncPrefixWhileSequence<
            AsyncLineSequence<URLSession.AsyncBytes>
        >,
        EndpointModel.ResponseBodyType
    >
    
    private let config: OpenAIConfiguration
    
    private let session = SessionManager.shared.session
    
    private func performRequest<
        EndpointModel: OpenAIModel
    >(
        _ request: OpenAIRequest<EndpointModel>
        
    ) async throws -> EndpointModel.ResponseBodyType {
        
        let (data, response) = try await session.data(
            for: request.build(for: config)
        )
        
        try OpenAIError.detectError(from: response)
                
        do {
            return try JSONDecoder().decode(EndpointModel.ResponseBodyType.self, from: data)
        } catch {
            throw OpenAIError.invalidResponse
        }
    }
    
    private func streamRequest<
        EndpointModel: OpenAIModel
    >(
        _ request: OpenAIRequest<EndpointModel>
        
    ) async throws -> StreamedSequence<EndpointModel> {
        
        let (bytes, response) = try await session.bytes(
            for: request.build(for: config)
        )
        
        try OpenAIError.detectError(from: response)
        
        let decoder = JSONDecoder()

        return try bytes.lines
            .prefix {
                $0 != "data: [DONE]"
            }
            .compactMap { line -> EndpointModel.ResponseBodyType? in
                guard line.hasPrefix("data: ") else {
                    return nil
                }
                
                let json = line.dropFirst(6)
                guard let data = json.data(using: .utf8) else {
                    return nil
                }
                
                return try decoder.decode(EndpointModel.ResponseBodyType.self, from: data)
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
    
    func streamChat(messages: [Message], model: Model) async throws -> some AsyncSequence {
        
        let request = OpenAIRequest.chatCompletions(
            messages: messages,
            model: model,
            stream: true
        )
        
        return try await streamRequest(request)
            .compactMap { line in
                line.choices.first?.delta
            }
    }
    
    init(_ config: OpenAIConfiguration) { self.config = config }
}
