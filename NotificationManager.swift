import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                self.scheduleDailyNotification()
            }
        }
    }

    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "أذكار الصباح والمساء 🌿"
        content.body = "لا تنس ذكر الله اليوم لتطمئن قلبك."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 6
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_adhkar", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}