//
//  Chat.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

import SwiftData

@Model
final class Chat: Identifiable {
    
    @Attribute(.unique)
    private(set) var id: UUID
    private(set) var createdAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Message.chat)
    var messages: [Message]
    var model: Model?
    var title: String
    
    init(
        id: UUID = UUID(),
        title: String = .init(localized: "title-new-chat"),
        messages: [Message] = [],
        createdAt: Date = .now,
    ) {
        self.id = id
        self.title = title
        self.messages = messages
        self.createdAt = createdAt
    }
}
