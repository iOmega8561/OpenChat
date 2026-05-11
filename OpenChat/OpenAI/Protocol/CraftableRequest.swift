//
//  CraftableRequest.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

nonisolated protocol CraftableRequest: Sendable {
    
    associatedtype RequestBody: EncodableBody
    
    var requestBody: RequestBody? { get }
    
    var httpContentType: HTTPContentType { get }
    
    var httpMethod: HTTPMethod { get }
    
    var apiResourcePath: String { get }
    
    var urlParameter: String? { get }
    
    func build(for config: ConnectionConfig) throws -> URLRequest
}

nonisolated extension CraftableRequest {
    
    func build(for config: ConnectionConfig) throws -> URLRequest {
        
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
