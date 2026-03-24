//
//  Models.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 24/03/26.
//

import Foundation

nonisolated enum Models: OpenAIModel {
    
    struct RequestBodyType: Encodable, Sendable {
        init? () { return nil }
    }
    
    struct ResponseBodyType: Codable {
        let data: [Model]
    }
}
