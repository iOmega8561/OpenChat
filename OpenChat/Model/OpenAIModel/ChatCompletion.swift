//
//  ChatCompletion.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 24/03/26.
//

import Foundation

nonisolated enum ChatCompletion: OpenAIModel {
    
    struct RequestBodyType: Codable {
        let model: String
        let messages: [Message]
        let stream: Bool
    }
    
    struct ResponseBodyType: Codable {
        struct Choice: Codable {
            
            struct ChatMessageDTO: Codable {
                let role: String
                let content: String
            }
            
            let message: ChatMessageDTO
        }

        let choices: [Choice]
    }
}
