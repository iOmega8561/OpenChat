//
//  SidebarRow.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 10/04/2026.
//

import SwiftUI

struct SidebarRow: View {
    
    @Bindable var chat: Chat
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        NavigationLink(value: chat) {

            TextField(text: $chat.title) {
                Text(verbatim: "Chat name")
            }
            .autocorrectionDisabled(true)
            .focused($isFocused)
        }
        .id(chat.id)
        .contextMenu {
            RenameButton()
        }
        .renameAction { isFocused = true }
    }
    
}
