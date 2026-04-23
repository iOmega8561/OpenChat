//
//  MessageView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI

struct MessageView: View {
    
    let message: Message
        
    private func markdownText(_ content: String) -> Text {
        if let attributed = try? AttributedString(
            markdown: content,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        ) {
            return Text(attributed)
        } else {
            return Text(content)
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if message.role == .assistant,
               !message.reasoning.isEmpty {
                DisclosureGroup("Reasoning") {
                    markdownText(message.reasoning)
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                }
            }
                        
            HStack {
                if message.role == .assistant {
                    markdownText(message.content)
                    Spacer()
                } else {
                    Spacer()
                    markdownText(message.content)
                }
            }
        }
    }
}
