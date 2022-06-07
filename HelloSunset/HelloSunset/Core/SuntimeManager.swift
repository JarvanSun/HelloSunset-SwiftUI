//
//  SuntimeManager.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/6/7.
//

import Foundation
import CoreLocation
import Solar

struct SuntimeManager: SuntimeManaging {
    var coordinate: CLLocationCoordinate2D?
    
    func sunset(on date: Date) -> Date? {
        guard let coordinate = coordinate else {
            return nil
        }

        return Solar(for: date, coordinate: coordinate)?.sunset
    }
    
    func sunset(on dates: [Date]) -> [Date?]? {
        guard let coordinate = coordinate else {
            return nil
        }

        return dates.map {
            Solar(for: $0, coordinate: coordinate)?.sunset
        }
    }
    
    func sunrise(on date: Date) -> Date? {
        guard let coordinate = coordinate else {
            return nil
        }

        return Solar(for: date, coordinate: coordinate)?.sunrise
    }
    
    func sunrise(on dates: [Date]) -> [Date?]? {
        guard let coordinate = coordinate else {
            return nil
        }

        return dates.map {
            Solar(for: $0, coordinate: coordinate)?.sunrise
        }
    }
}

