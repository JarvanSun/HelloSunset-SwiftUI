//
//  ModernSunriseView.swift
//  HalloSunset
//
//  Created by Claude on 2025/06/14.
//

import SwiftUI
import CoreLocation

struct ModernSunriseView: View {
    @ObservedObject var locationManager: LocationManager
    let suntimeManager: SuntimeManager
    @State private var sunriseTime: Date?
    @State private var countdown: String = ""
    @State private var progress: Double = 0.0
    @State private var hasAppeared = false
    
    var body: some View {
        ZStack {
            // Modern background - single color with subtle overlay
            Color(red: 0.98, green: 0.95, blue: 0.87) // Warm cream
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with breathing space
                headerSection
                
                // Main content centered
                Spacer()
                mainTimeSection
                Spacer()
                
                // Bottom minimal info
                locationSection
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            .padding(.bottom, 40)
        }
        .onReceive(locationManager.locationPublisher) { location in
            updateSunriseTime(for: location.coordinate)
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            updateCountdown()
            updateProgress()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                hasAppeared = true
            }
        }
    }
    
    // MARK: - Modern UI Components
    
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("SUNRISE")
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                .letterSpacing(2)
                .opacity(hasAppeared ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: hasAppeared)
            
            // Minimalist sun indicator
            Circle()
                .fill(Color(red: 1.0, green: 0.42, blue: 0.21)) // Modern orange
                .frame(width: 8, height: 8)
                .scaleEffect(hasAppeared ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: hasAppeared)
        }
    }
    
    private var mainTimeSection: some View {
        VStack(spacing: 32) {
            // Progress ring
            ZStack {
                // Background ring
                Circle()
                    .stroke(Color.black.opacity(0.06), lineWidth: 2)
                    .frame(width: 200, height: 200)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color(red: 1.0, green: 0.42, blue: 0.21),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: progress)
                
                // Center content
                VStack(spacing: 12) {
                    if let sunrise = sunriseTime {
                        // Main time display with animated digits
                        Text(sunrise, style: .time)
                            .font(.system(size: 42, weight: .light, design: .rounded))
                            .foregroundColor(.black)
                            .monospacedDigit()
                            .animation(.easeInOut(duration: 0.3), value: sunrise)
                    } else {
                        // Loading state
                        VStack(spacing: 8) {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(Color(red: 1.0, green: 0.42, blue: 0.21))
                            
                            Text("Loading")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .opacity(hasAppeared ? 1 : 0)
            .scaleEffect(hasAppeared ? 1 : 0.9)
            .animation(.easeOut(duration: 0.8).delay(0.3), value: hasAppeared)
            
            // Countdown with modern typography
            if !countdown.isEmpty && countdown != "Passed" {
                VStack(spacing: 8) {
                    Text("TIME REMAINING")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundColor(.secondary)
                        .letterSpacing(1)
                    
                    Text(countdown)
                        .font(.system(size: 24, weight: .medium, design: .monospaced))
                        .foregroundColor(.primary)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.2), value: countdown)
                }
                .opacity(hasAppeared ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: hasAppeared)
            } else if countdown == "Passed" {
                VStack(spacing: 8) {
                    Text("✓")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.0, green: 0.78, blue: 0.46)) // Modern green
                    
                    Text("Sunrise has passed")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .opacity(hasAppeared ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: hasAppeared)
            }
        }
    }
    
    private var locationSection: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color(red: 0.0, green: 0.78, blue: 0.46))
                .frame(width: 6, height: 6)
            
            Text("San Francisco")
                .font(.system(.footnote, design: .rounded, weight: .medium))
                .foregroundColor(.secondary)
        }
        .opacity(hasAppeared ? 0.7 : 0)
        .animation(.easeOut(duration: 0.6).delay(0.8), value: hasAppeared)
    }
    
    // MARK: - Helper Functions
    
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
    
    private func updateProgress() {
        guard let sunrise = sunriseTime else {
            progress = 0
            return
        }
        
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        
        let totalDayInterval = 24 * 60 * 60.0 // 24 hours in seconds
        let elapsedInterval = now.timeIntervalSince(startOfDay)
        
        progress = min(elapsedInterval / totalDayInterval, 1.0)
    }
}

#if DEBUG
struct ModernSunriseView_Previews: PreviewProvider {
    static var previews: some View {
        ModernSunriseView(
            locationManager: LocationManager(),
            suntimeManager: SuntimeManager()
        )
    }
}
#endif