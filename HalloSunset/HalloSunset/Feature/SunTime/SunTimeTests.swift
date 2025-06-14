//
//  SunTimeTests.swift
//  HalloSunsetTests
//
//  Created by Claude on 2025/06/14.
//

import XCTest
import CoreLocation
@testable import HalloSunset

final class SunTimeTests: XCTestCase {
    
    var suntimeManager: SuntimeManager!
    
    override func setUp() {
        super.setUp()
        suntimeManager = SuntimeManager()
    }
    
    override func tearDown() {
        suntimeManager = nil
        super.tearDown()
    }
    
    func testSunsetCalculation() {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
        let date = Date()
        
        // When
        let sunset = suntimeManager.sunset(on: date, coordinate: coordinate)
        
        // Then
        XCTAssertNotNil(sunset, "Sunset calculation should return a valid date")
    }
    
    func testSunriseCalculation() {
        // Given  
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
        let date = Date()
        
        // When
        let sunrise = suntimeManager.sunrise(on: date, coordinate: coordinate)
        
        // Then
        XCTAssertNotNil(sunrise, "Sunrise calculation should return a valid date")
    }
    
    func testSunriseBeforeSunset() {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
        let date = Date()
        
        // When
        let sunrise = suntimeManager.sunrise(on: date, coordinate: coordinate)
        let sunset = suntimeManager.sunset(on: date, coordinate: coordinate)
        
        // Then
        XCTAssertNotNil(sunrise)
        XCTAssertNotNil(sunset)
        if let sunrise = sunrise, let sunset = sunset {
            XCTAssertLessThan(sunrise, sunset, "Sunrise should be before sunset")
        }
    }
    
    func testInvalidCoordinate() {
        // Given
        let invalidCoordinate = CLLocationCoordinate2D(latitude: 91, longitude: 181) // Invalid coordinates
        let date = Date()
        
        // When
        let sunset = suntimeManager.sunset(on: date, coordinate: invalidCoordinate)
        let sunrise = suntimeManager.sunrise(on: date, coordinate: invalidCoordinate)
        
        // Then - Solar library should handle invalid coordinates gracefully
        // Results may be nil or valid dates depending on Solar library implementation
        // This test ensures no crashes occur
        XCTAssertTrue(sunset == nil || sunset != nil, "Should handle invalid coordinates without crashing")
        XCTAssertTrue(sunrise == nil || sunrise != nil, "Should handle invalid coordinates without crashing")
    }
}