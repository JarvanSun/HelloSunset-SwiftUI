//
//  NotificationManager.swift
//  HalloSunset
//
//  Created by Claude on 2025/06/14.
//

import Foundation
import UserNotifications
import Combine

protocol NotificationManaging {
    func requestPermission() -> AnyPublisher<Bool, Never>
    func scheduleNotification(for sunTimeType: SunTimeType, at date: Date, minutesBefore: Int)
    func cancelNotification(for sunTimeType: SunTimeType)
    func cancelAllNotifications()
}

class NotificationManager: NotificationManaging {
    private let center = UNUserNotificationCenter.current()
    
    func requestPermission() -> AnyPublisher<Bool, Never> {
        Future { promise in
            self.center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                promise(.success(granted))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func scheduleNotification(for sunTimeType: SunTimeType, at date: Date, minutesBefore: Int) {
        let content = UNMutableNotificationContent()
        content.title = "\(sunTimeType.emoji) \(sunTimeType.displayName) Reminder"
        content.body = "\(sunTimeType.displayName) is in \(minutesBefore) minutes!"
        content.sound = .default
        
        let notificationDate = date.addingTimeInterval(-TimeInterval(minutesBefore * 60))
        
        guard notificationDate > Date() else { return }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: sunTimeType.notificationIdentifier,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
    
    func cancelNotification(for sunTimeType: SunTimeType) {
        center.removePendingNotificationRequests(withIdentifiers: [sunTimeType.notificationIdentifier])
    }
    
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }
}