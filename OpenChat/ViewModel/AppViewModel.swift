//
//  AppViewModel.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI
import Observation

@MainActor @Observable
final class AppViewModel {
    
    private(set) var appMode: AppMode = .setup()
    private(set) var config: ConnectionConfig?
    private(set) var models: [Model] = []
                
    func setConfig(_ config: ConnectionConfig) {
        self.config = config
    }
    
    func fetchModels() async throws {
        guard let config else { return }
        
        self.models = try await OpenChatService(config).fetchModels()
    }
    
    func initiateAuthFlow() async throws {
        guard config != nil else { return }
            
        do {
            try await fetchModels()
            appMode = .ready
        } catch let error as HTTPError {
            switch error {
            case .location(let url):
                appMode = .setup(loginAt: url)
            default: throw error
            }
        }
    }
    
    func chatCompletion(streaming chat: Chat) async throws {
        guard let config,
              let model = chat.model else { return }
        
        let stream = try await OpenChatService(config).streamChat(
            messages: chat.messages,
            model: model
        )
        
        chat.messages.append(Message(role: .assistant, content: ""))
        let targetIndex = chat.messages.index(before: chat.messages.endIndex)
        
        for try await chunk in stream {
            
            guard let delta = chunk as? ChatCompletion.Choice.ChatCompletionMessage
            else { continue }
            
            chat.messages[targetIndex].reasoning += delta.reasoning_content ?? ""
            chat.messages[targetIndex].content += delta.content ?? ""
        }
    }
}
