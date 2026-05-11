//
//  OpenAIUnaryRequest.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 25/04/2026.
//

import Foundation

nonisolated protocol OpenAIUnaryRequest: OpenAICraftableRequest {
    
    associatedtype ResponseBody: OpenAIDecodableBody
    
    func perform(
        on config: OpenAIConfiguration,
        using session: URLSession
    ) async throws -> ResponseBody
}

nonisolated extension OpenAIUnaryRequest {
    
    func perform(
        on config: OpenAIConfiguration,
        using session: URLSession
    ) async throws -> ResponseBody {
        
        let (data, response) = try await session.data(
            for: self.build(for: config)
        )
        
        try OpenAIError.detectError(from: response)
                
        do {
            return try JSONDecoder().decode(ResponseBody.self, from: data)
        } catch {
            throw OpenAIError.invalidResponse
        }
    }
}
