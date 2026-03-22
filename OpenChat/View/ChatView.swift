//
//  ChatView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Tools4SwiftUI

struct ChatView: View {
    
    @Environment(ChatViewModel.self) private var viewModel
    
    let models: [Model]
    
    var body: some View {

        VStack {
            
            List(viewModel.chat.messages) { message in
                MessageView(message: message)
            }
            
            HStack {
                @Bindable var viewModel = viewModel
                TextField("Message", text: $viewModel.currentMessage.content)
                
                AsyncButton(verbatim: "Send") {
                    try await viewModel.sendCurrentMessage()
                }
            }
            .padding()
        }
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu(viewModel.chat.model?.label ?? "Select a model") {
                    ForEach(models) { model in
                        Button(model.label) {
                            viewModel.setCurrentModel(model)
                        }
                    }
                }
            }
        }
    }
}
