//
//  OnboardingView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Tools4SwiftUI

struct OnboardingView: View {
    @Environment(AppViewModel.self) private var app
    
    @State private var urlString: String = ""
        
    var body: some View {
      
        VStack(spacing: 20) {
            
            Text("Configure Endpoint")
                .font(.largeTitle)
            
            TextField("https://your-openwebui", text: $urlString)
                .textFieldStyle(.roundedBorder)
            
            AsyncButton(verbatim: "Continue") {
                guard let url = URL(string: urlString) else { return }
                
                let endpoint = EndpointConfiguration(baseURL: url)
                app.setEndpoint(endpoint)
                
                try await app.initiateAuthFlow()
            }
        }
        .padding()
        .sheet(isPresented: .constant(app.webLoginURL != nil)) {
            if let url = app.webLoginURL {
                WebLoginView(url: url)
                    .frame(idealWidth: 500, idealHeight: 500)
            }
        }
            
    }
}
