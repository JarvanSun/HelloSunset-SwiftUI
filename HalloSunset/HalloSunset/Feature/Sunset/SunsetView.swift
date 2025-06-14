//
//  SunsetView.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/5/25.
//

import SwiftUI

struct SunsetView: View {
    @ObservedObject var viewModel: SunsetViewModel
    @State private var progress: Double = 0.0
    @State private var hasAppeared = false
    
    var body: some View {
        ZStack {
            // Modern background - deep purple/indigo theme
            Color(red: 0.1, green: 0.1, blue: 0.2) // Deep navy
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
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
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
            Text("SUNSET")
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.8))
                .kerning(2)
                .opacity(hasAppeared ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: hasAppeared)
            
            // Minimalist sun indicator
            Circle()
                .fill(Color(red: 0.4, green: 0.35, blue: 0.8)) // Deep purple
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
                    .stroke(Color.white.opacity(0.06), lineWidth: 2)
                    .frame(width: 200, height: 200)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color(red: 0.4, green: 0.35, blue: 0.8),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: progress)
                
                // Center content
                VStack(spacing: 12) {
                    if let sunset = viewModel.sunsetToday {
                        // Main time display with animated digits
                        Text(sunset, style: .time)
                            .font(.system(size: 42, weight: .light, design: .rounded))
                            .foregroundColor(.white)
                            .monospacedDigit()
                            .animation(.easeInOut(duration: 0.3), value: sunset)
                    } else {
                        // Loading state
                        VStack(spacing: 8) {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(Color(red: 0.4, green: 0.35, blue: 0.8))
                            
                            Text("Loading")
                                .font(.system(.caption, design: .rounded, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
            }
            .opacity(hasAppeared ? 1 : 0)
            .scaleEffect(hasAppeared ? 1 : 0.9)
            .animation(.easeOut(duration: 0.8).delay(0.3), value: hasAppeared)
            
            // Countdown with modern typography
            if !viewModel.sunsetCountdown.isEmpty && viewModel.sunsetCountdown != "Passed" {
                VStack(spacing: 8) {
                    Text("TIME REMAINING")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .kerning(1)
                    
                    Text(viewModel.sunsetCountdown)
                        .font(.system(size: 24, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.2), value: viewModel.sunsetCountdown)
                }
                .opacity(hasAppeared ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: hasAppeared)
            } else if viewModel.sunsetCountdown == "Passed" {
                VStack(spacing: 8) {
                    Text("✓")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.0, green: 0.78, blue: 0.46)) // Modern green
                    
                    Text("Sunset has passed")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
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
                .foregroundColor(.white.opacity(0.6))
        }
        .opacity(hasAppeared ? 0.7 : 0)
        .animation(.easeOut(duration: 0.6).delay(0.8), value: hasAppeared)
    }
    
    // MARK: - Helper Functions
    
    private func updateProgress() {
        guard viewModel.sunsetToday != nil else {
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
struct SunsetView_Previews: PreviewProvider {
    @StateObject static var vm = SunsetViewModel()
    
    static var previews: some View {
        Group {
            SunsetView(viewModel: vm)
            SunsetView(viewModel: vm)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
