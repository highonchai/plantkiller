import Foundation
import UserNotifications

// MARK: - Notification Service
// Handles local notifications for watering reminders

final class NotificationService {
    // MARK: - Singleton

    static let shared = NotificationService()

    // MARK: - Properties

    private let center = UNUserNotificationCenter.current()

    // MARK: - Notification Categories

    private enum Category {
        static let watering = "WATERING_REMINDER"
    }

    private enum Action {
        static let water = "WATER_ACTION"
        static let snooze = "SNOOZE_ACTION"
    }

    // MARK: - Initialization

    private init() {
        setupCategories()
    }

    private func setupCategories() {
        let waterAction = UNNotificationAction(
            identifier: Action.water,
            title: "Water Now",
            options: .foreground
        )

        let snoozeAction = UNNotificationAction(
            identifier: Action.snooze,
            title: "Remind Later",
            options: []
        )

        let wateringCategory = UNNotificationCategory(
            identifier: Category.watering,
            actions: [waterAction, snoozeAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )

        center.setNotificationCategories([wateringCategory])
    }

    // MARK: - Authorization

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error)")
            }
            completion(granted)
        }
    }

    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            let authorized = settings.authorizationStatus == .authorized
            completion(authorized)
        }
    }

    // MARK: - Schedule Notifications

    func scheduleWateringReminder(for plant: Plant) {
        guard let nextDate = calculateNextNotificationDate(for: plant) else { return }

        let content = createNotificationContent(for: plant)
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextDate),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: notificationId(for: plant),
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func scheduleBatchReminder(for plants: [Plant]) {
        guard !plants.isEmpty else { return }

        let content = UNMutableNotificationContent()

        if plants.count == 1 {
            let plant = plants[0]
            content.title = "Water \(plant.name)!"
            content.body = getNotificationMessage(for: plant)
        } else {
            let names = plants.prefix(3).map { $0.name }.joined(separator: ", ")
            let suffix = plants.count > 3 ? " and \(plants.count - 3) more" : ""
            content.title = "\(plants.count) plants need water!"
            content.body = "\(names)\(suffix) are getting thirsty."
        }

        content.sound = .default
        content.categoryIdentifier = Category.watering
        content.badge = plants.count as NSNumber

        // Schedule for user's preferred time
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: UserPreferences.shared.notificationTime)
        dateComponents.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(
            identifier: "batch_watering_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("Error scheduling batch notification: \(error)")
            }
        }
    }

    // MARK: - Cancel Notifications

    func cancelNotification(for plant: Plant) {
        center.removePendingNotificationRequests(withIdentifiers: [notificationId(for: plant)])
    }

    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }

    // MARK: - Update Badge

    func updateBadge(count: Int) {
        center.setBadgeCount(count) { error in
            if let error = error {
                print("Error updating badge: \(error)")
            }
        }
    }

    func clearBadge() {
        updateBadge(count: 0)
    }

    // MARK: - Helper Methods

    private func notificationId(for plant: Plant) -> String {
        "watering_\(plant.id.uuidString)"
    }

    private func calculateNextNotificationDate(for plant: Plant) -> Date? {
        let nextWateringDate = plant.nextWateringDate
        let preferredTime = UserPreferences.shared.notificationTime

        var components = Calendar.current.dateComponents([.year, .month, .day], from: nextWateringDate)
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: preferredTime)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute

        return Calendar.current.date(from: components)
    }

    private func createNotificationContent(for plant: Plant) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Water \(plant.name)!"
        content.body = getNotificationMessage(for: plant)
        content.sound = .default
        content.categoryIdentifier = Category.watering
        content.badge = 1 as NSNumber
        content.userInfo = ["plantId": plant.id.uuidString]

        return content
    }

    private func getNotificationMessage(for plant: Plant) -> String {
        let daysOverdue = -plant.daysUntilNextWatering

        // Snarky/funny notification messages based on escalation level
        switch daysOverdue {
        case ..<0:
            return "Time to water your \(plant.plantType?.commonName ?? "plant")! It's judging you right now."
        case 0:
            return "Your \(plant.name) is getting thirsty. Don't make it beg."
        case 1:
            return "\(plant.name) needed water yesterday. It's giving you the silent treatment."
        case 2:
            return "URGENT: \(plant.name) is getting crispy around the edges!"
        case 3:
            return "This is getting personal. \(plant.name) is plotting revenge."
        case 4:
            return "Day \(daysOverdue) without water. \(plant.name) is writing its will."
        case 5:
            return "At this point you're just watching \(plant.name) die slowly."
        default:
            return "This is your future: a plant graveyard. Water \(plant.name) NOW."
        }
    }
}

// MARK: - Notification Messages Database

extension NotificationService {
    struct NotificationCopy {
        static let day1Messages = [
            "Time to water your {plant}! It's judging you right now.",
            "Your {plant} is thirsty. It told me to tell you.",
            "Watering day! Your {plant} is counting on you.",
            "Hey plant killer - time to prove everyone wrong. Water {plant}!"
        ]

        static let day3Messages = [
            "URGENT: {plant} needs water NOW. This is getting personal.",
            "Your {plant} asked me to check if you're okay. It's worried about you.",
            "Day 3 without water. {plant} is starting to doubt your commitment.",
            "Plot twist: the plant you bought is still alive. Water it!"
        ]

        static let day5Messages = [
            "It's been 5 days. At this point you're just watching {plant} die slowly.",
            "{plant} is composing its last words. Water it before it's too late!",
            "Achievement unlocked: Neglectful Plant Parent. Just kidding, water {plant}!",
            "Your {plant} has trust issues now. Water it and start rebuilding."
        ]

        static let day7Messages = [
            "This is your future: an empty pot and regret. Water {plant}!",
            "The graveyard is waiting. Don't send {plant} there.",
            "Final warning: {plant} is on borrowed time.",
            "Even cacti need water sometimes. Especially if they're a {plant}!"
        ]

        static func randomMessage(for escalationLevel: Int, plantName: String) -> String {
            let messages: [String]
            switch escalationLevel {
            case 1: messages = day1Messages
            case 2...3: messages = day3Messages
            case 4...5: messages = day5Messages
            default: messages = day7Messages
            }

            let randomMessage = messages.randomElement() ?? day1Messages[0]
            return randomMessage.replacingOccurrences(of: "{plant}", with: plantName)
        }
    }
}
