//
//  UnaryRequest.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 25/04/2026.
//

import Foundation

nonisolated protocol UnaryRequest: CraftableRequest {
    
    associatedtype ResponseBody: DecodableBody
    
    func perform(
        on config: ConnectionConfig,
        using session: URLSession
    ) async throws -> ResponseBody
}

nonisolated extension UnaryRequest {
    
    func perform(
        on config: ConnectionConfig,
        using session: URLSession
    ) async throws -> ResponseBody {
        
        let (data, response) = try await session.data(
            for: self.build(for: config)
        )
                
        if let error: HTTPError = .init(from: response) {
            throw error
        }
                
        return try JSONDecoder().decode(ResponseBody.self, from: data)
    }
}
