//
//  Version.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 24/03/26.
//

import Foundation

enum Version: OpenAIModel {
    
    struct RequestBodyType: Encodable, Sendable {
        init? () { return nil }
    }
    
    struct ResponseBodyType: Decodable, Sendable {
        let version: String
    }
}
