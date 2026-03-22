//
//  SessionManager.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

final class SessionManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    
    static let shared = SessionManager()
    
    private override init() {}
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpCookieStorage = HTTPCookieStorage.shared
        config.httpShouldSetCookies = true
        
        return URLSession(
            configuration: config,
            delegate: self,
            delegateQueue: nil
        )
    }()
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest
    ) async -> URLRequest? {
        return nil
    }
}
