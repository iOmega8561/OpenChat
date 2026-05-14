//
//  ContentView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Tools4SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.modelContext) private var context
    
    @State private var selection: Chat? = nil
    @State private var searchQuery: String = ""
    
    @Query(sort: \Chat.createdAt, order: .forward)
    private var chats: [Chat]
    
    private var filteredChats: [Chat] {
        chats.filter {
            $0.title.localizedStandardContains(searchQuery) || searchQuery.isEmpty
        }
    }
    
    var body: some View {
        
        NavigationSplitView {
            
            List(selection: $selection) {
                ForEach(filteredChats) { chat in
            
                    SidebarRow(chat: chat)
                }
                .onDelete { offsets in
                    offsets.forEach { context.delete(chats[$0]) }
                }
            }
            .searchable(text: $searchQuery, placement: .sidebar)
            
            .toolbar {
                #if !os(macOS)
                ToolbarItem {
                    EditButton()
                }
                #endif
                ToolbarItem(placement: .primaryAction) {
                    Button("action-new-chat", systemImage: "plus") {
                        let newChat = Chat()
                        context.insert(newChat)
                        selection = newChat
                    }
                }
            }
        } detail: {
            
            if let chat = selection {
                
                ChatView()
                    .id(chat.id)
                    .environment(chat)
                    .environment(viewModel)
                
            } else { Text("hint-select-chat") }
            
        }
        .bootstrapTask(handler: viewModel.fetchModels)
    }
}
