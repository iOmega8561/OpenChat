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
            ScrollView {
                ForEach(viewModel.chat.messages) { message in
                    MessageView(message: message)
                }
                .padding()
            }
            
            HStack {
                @Bindable var viewModel = viewModel
                TextField("hint-message", text: $viewModel.currentMessage.content)
                
                AsyncButton("action-send") {
                    try await viewModel.sendCurrentMessageStreaming()
                }
            }
            .padding()
        }
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    ForEach(models) { model in
                        Button(model.id) {
                            viewModel.setCurrentModel(model)
                        }
                    }
                } label: {
                    Text(viewModel.chat.model?.id ??
                        .init(localized: "hint-select-model"))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(maxWidth: 250)
                }
            }
        }
        #if os(macOS)
        .navigationSubtitle(viewModel.chat.title)
        #else
        .navigationTitle(viewModel.chat.title)
        #endif
    }
}
