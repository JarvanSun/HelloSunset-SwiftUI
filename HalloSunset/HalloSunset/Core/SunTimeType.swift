//
//  SunTimeType.swift
//  HalloSunset
//
//  Created by Claude on 2025/06/14.
//

import Foundation

enum SunTimeType: String, CaseIterable {
    case sunrise = "sunrise"
    case sunset = "sunset"
    
    var displayName: String {
        switch self {
        case .sunrise:
            return "Sunrise"
        case .sunset:
            return "Sunset"
        }
    }
    
    var emoji: String {
        switch self {
        case .sunrise:
            return "🌅"
        case .sunset:
            return "🌇"
        }
    }
    
    var notificationIdentifier: String {
        return "com.sunapp.HalloSunset.\(rawValue).notification"
    }
}