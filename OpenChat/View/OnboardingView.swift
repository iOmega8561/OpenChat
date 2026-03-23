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
        
    let webLoginURL: URL?
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("Configure Endpoint")
                .font(.largeTitle)
            
            TextField("https://your-openwebui", text: $urlString)
                .textFieldStyle(.roundedBorder)
            
            AsyncButton(verbatim: "Continue") {
                guard let url = URL(string: urlString) else { return }
                
                let endpoint = EndpointConfiguration(baseURL: url)
                viewModel.setEndpoint(endpoint)
                
                try await viewModel.initiateAuthFlow()
            }
        }
        .padding()
        .sheet(isPresented: .constant(webLoginURL != nil)) {
            WebLoginView(url: webLoginURL)
                .frame(idealWidth: 500, idealHeight: 500)
        }
    }
}
