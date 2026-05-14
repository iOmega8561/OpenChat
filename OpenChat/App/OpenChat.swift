//
//  OpenChat.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI
import SwiftData

@main
struct OpenChat: App {
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            
            switch viewModel.appMode {
            case .ready:
                
                ContentView()
                    .environment(viewModel)
                    #if os(macOS)
                    .frame(minWidth: 500, minHeight: 450)
                    #endif
                    .modelContainer(
                        for: Chat.self,
                        isAutosaveEnabled: true
                    )
                
            case .setup(let loginURL):
                
                OnboardingView(
                    webLoginURL: loginURL
                )
                .environment(viewModel)
                #if os(macOS)
                .frame(width: 700, height: 550)
                #endif
            }
        }
        .windowResizability(.contentSize)
    }
}
