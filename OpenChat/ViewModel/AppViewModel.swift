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
    
    private var service: OpenAIService?
    
    private(set) var models: [Model] = []
    private(set) var chats: [Chat] = []
    private(set) var isAuthenticated: Bool = false
    private(set) var webLoginURL: URL? = nil
    
    private(set) var endpoint: EndpointConfiguration?
    
    var selectedChat: Chat?
    
    var isConfigured: Bool {
        endpoint != nil
    }
    
    var isReady: Bool {
        endpoint != nil && isAuthenticated
    }
    
    func setEndpoint(_ endpoint: EndpointConfiguration) {
        self.endpoint = endpoint
        self.service = .init(endpoint: endpoint)
    }
    
    func createChat() {
        chats.insert(Chat(), at: 0)
        selectedChat = chats.first
    }
    
    func fetchModels() async throws {
        guard let service else { return }
        
        self.models = try await service.fetchModels()
    }
    
    func initiateAuthFlow() async throws {
        guard let service else { return }
            
        do {
            try await service.testConnection()
            isAuthenticated = true
            webLoginURL = nil
        } catch OpenAIService.Error.unauthorized(let url) {
            webLoginURL = url
        }
    }
}
