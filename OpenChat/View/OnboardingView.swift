//
//  OnboardingView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Tools4SwiftUI

struct OnboardingView: View {
    @Environment(AppViewModel.self) private var viewModel
    
    @State private var urlString: String = ""
    @State private var token: String = ""
        
    let webLoginURL: URL?
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("title-connection")
                .font(.largeTitle)
            
            TextField("hint-connection-url", text: $urlString)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                #if !os(macOS)
                .textInputAutocapitalization(.never)
                #endif
            
            SecureField("hint-connection-token", text: $token)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                #if !os(macOS)
                .textInputAutocapitalization(.never)
                #endif
            
            AsyncButton("action-continue") {
                guard let url = URL(string: urlString) else { return }
                
                viewModel.setConfig(.init(
                    baseURL: url,
                    token: token
                ))
                
                try await viewModel.initiateAuthFlow()
            }
        }
        .frame(maxWidth: 400, maxHeight: 600)
        .padding()
        .sheet(isPresented: .constant(webLoginURL != nil)) {
            WebLoginView(url: webLoginURL)
                .frame(idealWidth: 350, idealHeight: 500)
        }
    }
}
