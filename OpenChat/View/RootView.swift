//
//  RootView.swift
//  OpenChat
//
//  Created by Giuseppe Rocco on 22/03/26.
//

import SwiftUI

struct RootView: View {
    @Environment(AppViewModel.self) private var app
    
    var body: some View {
        if !app.isReady {
            OnboardingView()
        } else {
            MainContainerView()
        }
    }
}
