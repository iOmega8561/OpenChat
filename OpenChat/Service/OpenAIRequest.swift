//
//  OpenAIRequest.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct OpenAIRequest<RequestType: Encodable>: Sendable {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum ContentType: String {
        case json = "application/json"
        case html = "text/html"
    }
    
    let body: RequestType?
    let contentType: ContentType
    let method: Method
    let path: String
    
    func perform(
        endpoint: EndpointConfiguration,
        session: URLSession
    ) async throws -> (Data, URLResponse) {
        let url = endpoint.baseURL.appendingPathComponent(self.path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        
        urlRequest.addValue(
            self.contentType.rawValue,
            forHTTPHeaderField: "Content-Type"
        )
        
        urlRequest.addValue(
            "Bearer \(endpoint.token)",
            forHTTPHeaderField: "Authorization"
        )
        
        if self.body != nil {
            urlRequest.httpBody = try JSONEncoder().encode(self.body)
        }
        
        return try await session.data(for: urlRequest)
    }
}
