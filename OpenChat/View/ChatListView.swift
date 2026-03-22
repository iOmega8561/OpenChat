//
//  ChatListView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI

struct ChatListView: View {
    @Bindable var viewModel: AppViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedChat) {
            ForEach(viewModel.chats) { chat in
                Text(chat.title)
                    .tag(chat.id)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.createChat()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
