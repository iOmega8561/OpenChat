//
//  OpenAIRequest.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct OpenAIRequest<EndpointModel: OpenAIModel>: Sendable {
    
    let requestBody: EndpointModel.RequestBodyType?
    let httpContentType: HTTPContentType
    let httpMethod: HTTPMethod
    let apiResourcePath: String
    let apiResourceParam: String?
    
    func build(for config: OpenAIConfiguration) throws -> URLRequest {
        var url = config.baseURL.appendingPathComponent(self.apiResourcePath)
        
        if let apiResourceParam {
            url.appendPathComponent(apiResourceParam)
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

extension OpenAIRequest where EndpointModel == Models {
    static let models = OpenAIRequest(
        requestBody: .init(),
        httpContentType: .json,
        httpMethod: .get,
        apiResourcePath: "/v1/models",
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
            requestBody: .init(model: model.id, messages: messages, stream: stream),
            httpContentType: .json,
            httpMethod: .post,
            apiResourcePath: "/v1/chat/completions",
            apiResourceParam: nil
        )
    }
}

