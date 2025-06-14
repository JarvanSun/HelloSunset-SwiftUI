//
//  OptimizedSunTimeView.swift
//  HalloSunset
//
//  Created by Claude on 2025/06/14.
//

import SwiftUI
import CoreLocation

struct OptimizedSunTimeView: View {
    let sunTimeType: SunTimeType
    @ObservedObject var locationManager: LocationManager
    let suntimeManager: SuntimeManager
    @State private var sunTime: Date?
    @State private var countdown: String = ""
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        headerSection(geometry: geometry)
                        
                        mainContentSection(geometry: geometry)
                        
                        bottomSection(geometry: geometry)
                    }
                }
            }
        }
        .onReceive(locationManager.locationPublisher) { location in
            updateSunTime(for: location.coordinate)
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            updateCountdown()
        }
        .onAppear {
            startPulseAnimation()
        }
    }
    
    // MARK: - View Components
    
    private func headerSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: geometry.safeAreaInsets.top + 40)
            
            // Animated emoji
            Text(sunTimeType.emoji)
                .font(.system(size: 80))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            Text("Next \(sunTimeType.displayName)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
        }
        .frame(height: geometry.size.height * 0.3)
    }
    
    private func mainContentSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 24) {
            // Time display with better layout
            timeDisplayCard
            
            // Countdown with enhanced styling
            if !countdown.isEmpty {
                countdownCard
            }
        }
        .frame(minHeight: geometry.size.height * 0.4)
        .padding(.horizontal, 24)
    }
    
    private func bottomSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            // Location info (optional)
            locationInfo
            
            Spacer()
                .frame(height: geometry.safeAreaInsets.bottom + 20)
        }
        .frame(height: geometry.size.height * 0.3)
    }
    
    private var timeDisplayCard: some View {
        VStack(spacing: 12) {
            if let sunTime = sunTime {
                Text(sunTime, style: .time)
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
                
                Text("Today")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.9))
            } else {
                // Enhanced loading state
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                    
                    Text("Calculating...")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }
    
    private var countdownCard: some View {
        VStack(spacing: 12) {
            if countdown != "Passed" {
                Text("Time remaining")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.8))
                
                Text(countdown)
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                    .id("countdown-\(countdown)")
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.white)
                    
                    Text("\(sunTimeType.displayName) has passed")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
        )
    }
    
    private var locationInfo: some View {
        HStack(spacing: 8) {
            Image(systemName: "location.fill")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            
            Text("San Francisco, CA") // Could be dynamic based on actual location
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
        )
    }
    
    private var backgroundGradient: some View {
        switch sunTimeType {
        case .sunrise:
            return AnyView(sunriseGradient)
        case .sunset:
            return AnyView(sunsetGradient)
        }
    }
    
    private var sunriseGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.8, blue: 0.0),      // Golden yellow
                Color(red: 1.0, green: 0.6, blue: 0.2),      // Orange
                Color(red: 1.0, green: 0.4, blue: 0.6),      // Pink
                Color(red: 0.8, green: 0.4, blue: 0.8)       // Light purple
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var sunsetGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.5, blue: 0.0),      // Deep orange
                Color(red: 1.0, green: 0.3, blue: 0.3),      // Red-orange
                Color(red: 0.8, green: 0.2, blue: 0.6),      // Magenta
                Color(red: 0.4, green: 0.2, blue: 0.8)       // Purple
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Helper Functions
    
    private func updateSunTime(for coordinate: CLLocationCoordinate2D) {
        switch sunTimeType {
        case .sunrise:
            sunTime = suntimeManager.sunrise(on: Date(), coordinate: coordinate)
        case .sunset:
            sunTime = suntimeManager.sunset(on: Date(), coordinate: coordinate)
        }
    }
    
    private func updateCountdown() {
        guard let sunTime = sunTime else {
            countdown = ""
            return
        }
        
        let timeInterval = sunTime.timeIntervalSince(Date())
        
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
    
    private func startPulseAnimation() {
        withAnimation {
            isAnimating = true
        }
    }
}

// MARK: - SunTimeType Extension

enum SunTimeType: String, CaseIterable {
    case sunrise = "sunrise"
    case sunset = "sunset"
    
    var displayName: String {
        switch self {
        case .sunrise:
            return "Sunrise"
        case .sunset:
            return "Sunset"
        }
    }
    
    var emoji: String {
        switch self {
        case .sunrise:
            return "🌅"
        case .sunset:
            return "🌇"
        }
    }
}

#if DEBUG
struct OptimizedSunTimeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OptimizedSunTimeView(
                sunTimeType: .sunrise,
                locationManager: LocationManager(),
                suntimeManager: SuntimeManager()
            )
            
            OptimizedSunTimeView(
                sunTimeType: .sunset,
                locationManager: LocationManager(),
                suntimeManager: SuntimeManager()
            )
            .preferredColorScheme(.dark)
        }
    }
}
#endif