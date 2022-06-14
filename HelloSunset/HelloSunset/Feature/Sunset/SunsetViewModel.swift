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
    @Published var sunsetToday: Date?
    
    @Published var sunsetWeeks: [Date]?
    @Published var sunsetCountdown: String = ""
    @Published var coordinate: CLLocationCoordinate2D?
    
    private let resolver: SunsetDependencyResolving
    private var cancellables: Set<AnyCancellable> = []
    
    init(resolver: SunsetDependencyResolving = SunsetDependencyResolver()) {
        self.resolver = resolver
        
        start()
    }
    
    private func start() {
        register()
        resolver.locationManager.startUpdatingLocation()
    }
    
    func register() {
        resolver.locationManager.locationPublisher
            .map { $0.coordinate }
            .assign(to: &$coordinate)
        
        $coordinate.sink { [weak self] coordinate in
            if let coordinate = coordinate {
                self?.resolver.suntimeManager.coordinate = coordinate
                self?.sunsetToday = self?.resolver.suntimeManager.sunset(on: Date())
            }
        }
        .store(in: &cancellables)
        
        resolver.timer
            .autoconnect()
            .map { [weak self] _ in
                self?.sunsetToday?.timeIntervalSince(Date()).HHmmss() ?? ""
            }
            .assign(to: &$sunsetCountdown)
    }
}

