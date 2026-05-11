//
//  ChatCompletion.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 25/04/2026.
//

import Foundation

nonisolated struct ChatCompletion: OpenAIDecodableBody {
    
    nonisolated struct Choice: OpenAIDecodableBody {

        // With a single struct we can decode both
        // reasoning content and ordinary messages
        nonisolated struct ChatCompletionMessage: OpenAIDecodableBody {
            let content: String?
            let reasoning_content: String?
        }
        
        // While streaming the chat, the responses will contain this property
        let delta: ChatCompletionMessage?
        
        // The "message" property is only for non-streamed/unary chat completions
        let message: ChatCompletionMessage?
    }
    
    let choices: [Choice]
}

