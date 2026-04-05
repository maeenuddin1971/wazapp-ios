import Foundation
import Observation

// ══════════════════════════════════════════════════════════════════════════
// MARK: - EventsViewModel
// ══════════════════════════════════════════════════════════════════════════

@MainActor
@Observable
final class EventsViewModel {

    // MARK: - Data

    private(set) var events: [EventItemModel] = EventsViewModel.seedEvents

    // MARK: - Filter / Search State

    var selectedFilter = "All"
    var searchQuery = ""

    let filters = ["All", "Today", "This Week", "This Month"]

    // MARK: - Derived Data

    var filteredEvents: [EventItemModel] {
        events.filter { event in
            let matchesFilter = selectedFilter == "All" || event.category == selectedFilter
            let matchesSearch = searchQuery.isEmpty ||
                event.title.localizedStandardContains(searchQuery) ||
                event.maulana.localizedStandardContains(searchQuery) ||
                event.location.localizedStandardContains(searchQuery)
            return matchesFilter && matchesSearch
        }
    }

    var liveCount: Int {
        filteredEvents.count(where: { $0.isLive })
    }

    var upcomingEvents: [EventItemModel] {
        Array(events.prefix(5))
    }

    // MARK: - Lookup

    func event(byId id: Int) -> EventItemModel? {
        events.first(where: { $0.id == id })
    }

    func events(forMaulana name: String) -> [EventItemModel] {
        events.filter { $0.maulana == name }
    }

    // MARK: - Seed Data (replace with API call later)

    private static let seedEvents: [EventItemModel] = [
        EventItemModel(id: 1, title: "Friday Waz Mahfil", maulana: "Maulana Abdul Karim", location: "Dhaka Central Mosque, Motijheel", date: "Mar 14, 2026", time: "After Jummah", isLive: true, isFeatured: true, attendees: 245, category: "Today"),
        EventItemModel(id: 2, title: "Tafseer Al-Quran", maulana: "Maulana Tariq Jameel", location: "Baitul Mukarram National Mosque", date: "Mar 15, 2026", time: "After Maghrib", isFeatured: true, attendees: 180, category: "This Week"),
        EventItemModel(id: 3, title: "Seerah Conference", maulana: "Maulana Hassan Ali", location: "Chittagong Grand Masjid", date: "Mar 18, 2026", time: "10:00 AM", attendees: 320, category: "This Week"),
        EventItemModel(id: 4, title: "Youth Islamic Seminar", maulana: "Maulana Ibrahim Khalil", location: "Sylhet Central Eidgah", date: "Mar 20, 2026", time: "3:00 PM", attendees: 150, category: "This Month"),
        EventItemModel(id: 5, title: "Quran Recitation Night", maulana: "Qari Muhammad Yusuf", location: "Rajshahi City Mosque", date: "Mar 22, 2026", time: "After Isha", attendees: 95, category: "This Month"),
        EventItemModel(id: 6, title: "Islamic Finance Workshop", maulana: "Mufti Abdul Rahman", location: "BICC, Dhaka", date: "Mar 25, 2026", time: "9:00 AM", attendees: 75, category: "This Month"),
        EventItemModel(id: 7, title: "Milad-un-Nabi Program", maulana: "Maulana Shah Ahmed", location: "Khulna Boro Masjid", date: "Mar 28, 2026", time: "After Asr", isFeatured: true, attendees: 400, category: "This Month"),
        EventItemModel(id: 8, title: "Dua & Zikr Evening", maulana: "Maulana Noor Islam", location: "Comilla Central Mosque", date: "Mar 14, 2026", time: "After Maghrib", attendees: 60, category: "Today")
    ]
}
