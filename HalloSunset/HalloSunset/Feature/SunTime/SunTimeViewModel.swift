//
//  SunTimeViewModel.swift
//  HalloSunset
//
//  Created by Claude on 2025/06/14.
//

import Foundation
import Combine
import CoreLocation

final class SunTimeViewModel: ObservableObject {
    @Published var sunTime: Date?
    @Published var countdown: String = ""
    @Published var coordinate: CLLocationCoordinate2D?
    @Published var isNotificationEnabled: Bool = false
    @Published var notificationMinutes: Int = 15
    
    let sunTimeType: SunTimeType
    
    private let locationManager: LocationManaging
    private let suntimeManager: SuntimeManaging
    private let notificationManager: NotificationManaging
    private let userSettings: UserSettings
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private var cancellables = Set<AnyCancellable>()
    
    init(
        sunTimeType: SunTimeType,
        locationManager: LocationManaging,
        suntimeManager: SuntimeManaging,
        notificationManager: NotificationManaging,
        userSettings: UserSettings,
        timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    ) {
        self.sunTimeType = sunTimeType
        self.locationManager = locationManager
        self.suntimeManager = suntimeManager
        self.notificationManager = notificationManager
        self.userSettings = userSettings
        self.timer = timer
        
        setupBindings()
        start()
    }
    
    private func start() {
        locationManager.startUpdatingLocation()
    }
    
    private func setupBindings() {
        // Location updates
        locationManager.locationPublisher
            .map { $0.coordinate }
            .assign(to: &$coordinate)
        
        // Sun time calculation
        $coordinate
            .compactMap { $0 }
            .sink { [weak self] coordinate in
                self?.updateSunTime(for: coordinate)
            }
            .store(in: &cancellables)
        
        // Countdown timer
        timer
            .map { [weak self] _ in
                self?.calculateCountdown() ?? ""
            }
            .assign(to: &$countdown)
        
        // Notification settings binding
        switch sunTimeType {
        case .sunrise:
            userSettings.$sunriseNotificationEnabled
                .assign(to: &$isNotificationEnabled)
            userSettings.$sunriseNotificationMinutes
                .assign(to: &$notificationMinutes)
        case .sunset:
            userSettings.$sunsetNotificationEnabled
                .assign(to: &$isNotificationEnabled)
            userSettings.$sunsetNotificationMinutes
                .assign(to: &$notificationMinutes)
        }
        
        // Schedule notifications when settings change
        Publishers.CombineLatest3($sunTime, $isNotificationEnabled, $notificationMinutes)
            .sink { [weak self] sunTime, enabled, minutes in
                self?.updateNotification(sunTime: sunTime, enabled: enabled, minutes: minutes)
            }
            .store(in: &cancellables)
    }
    
    private func updateSunTime(for coordinate: CLLocationCoordinate2D) {
        let date = Date()
        
        switch sunTimeType {
        case .sunrise:
            sunTime = suntimeManager.sunrise(on: date, coordinate: coordinate)
        case .sunset:
            sunTime = suntimeManager.sunset(on: date, coordinate: coordinate)
        }
    }
    
    private func calculateCountdown() -> String {
        guard let sunTime = sunTime else { return "" }
        
        let timeInterval = sunTime.timeIntervalSince(Date())
        
        if timeInterval <= 0 {
            return "Passed"
        }
        
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func updateNotification(sunTime: Date?, enabled: Bool, minutes: Int) {
        notificationManager.cancelNotification(for: sunTimeType)
        
        guard enabled, let sunTime = sunTime else { return }
        
        notificationManager.scheduleNotification(
            for: sunTimeType,
            at: sunTime,
            minutesBefore: minutes
        )
    }
    
    // MARK: - Public Methods
    
    func toggleNotification() {
        switch sunTimeType {
        case .sunrise:
            userSettings.sunriseNotificationEnabled.toggle()
        case .sunset:
            userSettings.sunsetNotificationEnabled.toggle()
        }
    }
    
    func updateNotificationMinutes(_ minutes: Int) {
        switch sunTimeType {
        case .sunrise:
            userSettings.sunriseNotificationMinutes = minutes
        case .sunset:
            userSettings.sunsetNotificationMinutes = minutes
        }
    }
}