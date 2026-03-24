//
//  OpenAIModel.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 24/03/26.
//

import Foundation

protocol OpenAIModel: Sendable {
    
    associatedtype RequestBodyType: Encodable & Sendable
    
    associatedtype ResponseBodyType: Decodable & Sendable
}
