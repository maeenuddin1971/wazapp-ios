import Foundation
import SwiftUI

enum NotificationType: String, CaseIterable, Codable {
    case event, maulana, system, reminder, community
    
    var displayName: String { rawValue.capitalized }
}

extension NotificationType {
    var icon: String {
        switch self {
        case .event:     return "calendar"
        case .maulana:   return "person.fill"
        case .system:    return "info.circle.fill"
        case .reminder:  return "bell.fill"
        case .community: return "heart.fill"
        }
    }

    var color: Color {
        switch self {
        case .event:     return colorPrimaryTeal
        case .maulana:   return colorVerifiedBadge
        case .system:    return colorInfoBlue
        case .reminder:  return colorAccentOrange
        case .community: return colorErrorRed
        }
    }
}

// NOTE: Using Int IDs with seed data. Migrate to UUID or String if
// connecting to a backend API that uses non-integer identifiers.
struct NotificationItemModel: Identifiable, Hashable, Codable {
    let id: Int
    let title: String
    let message: String
    let time: String
    let type: NotificationType
    var isRead: Bool
    var relatedId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case message
        case time
        case type
        case isRead = "is_read"
        case relatedId = "related_id"
    }
    
    init(id: Int, title: String, message: String, time: String,
         type: NotificationType, isRead: Bool = false, relatedId: Int? = nil) {
        self.id = id
        self.title = title
        self.message = message
        self.time = time
        self.type = type
        self.isRead = isRead
        self.relatedId = relatedId
    }
}
