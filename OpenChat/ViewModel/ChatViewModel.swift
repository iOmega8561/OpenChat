//
//  ChatViewModel.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation
import Observation

@Observable
final class ChatViewModel {
    var chat: Chat
    var input: String = ""
    var isLoading = false
    
    private let service: OpenAIService
    var selectedModel: String? = nil
    
    init(chat: Chat, service: OpenAIService) {
        self.chat = chat
        self.service = service
    }
    
    func send() async {
        guard !input.isEmpty,
              let selectedModel else { return }
        
        let userMessage = Message(role: .user, content: input)
        chat.messages.append(userMessage)
        input = ""
        
        isLoading = true
        
        do {
            let response = try await service.sendChat(
                messages: chat.messages,
                model: selectedModel
            )
            
            let assistant = Message(role: .assistant, content: response)
            chat.messages.append(assistant)
            
        } catch {
            chat.messages.append(
                Message(role: .assistant, content: "Error: \(error.localizedDescription)")
            )
        }
        
        isLoading = false
    }
}
