//
//  SunsetView.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/5/25.
//

import SwiftUI

struct SunsetView: View {
    @ObservedObject var viewModel: SunsetViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("🌇")
                        .font(.system(size: 60))
                        .padding(.top, 100)
                    
                    Text("Next Sunset")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    if let sunset = viewModel.sunsetToday {
                        Text(sunset, style: .time)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                    } else {
                        Text("Loading...")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    if !viewModel.sunsetCountdown.isEmpty && viewModel.sunsetCountdown != "Passed" {
                        Text("Time remaining")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(viewModel.sunsetCountdown)
                            .font(.system(size: 28, weight: .semibold, design: .monospaced))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                            .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                            .id("countdown-\(viewModel.sunsetCountdown)")
                    } else if viewModel.sunsetCountdown == "Passed" {
                        Text("Sunset has passed")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder private var background: some View {
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
