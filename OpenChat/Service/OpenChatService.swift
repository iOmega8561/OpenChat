//
//  OpenAIService.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct OpenChatService: Sendable {
    
    private let config: OpenAIConfiguration
    
    private let session = SessionManager.shared.session
    
    func fetchModels() async throws -> [Model] {
        let response = try await GetModels().perform(
            on: config,
            using: session
        )
        
        return response.data
    }
    
    func sendChat(messages: [Message], model: Model) async throws -> Message {
        
        let body: CreateChatCompletion.RequestBody = .init(
            model: model.id,
            messages: messages.map { .init(content: $0.content,
                                           role: $0.role.rawValue) },
            stream: false
        )
        
        let response = try await CreateChatCompletion(requestBody: body).perform(on: config, using: session)
        
        guard let messageContent = response.choices.first?.message?.content else {
            throw OpenAIError.invalidResponse
        }
        
        return Message(role: .assistant, content: messageContent)
    }
    
    func streamChat(messages: [Message], model: Model) async throws -> some AsyncSequence {
        
        let body: CreateChatCompletion.RequestBody = .init(
            model: model.id,
            messages: messages.map { .init(content: $0.content,
                                           role: $0.role.rawValue) },
            stream: true
        )
        
        let request = CreateChatCompletion(requestBody: body)
        
        return try await request.stream(from: config, using: session)
            .compactMap { line in
                line.choices.first?.delta
            }
    }
    
    init(_ config: OpenAIConfiguration) { self.config = config }
}
