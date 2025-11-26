//
//  NotificationManager.swift
//  HabitTimer
//
//  Created by najak on 11/26/25.
//

import SwiftUI
import UserNotifications
import CoreLocation

class NotificationManager: NSObject {
    static let instance = NotificationManager()
    var timeInterval: Double = 10
    private override init() {}
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            } else {
                UserDefaults.standard.set(granted, forKey: Config.NOTIFICATION_SETTING_ID)
            }
        }
    }
    
    func getNotificationSettings(requestHandler: @escaping(UNNotificationSettings) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            requestHandler(settings)
        }
    }
    
    enum TriggerType: String {
        case time = "Time"
        case calendar = "Calendar"
        case location = "Location"
        
        var trigger: UNNotificationTrigger {
            switch self {
            case .time:
                return UNTimeIntervalNotificationTrigger(timeInterval: NotificationManager.instance.timeInterval, repeats: false)
            case .calendar:
                let dateComponents = DateComponents(hour: 20, minute: 26, weekday: 2)
                return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            case .location:
                let coordinate = CLLocationCoordinate2D(latitude: 40.0, longitude: 50.0)
                let region = CLCircularRegion(center: coordinate, radius: 100, identifier: UUID().uuidString)
                region.notifyOnExit = false
                region.notifyOnEntry = true
                return UNLocationNotificationTrigger(region: region, repeats: true)
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func scheduleNotification(title: String, body: String, timeInterval: Double, triggerType: TriggerType) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = triggerType.trigger
        NotificationManager.instance.timeInterval = timeInterval
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        UNUserNotificationCenter.current().delegate = self
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
}
