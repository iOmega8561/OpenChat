//
//  AppViewModel.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation
import Observation

@MainActor @Observable
final class AppViewModel {
    
    private(set) var appMode: AppMode = .setup()
    private(set) var endpoint: EndpointConfiguration?
    private(set) var models: [Model] = []
    private(set) var chats: [Chat] = []
                
    func setEndpoint(_ endpoint: EndpointConfiguration) {
        self.endpoint = endpoint
    }
    
    func createChat() -> Chat {
        let newChat = Chat()
        chats.insert(newChat, at: 0)
        return newChat
    }
    
    func fetchModels() async throws {
        guard let endpoint else { return }
        
        self.models = try await OpenAIService(endpoint).fetchModels()
    }
    
    func initiateAuthFlow() async throws {
        guard let endpoint else { return }
            
        do {
            try await OpenAIService(endpoint).testConnection()
            appMode = .ready
        } catch OpenAIError.unauthorized(let url) {
            appMode = .setup(loginAt: url)
        }
    }
}
