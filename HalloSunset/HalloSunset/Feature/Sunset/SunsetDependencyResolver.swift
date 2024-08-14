//
//  SunsetDependencyResolver.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/6/7.
//

import Foundation

class SunsetDependencyResolver: SunsetDependencyResolving {
    var locationManager: LocationManaging = LocationManager()
    
    var suntimeManager: SuntimeManaging = SuntimeManager()
    
    var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)

}
