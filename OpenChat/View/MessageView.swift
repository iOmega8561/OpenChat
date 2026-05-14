//
//  MessageView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI
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
    
    @ViewBuilder
    private func alignmentStack<T: View>(_ content: T) -> some View {
        HStack {
            if message.role == .assistant {
                content
                Spacer()
            } else {
                Spacer()
                content
                    .padding(12)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(.rect(cornerRadius: .bestRadius))
            }
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if message.role == .assistant,
               !message.reasoning.isEmpty {
                
                DisclosureGroup {
                    alignmentStack(
                        markdownText(message.reasoning)
                    )
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 4)
                    
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
                        
            alignmentStack(markdownText(message.content))
        }
    }
}
