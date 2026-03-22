//
//  OpenAIService.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct OpenAIService: Sendable {
    
    enum Error: Swift.Error {
        case unauthorized(redirectUrl: URL?)
        case invalidResponse
        case badRequest
    }
    
    let endpoint: EndpointConfiguration
    
    private let session = SessionManager.shared.session
    
    private func detectError(from response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw Error.invalidResponse
        }
        
        switch http.statusCode {
        case 401:
            throw Error.unauthorized(redirectUrl: nil)
            
        case 400:
            throw Error.badRequest
            
        case 300...399:
            if let location = http.value(forHTTPHeaderField: "Location") {
                throw Error.unauthorized(redirectUrl: URL(string: location))
            }
            
            throw Error.invalidResponse
        default: return
        }
    }
    
    func performRequest<
        RequestType: Encodable,
        ResponseType: Decodable
    >(openAIRequest: OpenAIRequest<RequestType>) async throws -> ResponseType {
        
        let (data, response) = try await openAIRequest.perform(
            endpoint: endpoint,
            session: session
        )
        
        try detectError(from: response)
        
        do {
            return try JSONDecoder().decode(ResponseType.self, from: data)
        } catch {
            throw Error.invalidResponse
        }
    }
    
    func testConnection() async throws {
        _ = try await fetchModels()
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
    
    func sendChat(messages: [Message], model: String) async throws -> String {
        let dto = ChatCompletionRequest(
            model: model,
            messages: messages.map {
                ChatMessageDTO(role: $0.role.rawValue, content: $0.content)
            }
        )
        
        let openAIRequest = OpenAIRequest<ChatCompletionRequest>(
            body: dto,
            contentType: .json,
            method: .post,
            path: "/api/chat/completions"
        )
        
        let response: ChatCompletionResponse = try await self.performRequest(
            openAIRequest: openAIRequest
        )
        
        return response.choices.first?.message.content ?? ""
    }
}
