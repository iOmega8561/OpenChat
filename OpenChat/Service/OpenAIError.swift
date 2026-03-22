//
//  OpenAIError.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 23/03/26.
//

import Foundation

enum OpenAIError: Error {
    
    case badRequest
    
    case invalidResponse
    
    case unauthorized(redirectUrl: URL?)
    
    static func detectError(from response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }
        
        switch http.statusCode {
        case 401:
            throw OpenAIError.unauthorized(redirectUrl: nil)
            
        case 400:
            throw OpenAIError.badRequest
            
        case 300...399:
            if let location = http.value(forHTTPHeaderField: "Location") {
                throw OpenAIError.unauthorized(redirectUrl: URL(string: location))
            }
            
            throw OpenAIError.invalidResponse
        default: return
        }
    }
}
