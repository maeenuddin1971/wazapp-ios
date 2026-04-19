import Foundation
import Observation

// ══════════════════════════════════════════════════════════════════════════
// MARK: - HistoryEventItem Model
// ══════════════════════════════════════════════════════════════════════════

struct HistoryEventItem: Identifiable, Hashable {
    let id: Int
    let title: String
    let maulana: String
    let location: String
    let date: String
    let attendees: Int
    let rating: Float

    init(id: Int, title: String, maulana: String, location: String,
         date: String, attendees: Int, rating: Float = 0) {
        self.id = id
        self.title = title
        self.maulana = maulana
        self.location = location
        self.date = date
        self.attendees = attendees
        self.rating = rating
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - EventHistoryViewModel
// ══════════════════════════════════════════════════════════════════════════

@MainActor
@Observable
final class EventHistoryViewModel {

    // MARK: - Data

    private(set) var events: [HistoryEventItem] = EventHistoryViewModel.seedEvents

    // MARK: - Derived Data

    var totalEvents: Int { events.count }

    var averageRating: Float {
        guard !events.isEmpty else { return 0 }
        return events.map(\.rating).reduce(0, +) / Float(events.count)
    }

    // MARK: - Seed Data (replace with API call later)

    private static let seedEvents: [HistoryEventItem] = [
        HistoryEventItem(id: 1, title: "Quran Recitation Night", maulana: "Qari Muhammad Yusuf",
                         location: "Rajshahi City Mosque", date: "Mar 22, 2026", attendees: 95, rating: 4.8),
        HistoryEventItem(id: 2, title: "Islamic Finance Workshop", maulana: "Mufti Abdul Rahman",
                         location: "BICC, Dhaka", date: "Mar 10, 2026", attendees: 75, rating: 4.5),
        HistoryEventItem(id: 3, title: "Milad-un-Nabi Program", maulana: "Maulana Shah Ahmed",
                         location: "Khulna Boro Masjid", date: "Mar 5, 2026", attendees: 400, rating: 4.9),
        HistoryEventItem(id: 4, title: "Dua & Zikr Evening", maulana: "Maulana Noor Islam",
                         location: "Comilla Central Mosque", date: "Feb 28, 2026", attendees: 60, rating: 4.3),
        HistoryEventItem(id: 5, title: "Friday Waz Mahfil", maulana: "Maulana Abdul Karim",
                         location: "Dhaka Central Mosque", date: "Feb 14, 2026", attendees: 230, rating: 4.7),
        HistoryEventItem(id: 6, title: "Youth Islamic Seminar", maulana: "Maulana Ibrahim Khalil",
                         location: "Sylhet Central Eidgah", date: "Jan 20, 2026", attendees: 150, rating: 4.6),
    ]
}
