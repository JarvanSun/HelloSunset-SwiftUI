//
//  SunsetDependencyResolving.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/6/7.
//

import Foundation
import Combine

protocol SunsetDependencyResolving: AnyObject {
    var locationManager: LocationManaging { get }
    var suntimeManager: SuntimeManaging { get set }
    var timer: Timer.TimerPublisher { get }
}
