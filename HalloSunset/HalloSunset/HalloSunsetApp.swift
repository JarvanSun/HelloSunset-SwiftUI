//
//  HalloSunsetApp.swift
//  HalloSunset
//
//  Created by Jiawen Sun on 14.08.24.
//

import SwiftUI

@main
struct AppEntry: App {
    var body: some Scene {
        WindowGroup {
            SunsetView(viewModel: .init())
        }
    }
}
