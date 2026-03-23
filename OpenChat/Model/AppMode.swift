//
//  AppMode.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 23/03/26.
//

import Foundation

enum AppMode {
    case ready
    case setup(loginAt: URL? = nil)
}
