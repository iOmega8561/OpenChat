//
//  Model.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import Foundation

struct Model: Identifiable, Codable, Hashable {
    let id: String
    let name: String?
    
    var label: String { name ?? id }
}
