//
//  MainContainerView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI

struct MainContainerView: View {
    @Environment(AppViewModel.self) private var app
    
    var body: some View {
        NavigationSplitView {
            ChatListView(viewModel: app)
        } detail: {
            if let chat = app.selectedChat {
                ChatDetailView(chat: chat, endpoint: app.endpoint!)
            } else {
                Text("Select a chat")
            }
        }
    }
}
