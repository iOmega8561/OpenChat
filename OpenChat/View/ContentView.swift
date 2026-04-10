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
    @State private var searchQuery: String = ""
    
    private var filteredChats: [Chat] {
        searchQuery.isEmpty ? viewModel.chats :
                              viewModel.chats.filter { $0.title.localizedStandardContains(searchQuery) }
    }
    
    var body: some View {
        
        NavigationSplitView {
            
            List(selection: $selection) {
                ForEach(filteredChats) { chat in
            
                    SidebarRow(chat: chat)
                }
                .onDelete(perform: viewModel.deleteChats)
            }
            .searchable(text: $searchQuery, placement: .sidebar)
            
            .toolbar {
                #if !os(macOS)
                ToolbarItem {
                    EditButton()
                }
                #endif
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
