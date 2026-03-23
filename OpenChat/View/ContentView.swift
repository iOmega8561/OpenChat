//
//  ContentView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Tools4SwiftUI

struct ContentView: View {
    
    @Environment(AppViewModel.self) private var viewModel
    
    @State private var selection: Chat? = nil
    
    var body: some View {
        
        NavigationSplitView {
            
            List(viewModel.chats, selection: $selection) { chat in
                NavigationLink(value: chat) {
                    Text(chat.title)
                }
                .id(chat.id)
            }
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Chat", systemImage: "plus") {
                        selection = viewModel.createChat()
                    }
                }
            }
            
        } detail: {
            
            if let endpoint = viewModel.endpoint,
               let chat = selection {
                
                ChatView(models: viewModel.models)
                    .id(chat.id)
                    .environment(ChatViewModel(
                        chat: chat,
                        service: .init(endpoint)
                    ))
                
            } else { Text("Select a chat") }
            
        }
        .bootstrapTask(handler: viewModel.fetchModels)
    }
}
