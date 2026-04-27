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
    let apiResourceParam: String?
    
    func build(for config: OpenAIConfiguration) throws -> URLRequest {
        var url = config.baseURL.appendingPathComponent(self.path)
        
        if let apiResourceParam {
            url.appendPathComponent(apiResourceParam)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        
        request.addValue(
            self.contentType.rawValue,
            forHTTPHeaderField: "Content-Type"
        )
        
        request.addValue(
            "Bearer \(config.token)",
            forHTTPHeaderField: "Authorization"
        )
        
        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        return request
    }
}

extension OpenAIRequest where EndpointModel == Models {
    static let models = OpenAIRequest(
        body: .init(),
        contentType: .json,
        method: .get,
        path: "/v1/models",
        apiResourceParam: nil
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
            path: "/v1/chat/completions",
            apiResourceParam: nil
        )
    }
}

