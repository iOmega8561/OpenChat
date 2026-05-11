//
//  WebViewCoordinator.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import WebKit

final class WebViewCoordinator: NSObject, WKNavigationDelegate, WKHTTPCookieStoreObserver {
    
    private let navCallback: @MainActor @Sendable () -> Void
    
    init(_ navCallback: @escaping @MainActor @Sendable () -> Void) {
        self.navCallback = navCallback
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navCallback()
    }
    
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        
        SessionManager.shared.setCookies(from: cookieStore)
    }
}
