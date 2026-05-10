import Foundation

// NOTE: Using Int IDs with seed data. Migrate to UUID or String if
// connecting to a backend API that uses non-integer identifiers.
struct EventItemModel: Identifiable, Hashable, Codable {
    let id: Int
    let title: String
    let maulana: String
    let location: String
    let date: String
    let time: String
    let isLive: Bool
    let isFeatured: Bool
    let attendees: Int
    let category: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case maulana
        case location
        case date
        case time
        case isLive = "is_live"
        case isFeatured = "is_featured"
        case attendees
        case category
    }

    init(id: Int, title: String, maulana: String, location: String,
         date: String, time: String, isLive: Bool = false,
         isFeatured: Bool = false, attendees: Int = 0, category: String = "All") {
        self.id = id
        self.title = title
        self.maulana = maulana
        self.location = location
        self.date = date
        self.time = time
        self.isLive = isLive
        self.isFeatured = isFeatured
        self.attendees = attendees
        self.category = category
    }
}
