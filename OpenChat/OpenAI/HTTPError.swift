//
//  HTTPError.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 23/03/26.
//

import Foundation

enum HTTPError: LocalizedError {
    
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
    
    init?(from response: URLResponse) {
        guard let http = response as? HTTPURLResponse else {
            self = .invalidResponse
            return
        }
        
        switch http.statusCode {
        case 200...299: return nil
        case 400:       self = .badRequest
        case 401:       self = .unauthorized
        case 300...399:
            guard let location = http.value(forHTTPHeaderField: "Location"),
                  let locationURL = URL(string: location) else {
                fallthrough
            }
            self = .location(url: locationURL)
        default:
            self = .unexpected(code: http.statusCode)
        }
    }
}
