//
//  OpenChat.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI

@main
struct OpenChat: App {
    @State private var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            
            switch viewModel.appMode {
            case .ready:
                
                ContentView()
                    .environment(viewModel)
                
            case .setup(let loginURL):
                
                OnboardingView(
                    webLoginURL: loginURL
                )
                .environment(viewModel)
            }
        }
    }
}
