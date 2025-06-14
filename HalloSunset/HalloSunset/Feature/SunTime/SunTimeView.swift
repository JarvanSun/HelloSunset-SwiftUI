//
//  SunTimeView.swift
//  HalloSunset
//
//  Created by Claude on 2025/06/14.
//

import SwiftUI

struct SunTimeView: View {
    @ObservedObject var viewModel: SunTimeViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    background
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        headerSection
                        
                        Spacer()
                        
                        mainTimeDisplay
                        
                        countdownDisplay
                        
                        Spacer()
                        
                        notificationButton
                            .padding(.bottom, 50)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSettings) {
                NotificationSettingsView(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(viewModel.sunTimeType.emoji)
                .font(.system(size: 60))
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: UUID())
            
            Text("Next \(viewModel.sunTimeType.displayName)")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.top, 60)
    }
    
    private var mainTimeDisplay: some View {
        VStack(spacing: 12) {
            if let sunTime = viewModel.sunTime {
                Text(sunTime, style: .time)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            } else {
                Text("Loading...")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text("Today")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var countdownDisplay: some View {
        VStack(spacing: 8) {
            if !viewModel.countdown.isEmpty && viewModel.countdown != "Passed" {
                Text("Time remaining")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(viewModel.countdown)
                    .font(.system(size: 32, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                    .id("countdown-\(viewModel.countdown)")
            } else if viewModel.countdown == "Passed" {
                Text("\(viewModel.sunTimeType.displayName) has passed")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
    
    private var notificationButton: some View {
        Button(action: {
            showingSettings.toggle()
        }) {
            HStack(spacing: 12) {
                Image(systemName: viewModel.isNotificationEnabled ? "bell.fill" : "bell.slash")
                    .font(.title3)
                
                Text(viewModel.isNotificationEnabled ? "Notification On" : "Notification Off")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            )
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch viewModel.sunTimeType {
        case .sunrise:
            sunriseBackground
        case .sunset:
            sunsetBackground
        }
    }
    
    private var sunriseBackground: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [.blue.opacity(0.8), .purple.opacity(0.6), .black],
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                LinearGradient(
                    colors: [.yellow.opacity(0.3), .orange.opacity(0.4), .pink.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
    
    private var sunsetBackground: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [.purple.opacity(0.8), .indigo.opacity(0.6), .black],
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                LinearGradient(
                    colors: [.orange.opacity(0.6), .red.opacity(0.4), .purple.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
    }
}

// MARK: - Notification Settings View

struct NotificationSettingsView: View {
    @ObservedObject var viewModel: SunTimeViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let minuteOptions = [5, 10, 15, 30, 60]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(viewModel.sunTimeType.emoji) \(viewModel.sunTimeType.displayName) Notifications")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Toggle("Enable Notifications", isOn: .init(
                        get: { viewModel.isNotificationEnabled },
                        set: { _ in viewModel.toggleNotification() }
                    ))
                    .font(.headline)
                }
                
                if viewModel.isNotificationEnabled {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notify me before:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Picker("Minutes", selection: .init(
                            get: { viewModel.notificationMinutes },
                            set: { viewModel.updateNotificationMinutes($0) }
                        )) {
                            ForEach(minuteOptions, id: \.self) { minutes in
                                Text("\(minutes) minutes")
                                    .tag(minutes)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SunTimeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SunTimeView(viewModel: SunTimeViewModel(
                sunTimeType: .sunset,
                locationManager: LocationManager(),
                suntimeManager: SuntimeManager(),
                notificationManager: NotificationManager(),
                userSettings: UserSettings()
            ))
            
            SunTimeView(viewModel: SunTimeViewModel(
                sunTimeType: .sunrise,
                locationManager: LocationManager(),
                suntimeManager: SuntimeManager(),
                notificationManager: NotificationManager(),
                userSettings: UserSettings()
            ))
            .preferredColorScheme(.dark)
        }
    }
}
#endif