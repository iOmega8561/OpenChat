//
//  ChatCompletion.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 24/03/26.
//

import Foundation

enum ChatCompletion: OpenAIModel {
    
    struct RequestBodyType: Encodable, Sendable {
        let model: String
        let messages: [Message]
        let stream: Bool
    }
    
    struct ResponseBodyType: Decodable, Sendable {
        struct Choice: Decodable, Sendable {
            
            struct Message: Decodable, Sendable {
                let content: String?
            }
            
            let message: Message?
            let delta: Message?
        }

        let choices: [Choice]
    }
}
