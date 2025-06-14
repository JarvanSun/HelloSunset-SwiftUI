//
//  MainTabView.swift
//  HalloSunset
//
//  Created by Claude on 2025/06/14.
//

import SwiftUI
import Combine

struct MainTabView: View {
    @StateObject private var userSettings = UserSettings()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var notificationManager = NotificationManager()
    
    private let suntimeManager = SuntimeManager()
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        TabView {
            SunTimeView(viewModel: SunTimeViewModel(
                sunTimeType: .sunrise,
                locationManager: locationManager,
                suntimeManager: suntimeManager,
                notificationManager: notificationManager,
                userSettings: userSettings
            ))
            .tabItem {
                Image(systemName: "sunrise")
                Text("Sunrise")
            }
            
            SunTimeView(viewModel: SunTimeViewModel(
                sunTimeType: .sunset,
                locationManager: locationManager,
                suntimeManager: suntimeManager,
                notificationManager: notificationManager,
                userSettings: userSettings
            ))
            .tabItem {
                Image(systemName: "sunset")
                Text("Sunset")
            }
        }
        .onAppear {
            requestNotificationPermission()
        }
    }
    
    private func requestNotificationPermission() {
        notificationManager.requestPermission()
            .sink { granted in
                if !granted {
                    print("Notification permission not granted")
                }
            }
            .store(in: &cancellables)
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
#endif