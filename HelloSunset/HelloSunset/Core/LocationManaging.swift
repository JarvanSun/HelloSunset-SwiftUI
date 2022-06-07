//
//  LocationManaging.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/5/25.
//

import CoreLocation
import Combine

protocol LocationManaging {
    var authorizationStatusPublisher: PassthroughSubject<CLAuthorizationStatus, Never> { get }
    var locationPublisher: PassthroughSubject<CLLocation, Never> { get }
    
    func startUpdatingLocation()
}
