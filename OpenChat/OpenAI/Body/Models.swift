//
//  Models.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 24/03/26.
//

import Foundation

nonisolated struct Models: DecodableBody {
    
    nonisolated struct Model: DecodableBody {
        let id: String
        let created: Date
        let owned_by: String
    }
    
    let data: [Model]
}
