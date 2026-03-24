//
//  Models.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 24/03/26.
//

import Foundation

enum Models: OpenAIModel {
    
    struct RequestBodyType: Encodable, Sendable {
        init? () { return nil }
    }
    
    struct ResponseBodyType: Decodable, Sendable {
        let data: [Model]
    }
}
