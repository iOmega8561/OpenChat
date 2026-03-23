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
    
    func performRequest<
        RequestType: Encodable,
        ResponseType: Decodable
    >(openAIRequest: OpenAIRequest<RequestType>) async throws -> ResponseType {
        
        let (data, response) = try await openAIRequest.perform(
            endpoint: endpoint,
            session: session
        )
        
        try OpenAIError.detectError(from: response)
                
        do {
            return try JSONDecoder().decode(ResponseType.self, from: data)
        } catch {
            throw OpenAIError.invalidResponse
        }
    }
    
    func fetchApiVersion() async throws -> String {
        let openAIRequest = OpenAIRequest<String>(
            body: nil,
            contentType: .json,
            method: .get,
            path: "/api/version"
        )
        
        let response: VersionResponse = try await self.performRequest(
            openAIRequest: openAIRequest
        )
        
        return response.version
    }
    
    func fetchModels() async throws -> [Model] {
        let openAIRequest = OpenAIRequest<String>(
            body: nil,
            contentType: .json,
            method: .get,
            path: "/api/models"
        )
        
        let response: ModelsResponse = try await self.performRequest(
            openAIRequest: openAIRequest
        )
        
        return response.data
    }
    
    func sendChat(messages: [Message], model: Model) async throws -> Message {
        let openAIRequest = OpenAIRequest<ChatCompletionRequest>(
            body: .init(model: model.id, messages: messages),
            contentType: .json,
            method: .post,
            path: "/api/chat/completions"
        )
        
        let response: ChatCompletionResponse = try await self.performRequest(
            openAIRequest: openAIRequest
        )
        
        guard let choice = response.choices.first else {
            throw OpenAIError.invalidResponse
        }
        
        return Message(role: .assistant, content: choice.message.content)
    }
    
    init(_ endpoint: EndpointConfiguration) { self.endpoint = endpoint }
}
