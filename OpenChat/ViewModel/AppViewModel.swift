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
            
    private(set) var models: [Model] = []
    private(set) var chats: [Chat] = []
    private(set) var isAuthenticated: Bool = false
    private(set) var webLoginURL: URL? = nil
    
    private(set) var endpoint: EndpointConfiguration?
        
    var isConfigured: Bool { endpoint != nil }
    
    var isReady: Bool { endpoint != nil && isAuthenticated }
    
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
            isAuthenticated = true
            webLoginURL = nil
        } catch OpenAIError.unauthorized(let url) {
            webLoginURL = url
        }
    }
}
