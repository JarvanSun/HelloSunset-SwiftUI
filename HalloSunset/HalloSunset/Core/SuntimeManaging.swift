//
//  SuntimeManaging.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/6/7.
//

import Foundation
import CoreLocation

protocol SuntimeManaging {
    var coordinate: CLLocationCoordinate2D? { get set }
    
    func sunset(on date: Date) -> Date?
    func sunset(on dates: [Date]) -> [Date?]?
    func sunrise(on date: Date) -> Date?
    func sunrise(on dates: [Date]) -> [Date?]?
    
    // New methods with coordinate parameter
    func sunset(on date: Date, coordinate: CLLocationCoordinate2D) -> Date?
    func sunrise(on date: Date, coordinate: CLLocationCoordinate2D) -> Date?
}
