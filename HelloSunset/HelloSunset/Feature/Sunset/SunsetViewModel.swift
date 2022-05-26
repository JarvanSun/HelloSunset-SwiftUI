//
//  SunsetViewModel.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/5/25.
//

import Combine
import CoreLocation
import Solar

final class SunsetViewModel: ObservableObject {
    let locationManager: LocationManaging
    @Published var sunsetTime: Date?
    @Published var sunriseTime: Date?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ locationManager: LocationManaging = LocationManager()) {
        self.locationManager = locationManager
        
        addObservers()
    }
    
    private func addObservers() {
        self.locationManager.locationPublisher
            .sink { local in
                if let sunset = Solar(for: Date(), coordinate: local.coordinate)?.sunset
                {
                    self.sunsetTime = sunset
                }
            }
            .store(in: &cancellables)
    }
}

