import Foundation

// NOTE: Using Int IDs with seed data. Migrate to UUID or String if
// connecting to a backend API that uses non-integer identifiers.
struct MaulanaItemModel: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let title: String
    let specialization: String
    let location: String
    let totalEvents: Int
    let upcomingEvents: Int
    let followers: Int
    let rating: Float
    let isVerified: Bool
    let isFollowing: Bool
    let category: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case specialization
        case location
        case totalEvents = "total_events"
        case upcomingEvents = "upcoming_events"
        case followers
        case rating
        case isVerified = "is_verified"
        case isFollowing = "is_following"
        case category
    }

    init(id: Int, name: String, title: String, specialization: String,
         location: String, totalEvents: Int, upcomingEvents: Int,
         followers: Int, rating: Float, isVerified: Bool = false,
         isFollowing: Bool = false, category: String = "All") {
        self.id = id
        self.name = name
        self.title = title
        self.specialization = specialization
        self.location = location
        self.totalEvents = totalEvents
        self.upcomingEvents = upcomingEvents
        self.followers = followers
        self.rating = rating
        self.isVerified = isVerified
        self.isFollowing = isFollowing
        self.category = category
    }
}
