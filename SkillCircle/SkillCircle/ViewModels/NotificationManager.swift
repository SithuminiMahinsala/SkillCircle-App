//
//  NotificationManager.swift
//  SkillCircle
//

import Foundation
import UserNotifications

/// NotificationManager handles local push notifications, user authorization,
/// and instant alert scheduling for tutoring sessions 
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // Permission Request
    func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting notification permission: \(error.localizedDescription)")
                }
                print("Notification permission granted: \(granted)")
                completion?(granted)
            }
        }
    }

    // Local Push Notification Trigger
    func sendSessionProposalNotification(tutorName: String, subject: String, timeString: String) {
        let content = UNMutableNotificationContent()
        content.title = "New Session Proposal!"
        content.subtitle = "\(subject) with \(tutorName)"
        content.body = "You received a new proposal scheduled for \(timeString). Tap to view and accept."
        content.sound = .default

        // Trigger in 3 seconds (simulating push delivery)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Local push notification successfully scheduled.")
            }
        }
    }

    // Foreground Handling
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        
        completionHandler([.banner, .sound, .badge])
    }
}