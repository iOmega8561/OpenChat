//
//  ChatView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Tools4SwiftUI

struct ChatView: View {
    
    @Environment(AppViewModel.self)
    private var viewModel
    
    @Environment(Chat.self)
    private var chat
    
    @State
    private var currentMsg: String = ""
    
    private var sortedMessages: [Message] {
        chat.messages.sorted(by: { $0.createdAt < $1.createdAt })
    }
    
    var body: some View {

        VStack {
            ScrollView {
                ForEach(sortedMessages) { message in
                    MessageView(message: message)
                }
                .padding()
            }
            
            HStack {
                TextField("hint-message", text: $currentMsg)
                
                AsyncButton("action-send", allowsCancel: true) {
                    guard !currentMsg.isEmpty,
                          chat.model != nil else { return }
                    
                    chat.messages.append(.init(
                        role: .user,
                        content: currentMsg
                    ))
                    
                    currentMsg = ""
                    
                    try await viewModel.chatCompletion(streaming: chat)
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .buttonStyle(.borderedProminent)
        }
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    ForEach(viewModel.models) { model in
                        Button(model.id) {
                            chat.model = model
                        }
                    }
                } label: {
                    Text(chat.model?.id ??
                        .init(localized: "hint-select-model"))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(maxWidth: 250)
                }
            }
        }
        #if os(macOS)
        .navigationSubtitle(chat.title)
        #else
        .navigationTitle(chat.title)
        #endif
    }
}
