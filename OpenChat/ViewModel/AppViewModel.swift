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
    private(set) var config: OpenAIConfiguration?
    private(set) var models: [Model] = []
    private(set) var chats: [Chat] = []
                
    func setConfig(_ config: OpenAIConfiguration) {
        self.config = config
    }
    
    func createChat() -> Chat {
        let newChat = Chat()
        chats.insert(newChat, at: 0)
        return newChat
    }
    
    func deleteChats(at offsets: IndexSet) {
        chats.remove(atOffsets: offsets)
    }
    
    func fetchModels() async throws {
        guard let config else { return }
        
        self.models = try await OpenAIService(config).fetchModels()
    }
    
    func initiateAuthFlow() async throws {
        guard config != nil else { return }
            
        do {
            _ = try await fetchModels()
            appMode = .ready
        } catch let error as OpenAIError {
            switch error {
            case .unauthorized(let url):
                guard let url else {
                    throw error
                }
                
                appMode = .setup(loginAt: url)
            default: throw error
            }
        }
    }
}
