//
//  SessionManager.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation
import WebKit

final class SessionManager: NSObject, URLSessionDelegate {
    
    @MainActor
    static let shared = SessionManager()
    
    let cookieStorage: HTTPCookieStorage = .shared
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpCookieStorage = self.cookieStorage
        config.httpShouldSetCookies = true
        
        return URLSession(
            configuration: config,
            delegate: self,
            delegateQueue: nil
        )
    }()
    
    func clearSession() {
        cookieStorage.removeCookies(since: .distantPast)
    }
    
    func setCookies(from webKitStore: WKHTTPCookieStore) {
        webKitStore.getAllCookies { [weak self] cookies in
            for cookie in cookies {
                self?.cookieStorage.setCookie(cookie)
            }
        }
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest
    ) async -> URLRequest? {
        return nil
    }
    
    private override init() {}
}
