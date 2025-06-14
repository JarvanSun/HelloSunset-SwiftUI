//
//  UserSettings.swift
//  HalloSunset
//
//  Created by Claude on 2025/06/14.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var sunriseNotificationEnabled: Bool = false
    @Published var sunsetNotificationEnabled: Bool = false
    @Published var sunriseNotificationMinutes: Int = 15
    @Published var sunsetNotificationMinutes: Int = 15
    
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
    private enum Keys {
        static let sunriseNotificationEnabled = "sunriseNotificationEnabled"
        static let sunsetNotificationEnabled = "sunsetNotificationEnabled"
        static let sunriseNotificationMinutes = "sunriseNotificationMinutes"
        static let sunsetNotificationMinutes = "sunsetNotificationMinutes"
    }
    
    init() {
        loadSettings()
        setupBindings()
    }
    
    private func loadSettings() {
        sunriseNotificationEnabled = userDefaults.bool(forKey: Keys.sunriseNotificationEnabled)
        sunsetNotificationEnabled = userDefaults.bool(forKey: Keys.sunsetNotificationEnabled)
        sunriseNotificationMinutes = userDefaults.object(forKey: Keys.sunriseNotificationMinutes) as? Int ?? 15
        sunsetNotificationMinutes = userDefaults.object(forKey: Keys.sunsetNotificationMinutes) as? Int ?? 15
    }
    
    private func setupBindings() {
        $sunriseNotificationEnabled
            .sink { [weak self] value in
                self?.userDefaults.set(value, forKey: Keys.sunriseNotificationEnabled)
            }
            .store(in: &cancellables)
        
        $sunsetNotificationEnabled
            .sink { [weak self] value in
                self?.userDefaults.set(value, forKey: Keys.sunsetNotificationEnabled)
            }
            .store(in: &cancellables)
        
        $sunriseNotificationMinutes
            .sink { [weak self] value in
                self?.userDefaults.set(value, forKey: Keys.sunriseNotificationMinutes)
            }
            .store(in: &cancellables)
        
        $sunsetNotificationMinutes
            .sink { [weak self] value in
                self?.userDefaults.set(value, forKey: Keys.sunsetNotificationMinutes)
            }
            .store(in: &cancellables)
    }
}