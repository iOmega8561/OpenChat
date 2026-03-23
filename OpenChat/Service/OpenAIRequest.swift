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
       
        return try await session.data(
            for: buildURLRequest(endpoint: endpoint)
        )
    }
    
    func buildURLRequest(endpoint: EndpointConfiguration) throws -> URLRequest {
        let url = endpoint.baseURL.appendingPathComponent(self.path)
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        
        request.addValue(
            self.contentType.rawValue,
            forHTTPHeaderField: "Content-Type"
        )
        
        request.addValue(
            "Bearer \(endpoint.token)",
            forHTTPHeaderField: "Authorization"
        )
        
        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        return request
    }
}
