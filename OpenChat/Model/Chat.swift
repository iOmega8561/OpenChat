//
//  Chat.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

@Observable
final class Chat: Identifiable, Codable {
    
    let id: UUID
    var title: String
    var messages: [Message]
    var createdAt: Date
    var model: Model?
    
    init(
        id: UUID = UUID(),
        title: String = "New Chat",
        messages: [Message] = [],
        createdAt: Date = .now,
    ) {
        self.id = id
        self.title = title
        self.messages = messages
        self.createdAt = createdAt
    }
}

extension Chat: Equatable {
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
    }
}

extension Chat: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
