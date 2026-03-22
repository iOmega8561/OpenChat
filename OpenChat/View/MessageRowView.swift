//
//  MessageRowView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI

struct MessageRowView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.role == .assistant {
                Text(message.content)
                Spacer()
            } else {
                Spacer()
                Text(message.content)
            }
        }
    }
}
