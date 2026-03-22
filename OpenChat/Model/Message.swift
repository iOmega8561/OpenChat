//
//  Message.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct Message: Identifiable, Codable, Hashable {
    enum Role: String, Codable {
        case system
        case user
        case assistant
    }
    
    let id: UUID
    let role: Role
    var content: String
    let createdAt: Date
    
    init(
        id: UUID = UUID(),
        role: Role,
        content: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.createdAt = createdAt
    }
}
