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
            
            Group {
                if !viewModel.isReady {
                    OnboardingView()
                    
                } else {
                    ContentView()
                }
            }
            .environment(viewModel)
        }
    }
}
