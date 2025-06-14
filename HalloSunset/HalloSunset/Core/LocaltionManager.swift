//
//  LocaltionManager.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/5/25.
//

import CoreLocation
import Combine

class LocationManager: NSObject, LocationManaging, CLLocationManagerDelegate, ObservableObject {
    let authorizationStatusPublisher = PassthroughSubject<CLAuthorizationStatus, Never>()
    let locationPublisher = PassthroughSubject<CLLocation, Never>()

    private let locationManager: CLLocationManager
    
    // Default test coordinates for simulator (San Francisco)
    private let defaultTestLocation = CLLocation(
        latitude: 37.7749,  // San Francisco latitude
        longitude: -122.4194 // San Francisco longitude
    )

    init(_ locationManager: CLLocationManager = .init()) {
        self.locationManager = locationManager
    }
    
    func startUpdatingLocation() {
        #if targetEnvironment(simulator)
        // For simulator, immediately provide test location
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.locationPublisher.send(self.defaultTestLocation)
            self.authorizationStatusPublisher.send(.authorizedWhenInUse)
        }
        #else
        // For real device, use actual location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        #endif
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusPublisher.send(status)
        
        // If authorized, immediately send test location for simulator
        #if targetEnvironment(simulator)
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationPublisher.send(defaultTestLocation)
        }
        #endif
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationPublisher.send(location)
    }
}
