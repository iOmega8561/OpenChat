//
//  OpenAICraftableRequest.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

nonisolated protocol OpenAICraftableRequest: Sendable {
    
    associatedtype RequestBody: OpenAIEncodableBody
    
    var requestBody: RequestBody? { get }
    
    var httpContentType: HTTPContentType { get }
    
    var httpMethod: HTTPMethod { get }
    
    var apiResourcePath: String { get }
    
    var urlParameter: String? { get }
    
    func build(for config: OpenAIConfiguration) throws -> URLRequest
}

nonisolated extension OpenAICraftableRequest {
    
    func build(for config: OpenAIConfiguration) throws -> URLRequest {
        
        var url = config.baseURL.appendingPathComponent(self.apiResourcePath)
        
        if let urlParameter {
            url.appendPathComponent(urlParameter)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.rawValue
        
        request.addValue(
            self.httpContentType.rawValue,
            forHTTPHeaderField: "Content-Type"
        )
        
        request.addValue(
            "Bearer \(config.token)",
            forHTTPHeaderField: "Authorization"
        )
        
        if let requestBody {
            request.httpBody = try JSONEncoder().encode(requestBody)
        }
        
        return request
    }
}
