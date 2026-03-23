//
//  WebLoginView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI
import WebKit

#if canImport(AppKit)
private typealias ViewRepresentable = NSViewRepresentable
#else
private typealias ViewRepresentable = UIViewRepresentable
#endif

struct WebLoginView: ViewRepresentable {
    
    @Environment(AppViewModel.self) var viewModel
    
    let url: URL?
    
    private func makeView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.default()
        
        let webView = WKWebView(
            frame: .zero,
            configuration: config
        )
    
        webView.configuration
            .websiteDataStore
            .httpCookieStore.add(context.coordinator)
        
        webView.navigationDelegate = context.coordinator
        
        if let url {
            webView.load(URLRequest(url: url))
        }
    
        return webView
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator({
            Task { @MainActor in
                try? await viewModel.initiateAuthFlow()
            }
        })
    }
    
    #if canImport(AppKit)
    func makeNSView(context: Context) -> WKWebView {
        return makeView(context: context)
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {}
    #else
    func makeUIView(context: Context) -> WKWebView {
        return makeView(context: context)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    #endif
}
