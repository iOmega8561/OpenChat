//
//  GetModels.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 25/04/2026.
//

import Foundation

struct GetModels: OpenAIUnaryRequest {
    
    typealias RequestBody = GenericEmptyBody
    
    typealias ResponseBody = Models
    
    let requestBody: RequestBody? = .init()
    let httpContentType: HTTPContentType = .json
    let httpMethod: HTTPMethod = .get
    let apiResourcePath: String = "/models"
    let urlParameter: String? = nil
}
