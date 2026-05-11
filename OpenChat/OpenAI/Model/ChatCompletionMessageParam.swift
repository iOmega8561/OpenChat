//
//  ChatCompletionMessageParam.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 27/04/2026.
//

import Foundation

struct ChatCompletionMessageParam: Encodable, Sendable {
    let content: String
    let role: String
}
