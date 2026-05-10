//
//  MessageView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Tools4SwiftUI

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
                DisclosureGroup {
                    markdownText(message.reasoning)
                        .foregroundStyle(.secondary)
                        .padding(.bottom)
                } label: {
                    Text("title-reasoning")
                    
                    if message.content.isEmpty {
                        ProgressView()
                            #if os(macOS)
                            .scaleEffect(0.5)
                            #endif
                    }
                }
            }
                        
            HStack {
                if message.role == .assistant {
                    markdownText(message.content)
                    Spacer()
                } else {
                    Spacer()
                    markdownText(message.content)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(.rect(cornerRadius: .bestRadius))
                }
            }
        }
    }
}
