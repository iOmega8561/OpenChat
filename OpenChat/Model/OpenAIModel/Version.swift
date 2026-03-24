//
//  Models 2.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 24/03/26.
//


nonisolated enum Version: OpenAIModel {
    
    struct RequestBodyType: Encodable, Sendable {
        init? () { return nil }
    }
    
    struct ResponseBodyType: Codable {
        let data: [Model]
    }
}
