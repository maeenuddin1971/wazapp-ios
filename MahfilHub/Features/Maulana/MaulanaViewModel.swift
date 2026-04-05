import Foundation
import Observation

// ══════════════════════════════════════════════════════════════════════════
// MARK: - MaulanaViewModel
// ══════════════════════════════════════════════════════════════════════════

@MainActor
@Observable
final class MaulanaViewModel {

    // MARK: - Data

    private(set) var maulanas: [MaulanaItemModel] = MaulanaViewModel.seedMaulanas

    // MARK: - Filter / Search State

    var selectedFilter = "All"
    var searchQuery = ""

    let filters = ["All", "Popular", "New", "Verified"]

    // MARK: - Derived Data

    var filteredMaulanas: [MaulanaItemModel] {
        maulanas.filter { maulana in
            let matchesFilter: Bool
            switch selectedFilter {
            case "All":      matchesFilter = true
            case "Verified": matchesFilter = maulana.isVerified
            default:         matchesFilter = maulana.category == selectedFilter
            }
            let matchesSearch = searchQuery.isEmpty ||
                maulana.name.localizedStandardContains(searchQuery) ||
                maulana.specialization.localizedStandardContains(searchQuery) ||
                maulana.location.localizedStandardContains(searchQuery)
            return matchesFilter && matchesSearch
        }
    }

    var featuredMaulanas: [MaulanaItemModel] {
        Array(maulanas.prefix(5))
    }

    // MARK: - Stats

    var totalCount: Int { maulanas.count }

    var verifiedCount: Int {
        maulanas.count(where: { $0.isVerified })
    }

    var totalUpcomingEvents: Int {
        maulanas.map(\.upcomingEvents).reduce(0, +)
    }

    // MARK: - Actions

    func toggleFollow(for maulanaId: Int) {
        guard let index = maulanas.firstIndex(where: { $0.id == maulanaId }) else { return }
        maulanas[index] = MaulanaItemModel(
            id: maulanas[index].id,
            name: maulanas[index].name,
            title: maulanas[index].title,
            specialization: maulanas[index].specialization,
            location: maulanas[index].location,
            totalEvents: maulanas[index].totalEvents,
            upcomingEvents: maulanas[index].upcomingEvents,
            followers: maulanas[index].followers + (maulanas[index].isFollowing ? -1 : 1),
            rating: maulanas[index].rating,
            isVerified: maulanas[index].isVerified,
            isFollowing: !maulanas[index].isFollowing,
            category: maulanas[index].category
        )
    }

    // MARK: - Seed Data (replace with API call later)

    private static let seedMaulanas: [MaulanaItemModel] = [
        MaulanaItemModel(id: 1, name: "Maulana Abdul Karim", title: "Senior Scholar", specialization: "Tafseer & Hadith", location: "Dhaka, Bangladesh", totalEvents: 120, upcomingEvents: 3, followers: 4520, rating: 4.9, isVerified: true, category: "Popular"),
        MaulanaItemModel(id: 2, name: "Maulana Tariq Jameel", title: "International Speaker", specialization: "Dawah & Islah", location: "Lahore, Pakistan", totalEvents: 85, upcomingEvents: 2, followers: 12800, rating: 4.8, isVerified: true, category: "Popular"),
        MaulanaItemModel(id: 3, name: "Maulana Hassan Ali", title: "Quran Teacher", specialization: "Tafseer Al-Quran", location: "Chittagong, Bangladesh", totalEvents: 64, upcomingEvents: 1, followers: 2150, rating: 4.7, category: "Popular"),
        MaulanaItemModel(id: 4, name: "Maulana Ibrahim Khalil", title: "Youth Mentor", specialization: "Youth & Contemporary Issues", location: "Sylhet, Bangladesh", totalEvents: 42, upcomingEvents: 2, followers: 1800, rating: 4.6, category: "New"),
        MaulanaItemModel(id: 5, name: "Qari Muhammad Yusuf", title: "Hafiz & Qari", specialization: "Quran Recitation & Tajweed", location: "Rajshahi, Bangladesh", totalEvents: 35, upcomingEvents: 1, followers: 980, rating: 4.9, isVerified: true, category: "New"),
        MaulanaItemModel(id: 6, name: "Mufti Abdul Rahman", title: "Islamic Finance Expert", specialization: "Fiqh & Islamic Finance", location: "Dhaka, Bangladesh", totalEvents: 28, upcomingEvents: 0, followers: 1450, rating: 4.5, isVerified: true, category: "Popular"),
        MaulanaItemModel(id: 7, name: "Maulana Shah Ahmed", title: "Community Leader", specialization: "Seerah & History", location: "Khulna, Bangladesh", totalEvents: 55, upcomingEvents: 2, followers: 3200, rating: 4.7, category: "Popular"),
        MaulanaItemModel(id: 8, name: "Maulana Noor Islam", title: "Spiritual Guide", specialization: "Tasawwuf & Zikr", location: "Comilla, Bangladesh", totalEvents: 30, upcomingEvents: 1, followers: 890, rating: 4.4, category: "New"),
        MaulanaItemModel(id: 9, name: "Maulana Fazlur Rahman", title: "Hadith Scholar", specialization: "Sahih Bukhari & Muslim", location: "Barisal, Bangladesh", totalEvents: 48, upcomingEvents: 0, followers: 2600, rating: 4.8, isVerified: true, category: "Popular"),
        MaulanaItemModel(id: 10, name: "Maulana Yusuf Ali", title: "Education Specialist", specialization: "Islamic Education & Tarbiyah", location: "Rangpur, Bangladesh", totalEvents: 22, upcomingEvents: 1, followers: 720, rating: 4.3, category: "New")
    ]
}

// MARK: - Shared Formatter

func formatFollowerCount(_ count: Int) -> String {
    if count >= 1000 {
        return "\((Double(count) / 1000.0).formatted(.number.precision(.fractionLength(1))))K"
    }
    return "\(count)"
}
