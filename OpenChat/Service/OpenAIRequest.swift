//
//  OpenAIRequest.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct OpenAIRequest<EndpointModel: OpenAIModel>: Sendable {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum ContentType: String {
        case json = "application/json"
        case html = "text/html"
    }
    
    let body: EndpointModel.RequestBodyType?
    let contentType: ContentType
    let method: Method
    let path: String
    
    func build(for endpoint: EndpointConfiguration) throws -> URLRequest {
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

extension OpenAIRequest where EndpointModel == Version {
    static let apiVersion = OpenAIRequest(
        body: .init(),
        contentType: .json,
        method: .get,
        path: "/api/version"
    )
}

extension OpenAIRequest where EndpointModel == Models {
    static let models = OpenAIRequest(
        body: .init(),
        contentType: .json,
        method: .get,
        path: "/api/models"
    )
}

extension OpenAIRequest where EndpointModel == ChatCompletion {
    
    static func chatCompletions(
        messages: [Message],
        model: Model,
        stream: Bool = false
    ) -> OpenAIRequest {
        
        return .init(
            body: .init(model: model.id, messages: messages, stream: stream),
            contentType: .json,
            method: .post,
            path: "/api/chat/completions"
        )
    }
}

