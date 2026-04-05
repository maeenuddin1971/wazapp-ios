import Foundation
import Observation

// ══════════════════════════════════════════════════════════════════════════
// MARK: - NotificationsViewModel
// ══════════════════════════════════════════════════════════════════════════

@MainActor
@Observable
final class NotificationsViewModel {

    // MARK: - Data

    private(set) var notifications: [NotificationItemModel] = NotificationsViewModel.seedNotifications

    // MARK: - Filter State

    var selectedFilter = "All"

    let filters = ["All", "Events", "Reminders", "System"]

    // MARK: - Derived Data

    var filteredNotifications: [NotificationItemModel] {
        switch selectedFilter {
        case "Events":    return notifications.filter { $0.type == .event || $0.type == .maulana }
        case "Reminders": return notifications.filter { $0.type == .reminder }
        case "System":    return notifications.filter { $0.type == .system || $0.type == .community }
        default:          return notifications
        }
    }

    var unreadCount: Int {
        notifications.count(where: { !$0.isRead })
    }

    // MARK: - Actions

    func markAsRead(_ notificationId: Int) {
        guard let index = notifications.firstIndex(where: { $0.id == notificationId }) else { return }
        notifications[index].isRead = true
    }

    func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }

    // MARK: - Seed Data (replace with API call later)

    private static let seedNotifications: [NotificationItemModel] = [
        NotificationItemModel(id: 1, title: "New Event Added",
            message: "Friday Waz Mahfil by Maulana Abdul Karim has been scheduled at Dhaka Central Mosque. Don't miss this enlightening session!",
            time: "2 min ago", type: .event, relatedId: 1),
        NotificationItemModel(id: 2, title: "Event Starting Soon",
            message: "Tafseer Al-Quran session by Maulana Tariq Jameel is starting in 30 minutes at Baitul Mukarram National Mosque.",
            time: "30 min ago", type: .reminder, relatedId: 2),
        NotificationItemModel(id: 3, title: "Maulana Hassan Ali",
            message: "Maulana Hassan Ali has been verified and joined the platform. Follow to get updates about upcoming events.",
            time: "1 hour ago", type: .maulana, isRead: true, relatedId: 3),
        NotificationItemModel(id: 4, title: "Seerah Conference Update",
            message: "The venue for the Seerah Conference has been updated to Chittagong Grand Masjid. Please check the event details for more info.",
            time: "2 hours ago", type: .event, isRead: true, relatedId: 3),
        NotificationItemModel(id: 5, title: "Welcome to MahfilHub!",
            message: "Assalamu Alaikum! Welcome to MahfilHub. Explore events, follow your favorite scholars, and stay connected with the community.",
            time: "3 hours ago", type: .system, isRead: true),
        NotificationItemModel(id: 6, title: "Community Milestone",
            message: "MahfilHub has reached 10,000 active users! JazakAllah Khair for being a part of this growing community.",
            time: "1 day ago", type: .community, isRead: true),
        NotificationItemModel(id: 7, title: "Reminder: Youth Islamic Seminar",
            message: "Don't forget the Youth Islamic Seminar tomorrow at 3:00 PM at Sylhet Central Eidgah. Set your reminder now!",
            time: "1 day ago", type: .reminder, isRead: true, relatedId: 4),
        NotificationItemModel(id: 8, title: "New Feature: Event Reminders",
            message: "You can now set reminders for upcoming events. Tap the bell icon on any event to get notified before it starts.",
            time: "2 days ago", type: .system, isRead: true)
    ]
}
