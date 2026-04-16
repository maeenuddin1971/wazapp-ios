import Foundation
import Observation

// ══════════════════════════════════════════════════════════════════════════
// MARK: - ReminderItem Model
// ══════════════════════════════════════════════════════════════════════════

struct ReminderItem: Identifiable, Hashable {
    let id: Int
    let eventTitle: String
    let maulana: String
    let date: String
    let time: String
    let location: String
    let reminderTime: String
    let daysUntil: Int

    init(id: Int, eventTitle: String, maulana: String, date: String,
         time: String, location: String, reminderTime: String,
         daysUntil: Int = 0) {
        self.id = id
        self.eventTitle = eventTitle
        self.maulana = maulana
        self.date = date
        self.time = time
        self.location = location
        self.reminderTime = reminderTime
        self.daysUntil = daysUntil
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - MyRemindersViewModel
// ══════════════════════════════════════════════════════════════════════════

@MainActor
@Observable
final class MyRemindersViewModel {

    // MARK: - Data

    private(set) var reminders: [ReminderItem] = MyRemindersViewModel.seedReminders

    // MARK: - Derived Data

    var totalReminders: Int { reminders.count }

    // MARK: - Seed Data (replace with API call later)

    private static let seedReminders: [ReminderItem] = [
        ReminderItem(
            id: 1, eventTitle: "Friday Waz Mahfil", maulana: "Maulana Abdul Karim",
            date: "Apr 18, 2026", time: "After Jummah",
            location: "Dhaka Central Mosque", reminderTime: "1 hour before", daysUntil: 5
        ),
        ReminderItem(
            id: 2, eventTitle: "Tafseer Al-Quran", maulana: "Maulana Tariq Jameel",
            date: "Apr 20, 2026", time: "After Maghrib",
            location: "Baitul Mukarram", reminderTime: "30 min before", daysUntil: 7
        ),
        ReminderItem(
            id: 3, eventTitle: "Seerah Conference", maulana: "Maulana Hassan Ali",
            date: "Apr 25, 2026", time: "10:00 AM",
            location: "Chittagong Grand Masjid", reminderTime: "1 day before", daysUntil: 12
        ),
    ]
}
