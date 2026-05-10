//
//  OpenAIError.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 23/03/26.
//

import Foundation

enum OpenAIError: LocalizedError {
    
    static func detectError(from response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }
        switch http.statusCode {
        case 200...299: return
        case 400:       throw OpenAIError.badRequest
        case 401:       throw OpenAIError.unauthorized
        case 302:
            guard let location = http.value(forHTTPHeaderField: "Location"),
                  let locationURL = URL(string: location) else {
                fallthrough
            }
            throw OpenAIError.location(url: locationURL)
        default:
            throw OpenAIError.unexpected(code: http.statusCode)
        }
    }
    
    case badRequest
    case invalidResponse
    case location(url: URL)
    case unauthorized
    case unexpected(code: Int)
    
    var errorDescription: String? {
        switch self {
        case .badRequest: .init(localized: "error-bad-request")
        case .invalidResponse:  .init(localized: "error-invalid-response")
        case .location(let url): unsafe .init(
            format: .init(localized: "error-location"),
            url.absoluteString
        )
        case .unauthorized: .init(localized: "error-unauthorized")
        case .unexpected(let code): unsafe .init(
            format: .init(localized: "error-unexpected"), code
        )
        }
    }
}
