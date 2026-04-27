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
            
            Text("Configure Connection")
                .font(.largeTitle)
            
            TextField("https://your-openai-url.com", text: $urlString)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                #if !os(macOS)
                .textInputAutocapitalization(.never)
                #endif
            
            SecureField("Your JWT Token or OpenAI token", text: $token)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                #if !os(macOS)
                .textInputAutocapitalization(.never)
                #endif
            
            AsyncButton(verbatim: "Continue") {
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
