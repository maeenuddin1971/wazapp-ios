import SwiftUI

// MARK: - Data Models

enum NotificationType: String, CaseIterable {
    case event, maulana, system, reminder, community
    
    var displayName: String { rawValue.capitalized }
}

struct NotificationItemModel: Identifiable {
    let id: Int
    let title: String
    let message: String
    let time: String
    let type: NotificationType
    var isRead: Bool = false
    var relatedId: Int? = nil
}

let sampleNotifications: [NotificationItemModel] = [
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

// MARK: - Helper

func notificationIcon(for type: NotificationType) -> String {
    switch type {
    case .event:     return "calendar"
    case .maulana:   return "person.fill"
    case .system:    return "info.circle.fill"
    case .reminder:  return "bell.fill"
    case .community: return "heart.fill"
    }
}

func notificationColor(for type: NotificationType) -> Color {
    switch type {
    case .event:     return colorPrimaryTeal
    case .maulana:   return colorInfoBlue
    case .system:    return colorAccentOrange
    case .reminder:  return colorSecondaryGreen
    case .community: return colorErrorRed
    }
}

// MARK: - Scroll Offset Preference Key

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - NotificationListView

struct NotificationListView: View {
    var onBack: () -> Void = {}
    var onNotificationClick: ((NotificationItemModel) -> Void)? = nil
    
    @State private var selectedFilter = "All"
    @State private var scrollOffset: CGFloat = 0
    @State private var appearedItems: Set<Int> = []
    
    private let filters = ["All", "Events", "Reminders", "System"]
    private let expandedHeight: CGFloat = 310
    private let collapsedHeight: CGFloat = 100  // includes safe area
    
    private var filteredNotifications: [NotificationItemModel] {
        switch selectedFilter {
        case "Events":    return sampleNotifications.filter { $0.type == .event || $0.type == .maulana }
        case "Reminders": return sampleNotifications.filter { $0.type == .reminder }
        case "System":    return sampleNotifications.filter { $0.type == .system || $0.type == .community }
        default:          return sampleNotifications
        }
    }
    
    private var unreadCount: Int {
        sampleNotifications.filter { !$0.isRead }.count
    }
    
    /// 0 = expanded, 1 = collapsed
    private var collapseProgress: CGFloat {
        let maxScroll = expandedHeight - collapsedHeight
        return min(max(-scrollOffset / maxScroll, 0), 1)
    }
    
    private var currentHeaderHeight: CGFloat {
        let maxScroll = expandedHeight - collapsedHeight
        return max(expandedHeight + min(scrollOffset, 0), collapsedHeight)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // ── Background ────────────────────────────────────────────
            Color.appBackgroundCream
                .ignoresSafeArea()
            
            // ── Scrollable List ───────────────────────────────────────
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Invisible offset tracker at top
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: ScrollOffsetKey.self,
                            value: geo.frame(in: .named("notifScroll")).minY
                        )
                    }
                    .frame(height: 0)
                    
                    // Spacer for header
                    Color.clear.frame(height: expandedHeight + 8)
                    
                    // Notification rows
                    LazyVStack(spacing: 0) {
                        ForEach(Array(filteredNotifications.enumerated()), id: \.element.id) { index, notification in
                            NotificationRow(notification: notification)
                                .onTapGesture {
                                    onNotificationClick?(notification)
                                }
                                .opacity(appearedItems.contains(notification.id) ? 1 : 0)
                                .offset(y: appearedItems.contains(notification.id) ? 0 : 40)
                                .animation(
                                    .easeOut(duration: 0.35).delay(Double(min(index, 6)) * 0.06),
                                    value: appearedItems.contains(notification.id)
                                )
                                .onAppear {
                                    let _ = withAnimation {
                                        appearedItems.insert(notification.id)
                                    }
                                }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .coordinateSpace(name: "notifScroll")
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                scrollOffset = value
            }
            
            // ── Collapsing Header ─────────────────────────────────────
            collapsingHeader
        }
        .ignoresSafeArea(.container, edges: .top)
        .onChange(of: selectedFilter) { _ in
            appearedItems.removeAll()
        }
    }
    
    // MARK: - Collapsing Header
    
    private var collapsingHeader: some View {
        ZStack(alignment: .topLeading) {
            // Gradient background
            LinearGradient(
                colors: [colorPrimaryTeal, colorPrimaryTealDark],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Decorative circles
            Canvas { ctx, size in
                ctx.fill(Circle().path(in: CGRect(x: size.width * 0.75, y: size.height * 0.05, width: 280, height: 280)),
                         with: .color(Color.white.opacity(0.06 * (1 - collapseProgress))))
                ctx.fill(Circle().path(in: CGRect(x: -60, y: size.height * 0.6, width: 200, height: 200)),
                         with: .color(Color.white.opacity(0.04 * (1 - collapseProgress))))
                ctx.fill(Circle().path(in: CGRect(x: size.width * 0.4, y: -40, width: 120, height: 120)),
                         with: .color(Color.white.opacity(0.03 * (1 - collapseProgress))))
            }
            .allowsHitTesting(false)
            
            // ── Back button (always visible) ──────────────────────────
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.15 * (1 - collapseProgress)))
                    .clipShape(Circle())
            }
            .padding(.leading, 12)
            .padding(.top, 54)
            
            // ── Animated Title ────────────────────────────────────────
            let titleSize = lerp(24, 18, collapseProgress)
            let titleX = lerp(16, 56, collapseProgress)
            let titleY = lerp(160, 58, collapseProgress)
            
            Text("Notifications")
                .font(.system(size: titleSize, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, titleX)
                .padding(.top, titleY)
            
            // ── Badge (fades out) ─────────────────────────────────────
            if unreadCount > 0 {
                Text("\(unreadCount) new")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(colorAccentOrange)
                    .cornerRadius(12)
                    .padding(.leading, titleX + 150)
                    .padding(.top, titleY + 4)
                    .opacity(1 - collapseProgress)
            }
            
            // ── Expanded-only content ─────────────────────────────────
            VStack(alignment: .leading, spacing: 8) {
                // Subtitle + Mark all read
                HStack {
                    Text("Stay updated with events & community")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Mark all read")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                }
                
                // Filter chips
                HStack(spacing: 8) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: { selectedFilter = filter }) {
                            Text(filter)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(filter == selectedFilter ? colorPrimaryTealDark : .white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(filter == selectedFilter ? Color.white : Color.white.opacity(0.15))
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .opacity(max(1 - collapseProgress * 2.5, 0))
        }
        .frame(height: currentHeaderHeight)
        .clipped()
    }
    
    // MARK: - Lerp helper
    
    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }
}

// MARK: - Notification Row

private struct NotificationRow: View {
    let notification: NotificationItemModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Type icon
            ZStack {
                Circle()
                    .fill(notificationColor(for: notification.type).opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: notificationIcon(for: notification.type))
                    .font(.system(size: 18))
                    .foregroundColor(notificationColor(for: notification.type))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.appTextPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if !notification.isRead {
                        Circle()
                            .fill(notificationColor(for: notification.type))
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(notification.message)
                    .font(.system(size: 13))
                    .foregroundColor(Color.appTextSecondary)
                    .lineLimit(2)
                
                Text(notification.time)
                    .font(.system(size: 11))
                    .foregroundColor(Color.appTextSecondary.opacity(0.7))
                    .padding(.top, 2)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            notification.isRead
                ? Color.clear
                : notificationColor(for: notification.type).opacity(0.04)
        )
    }
}

#Preview {
    NotificationListView()
}
