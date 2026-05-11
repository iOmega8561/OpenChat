//
//  Models.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 24/03/26.
//

import Foundation

nonisolated struct Models: OpenAIDecodableBody {
    let data: [Model]
}
