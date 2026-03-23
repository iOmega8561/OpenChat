//
//  MessageView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI

struct MessageView: View {
    
    let message: Message
    
    private var textContent: some View {
        if let attributed = try? AttributedString(
            markdown: message.content,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        ) {
            Text(attributed)
        } else {
            Text(message.content)
        }
    }
    
    var body: some View {
        
        HStack {
            if message.role == .assistant {
                textContent
                Spacer()
            } else {
                Spacer()
                textContent
            }
        }
    }
}
