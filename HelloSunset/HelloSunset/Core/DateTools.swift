//
//  DateTools.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/6/7.
//

import Foundation

extension TimeInterval {
    func HHmmss() -> String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = interval / 3600
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
