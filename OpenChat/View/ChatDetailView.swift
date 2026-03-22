//
//  ChatDetailView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI

struct ChatDetailView: View {
    @State private var viewModel: ChatViewModel
    
    init(chat: Chat, endpoint: EndpointConfiguration) {
        let service = OpenAIService(endpoint: endpoint)
        _viewModel = State(initialValue: ChatViewModel(chat: chat, service: service))
    }
    
    var body: some View {
        VStack {
            List(viewModel.chat.messages) { message in
                MessageRowView(message: message)
            }
            
            HStack {
                TextField("Message", text: $viewModel.input)
                
                Button("Send") {
                    Task {
                        await viewModel.send()
                    }
                }
            }
            .padding()
        }
    }
}
