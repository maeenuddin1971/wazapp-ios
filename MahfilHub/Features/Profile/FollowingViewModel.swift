import Foundation
import Observation

// ══════════════════════════════════════════════════════════════════════════
// MARK: - FollowedScholar Model
// ══════════════════════════════════════════════════════════════════════════

struct FollowedScholar: Identifiable, Hashable {
    let id: Int
    let name: String
    let title: String
    let location: String
    let followedSince: String
    let upcomingEvents: Int
    let totalEvents: Int
    let isVerified: Bool

    var initial: String { String(name.prefix(1)) }

    init(id: Int, name: String, title: String, location: String,
         followedSince: String, upcomingEvents: Int = 0,
         totalEvents: Int = 0, isVerified: Bool = false) {
        self.id = id
        self.name = name
        self.title = title
        self.location = location
        self.followedSince = followedSince
        self.upcomingEvents = upcomingEvents
        self.totalEvents = totalEvents
        self.isVerified = isVerified
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - FollowingViewModel
// ══════════════════════════════════════════════════════════════════════════

@MainActor
@Observable
final class FollowingViewModel {

    // MARK: - Data

    private(set) var scholars: [FollowedScholar] = FollowingViewModel.seedScholars

    // MARK: - Derived Data

    var totalFollowing: Int { scholars.count }

    var withUpcomingCount: Int { scholars.count(where: { $0.upcomingEvents > 0 }) }

    var totalUpcomingEvents: Int { scholars.reduce(0) { $0 + $1.upcomingEvents } }

    // MARK: - Seed Data (replace with API call later)

    private static let seedScholars: [FollowedScholar] = [
        FollowedScholar(
            id: 1, name: "Maulana Abdul Karim", title: "Senior Islamic Scholar",
            location: "Dhaka, Bangladesh", followedSince: "Following since Jan 2026",
            upcomingEvents: 3, totalEvents: 45, isVerified: true
        ),
        FollowedScholar(
            id: 2, name: "Maulana Tariq Jameel", title: "International Speaker",
            location: "Lahore, Pakistan", followedSince: "Following since Mar 2025",
            upcomingEvents: 1, totalEvents: 120, isVerified: true
        ),
        FollowedScholar(
            id: 3, name: "Maulana Hassan Ali", title: "Quran Scholar",
            location: "Chittagong, Bangladesh", followedSince: "Following since Jun 2025",
            upcomingEvents: 2, totalEvents: 30, isVerified: true
        ),
        FollowedScholar(
            id: 4, name: "Maulana Ibrahim Khalil", title: "Youth Motivational Speaker",
            location: "Sylhet, Bangladesh", followedSince: "Following since Sep 2025",
            upcomingEvents: 0, totalEvents: 18
        ),
        FollowedScholar(
            id: 5, name: "Qari Muhammad Yusuf", title: "Hafiz & Qari",
            location: "Rajshahi, Bangladesh", followedSince: "Following since Nov 2025",
            upcomingEvents: 1, totalEvents: 22, isVerified: true
        ),
        FollowedScholar(
            id: 6, name: "Mufti Abdul Rahman", title: "Islamic Finance Expert",
            location: "Dhaka, Bangladesh", followedSince: "Following since Dec 2025",
            upcomingEvents: 0, totalEvents: 15
        ),
        FollowedScholar(
            id: 7, name: "Maulana Shah Ahmed", title: "Hadith Scholar",
            location: "Khulna, Bangladesh", followedSince: "Following since Feb 2026",
            upcomingEvents: 2, totalEvents: 55, isVerified: true
        ),
        FollowedScholar(
            id: 8, name: "Maulana Noor Islam", title: "Tafseer Specialist",
            location: "Comilla, Bangladesh", followedSince: "Following since Mar 2026",
            upcomingEvents: 1, totalEvents: 28
        ),
    ]
}
