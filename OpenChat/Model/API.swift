//
//  API.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct ChatCompletionRequest: Codable {
    let model: String
    let messages: [ChatMessageDTO]
}

struct ChatMessageDTO: Codable {
    let role: String
    let content: String
}

struct ChatCompletionResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        
        let message: Message
    }
    
    let choices: [Choice]
}

struct ModelsResponse: Codable {
    
    let data: [Model]
}
