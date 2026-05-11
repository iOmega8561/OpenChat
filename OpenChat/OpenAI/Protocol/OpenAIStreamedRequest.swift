//
//  OpenAIStreamedRequest.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 25/04/2026.
//

import Foundation

nonisolated protocol OpenAIStreamedRequest: OpenAICraftableRequest {
    
    associatedtype ResponseBody: OpenAIDecodableBody
    
    associatedtype ResponseAsyncSequenceType: AsyncSequence
    
    func stream(
        from config: OpenAIConfiguration,
        using session: URLSession
    ) async throws -> ResponseAsyncSequenceType
}

nonisolated extension OpenAIStreamedRequest {
    
    typealias ResponseAsyncSequence = AsyncThrowingCompactMapSequence<
        AsyncPrefixWhileSequence<
            AsyncLineSequence<URLSession.AsyncBytes>>,
        ResponseBody
    >
    
    func stream(
        from config: OpenAIConfiguration,
        using session: URLSession
    ) async throws -> ResponseAsyncSequence {
        
        let (bytes, response) = try await session.bytes(
            for: self.build(for: config)
        )
        
        try OpenAIError.detectError(from: response)
        
        let decoder = JSONDecoder()

        return try bytes.lines
            .prefix {
                $0 != "data: [DONE]"
            }
            .compactMap { line -> ResponseBody? in
                guard line.hasPrefix("data: ") else {
                    return nil
                }
                
                let json = line.dropFirst(6)
                guard let data = json.data(using: .utf8) else {
                    return nil
                }
                
                return try decoder.decode(ResponseBody.self, from: data)
            }
    }
}
