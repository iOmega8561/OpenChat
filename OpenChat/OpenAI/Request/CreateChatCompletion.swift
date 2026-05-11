//
//  CreateChatCompletion.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 25/04/2026.
//

import Foundation

struct CreateChatCompletion: StreamedRequest, UnaryRequest {
    
    struct RequestBody: EncodableBody {
        let model: String
        let messages: [ChatCompletionMessageParam]
        let stream: Bool
    }
    
    typealias ResponseBody = ChatCompletion
    
    let requestBody: RequestBody?
    let httpContentType: HTTPContentType = .json
    let httpMethod: HTTPMethod = .post
    let apiResourcePath: String = "/chat/completions"
    let urlParameter: String? = nil
}
