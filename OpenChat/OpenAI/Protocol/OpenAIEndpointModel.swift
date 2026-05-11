//
//  OpenAIEndpointModel.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 24/03/26.
//

import Foundation

nonisolated protocol OpenAIEndpointModel: Sendable {
    
    associatedtype RequestBody: Encodable & Sendable
    
    associatedtype ResponseBody: Decodable & Sendable
}
