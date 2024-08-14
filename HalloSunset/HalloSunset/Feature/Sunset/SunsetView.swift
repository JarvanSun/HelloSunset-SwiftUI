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
        VStack {
            Text("Enjoy the sunset at")
                .padding(.top, 36.0)
            
            Spacer().frame(height: 30.0)
            
            if let sunset = viewModel.sunsetToday {
                Text(sunset, style: .time)
            }
            
            Spacer()
        }
        .font(.largeTitle)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(background.ignoresSafeArea())
        .overlay(countDownText)
    }
    
    @ViewBuilder private var background: some View {
        if colorScheme == .dark {
            Color.gray
        } else {
            LinearGradient(
                gradient: .init(colors: [.orange, .yellow, .orange]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var countDownText: some View {
        Text(viewModel.sunsetCountdown)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .scaleEffect(1.5)
            .foregroundColor(.white)
            .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .id("CountDownId" + viewModel.sunsetCountdown)
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
