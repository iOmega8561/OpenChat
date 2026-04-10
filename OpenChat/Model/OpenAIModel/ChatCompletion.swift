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
            
            // With a single struct we can decode both
            // reasoning content and ordinary messages
            struct MessageChunk: Decodable, Sendable {
                let content: String?
                let reasoning_content: String?
            }
            
            // While streaming the chat, the responses will contain this property
            let delta: MessageChunk?
            
            // The "message" property is only for non-streamed chat completions
            let message: MessageChunk?
        }

        let choices: [Choice]
    }
}
