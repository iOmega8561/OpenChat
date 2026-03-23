//
//  API.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct ChatCompletionRequest: Codable {
    let model: String
    let messages: [Message]
    let stream: Bool
}

struct ChatMessageDTO: Codable {
    let role: String
    let content: String
}

struct ChatCompletionResponse: Codable {
    
    struct Choice: Codable {
        let message: ChatMessageDTO
    }
    
    let choices: [Choice]
}

struct ModelsResponse: Codable {
    
    let data: [Model]
}

struct VersionResponse: Codable {
    
    let version: String
}

nonisolated struct StreamChunk: Decodable, Sendable {
    struct Choice: Decodable {
        struct Delta: Decodable {
            let content: String?
        }
        let delta: Delta
    }
    
    let choices: [Choice]
}
