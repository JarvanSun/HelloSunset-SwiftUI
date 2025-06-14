//
//  HalloSunsetApp.swift
//  HalloSunset
//
//  Created by Jiawen Sun on 14.08.24.
//

import SwiftUI
import CoreLocation

@main
struct AppEntry: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    private let suntimeManager = SuntimeManager()
    
    var body: some View {
        TabView {
            SunriseView(locationManager: locationManager, suntimeManager: suntimeManager)
                .tabItem {
                    Image(systemName: "sunrise")
                    Text("Sunrise")
                }
            
            SunsetView(viewModel: SunsetViewModel())
                .tabItem {
                    Image(systemName: "sunset")
                    Text("Sunset")
                }
        }
        .onAppear {
            locationManager.startUpdatingLocation()
        }
    }
}

struct SunriseView: View {
    @ObservedObject var locationManager: LocationManager
    let suntimeManager: SuntimeManager
    @State private var sunriseTime: Date?
    @State private var countdown: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                sunriseBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("🌅")
                        .font(.system(size: 60))
                        .padding(.top, 100)
                    
                    Text("Next Sunrise")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    if let sunrise = sunriseTime {
                        Text(sunrise, style: .time)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    } else {
                        Text("Loading...")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    if !countdown.isEmpty && countdown != "Passed" {
                        Text("Time remaining")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(countdown)
                            .font(.system(size: 28, weight: .semibold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .onReceive(locationManager.locationPublisher) { location in
            updateSunriseTime(for: location.coordinate)
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            updateCountdown()
        }
    }
    
    private var sunriseBackground: some View {
        LinearGradient(
            colors: [.yellow.opacity(0.3), .orange.opacity(0.4), .pink.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func updateSunriseTime(for coordinate: CLLocationCoordinate2D) {
        sunriseTime = suntimeManager.sunrise(on: Date(), coordinate: coordinate)
    }
    
    private func updateCountdown() {
        guard let sunrise = sunriseTime else { 
            countdown = ""
            return 
        }
        
        let timeInterval = sunrise.timeIntervalSince(Date())
        
        if timeInterval <= 0 {
            countdown = "Passed"
            return
        }
        
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            countdown = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            countdown = String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
