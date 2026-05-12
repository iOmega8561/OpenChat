//
//  Message.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation
import SwiftData

@Model
final class Message: Identifiable {
    
    enum Role: String, Codable {
        case system
        case user
        case developer
        case assistant
    }
    
    @Attribute(.unique)
    private(set) var id: UUID
    private(set) var chat: Chat?
    private(set) var createdAt: Date
    private(set) var role: Role
    
    var content: String
    var reasoning: String
    
    init(
        id: UUID = UUID(),
        role: Role,
        content: String = "",
        reasoning: String = "",
        createdAt: Date = .now
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.reasoning = reasoning
        self.createdAt = createdAt
    }
}
