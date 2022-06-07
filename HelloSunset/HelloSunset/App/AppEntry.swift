//
//  AppEntry.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/5/25.
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
