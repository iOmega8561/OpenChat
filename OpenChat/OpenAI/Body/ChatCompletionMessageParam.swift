//
//  ChatCompletionMessageParam.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 27/04/2026.
//

import Foundation

nonisolated struct ChatCompletionMessageParam: EncodableBody {
    let content: String
    let role: String
}
