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
            
            Text("Configure Endpoint")
                .font(.largeTitle)
            
            TextField("https://your-openwebui", text: $urlString)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
            
            SecureField("Your JWT Token or OpenAI token", text: $token)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
            
            AsyncButton(verbatim: "Continue") {
                guard let url = URL(string: urlString) else { return }
                
                viewModel.setEndpoint(EndpointConfiguration(
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
