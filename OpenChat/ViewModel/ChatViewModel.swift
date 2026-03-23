//
//  ChatViewModel.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation
import Observation

@MainActor @Observable
final class ChatViewModel {
    
    private let service: OpenAIService
    
    private(set) var chat: Chat
    
    var currentMessage: Message = Message(
        role: .user,
        content: ""
    )
    
    func setCurrentModel(_ model: Model) {
        chat.model = model
    }
    
    func sendCurrentMessage() async throws {
        guard !currentMessage.content.isEmpty,
              let model = chat.model else { return }
        
        chat.messages.append(currentMessage)
        currentMessage = Message(role: .user, content: "")
       
        let response = try await service.sendChat(
            messages: chat.messages,
            model: model
        )
        
        chat.messages.append(response)
    }
    
    func sendCurrentMessageStreaming() async throws {
        guard !currentMessage.content.isEmpty,
              let model = chat.model else { return }
        
        chat.messages.append(currentMessage)
        currentMessage = Message(role: .user, content: "")
        
        var assistantMessage = Message(role: .assistant, content: "")
        chat.messages.append(assistantMessage)
        
        let stream = service.streamChat(
            messages: chat.messages,
            model: model
        )
        
        for try await chunk in stream {
            assistantMessage.content += chunk
            
            if let index = chat.messages.indices.last {
                chat.messages[index] = assistantMessage
            }
        }
    }
    
    init(chat: Chat, service: OpenAIService) {
        self.chat = chat
        self.service = service
    }
}
