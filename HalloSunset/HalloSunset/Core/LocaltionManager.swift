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

    init(_ locationManager: CLLocationManager = .init()) {
        self.locationManager = locationManager
    }
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusPublisher.send(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationPublisher.send(location)
    }
}
