import SwiftUI

// MARK: - Data Models

enum NotificationType: String, CaseIterable {
    case event, maulana, system, reminder, community
    
    var displayName: String { rawValue.capitalized }
}

// NOTE: Using Int IDs with seed data. Migrate to UUID or String when
// connecting to a backend API to avoid collision risks.
struct NotificationItemModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let message: String
    let time: String
    let type: NotificationType
    var isRead: Bool = false
    var relatedId: Int? = nil
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


// MARK: - NotificationListView

struct NotificationListView: View {
    var onNotificationClick: ((NotificationItemModel) -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @Environment(NotificationsViewModel.self) private var viewModel
    
    @State private var scrollOffset: CGFloat = 0
    @State private var initialScrollValue: CGFloat?
    @State private var appearedItems: Set<Int> = []
    
    private let expandedHeight: CGFloat = 310
    /// Collapsed = status-bar safe area + compact title row
    private var collapsedHeight: CGFloat { topSafeAreaInset + 50 }
    
    /// 0 = fully expanded, 1 = fully collapsed
    private var collapseProgress: CGFloat {
        let travel = expandedHeight - collapsedHeight
        guard travel > 0 else { return 0 }
        return min(max(scrollOffset / travel, 0), 1)
    }
    
    private var currentHeaderHeight: CGFloat {
        let height = expandedHeight - scrollOffset
        return max(height, collapsedHeight)
    }
    
    var body: some View {
        @Bindable var vm = viewModel
        ZStack(alignment: .top) {
            Color.appBackgroundCream.ignoresSafeArea()
            
            // ── Scrollable List (behind the header) ───────────────────
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    // Spacer matching expanded header height
                    Color.clear
                        .frame(height: expandedHeight)
                    
                    // Notification rows
                    VStack(spacing: 0) {
                        ForEach(Array(vm.filteredNotifications.enumerated()), id: \.element.id) { index, notification in
                            Button(action: { onNotificationClick?(notification) }) {
                                NotificationRow(notification: notification)
                            }
                            .buttonStyle(.plain)
                            .opacity(appearedItems.contains(notification.id) ? 1 : 0)
                            .offset(y: appearedItems.contains(notification.id) ? 0 : 40)
                            .animation(
                                .easeOut(duration: 0.35).delay(Double(min(index, 6)) * 0.06),
                                value: appearedItems.contains(notification.id)
                            )
                            .onAppear {
                                withAnimation {
                                    _ = appearedItems.insert(notification.id)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top
            } action: { _, newValue in
                if initialScrollValue == nil { initialScrollValue = newValue }
                scrollOffset = newValue - (initialScrollValue ?? newValue)
            }
            .scrollIndicators(.hidden)
            
            // ── Collapsing Header (on top, clips scroll content) ──────
            collapsingHeader
        }
        .ignoresSafeArea(.container, edges: .top)
        .onChange(of: vm.selectedFilter) {
            appearedItems.removeAll()
        }
    }
    
    // MARK: - Collapsing Header
    
    /// Top of the back-button row (status bar inset)
    private var topBarY: CGFloat { topSafeAreaInset + 4 }
    
    @ViewBuilder
    private var collapsingHeader: some View {
        ZStack(alignment: .topLeading) {
            // Gradient background
            LinearGradient(
                colors: [colorPrimaryTeal, colorPrimaryTealDark],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Decorative circles (fade out)
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
            Button("Back", systemImage: "arrow.left", action: { dismiss() })
                .labelStyle(.iconOnly)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.15 * (1 - collapseProgress)))
                .clipShape(Circle())
                .accessibilityLabel("Go back")
                .padding(.leading, 12)
                .padding(.top, topBarY)
            
            // ── Animated Title ────────────────────────────────────────
            // Expanded: large title below the back button row
            // Collapsed: headline next to the back button
            Text("Notifications")
                .font(collapseProgress > 0.5 ? .headline : .title2.bold())
                .foregroundStyle(.white)
                .padding(.leading, lerp(16, 56, collapseProgress))
                .padding(.top, lerp(160, topBarY + 8, collapseProgress))
            
            // ── Badge (fades out) ─────────────────────────────────
            if viewModel.unreadCount > 0 {
                Text("\(viewModel.unreadCount) new")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(colorAccentOrange)
                    .clipShape(.rect(cornerRadius: 12))
                    .padding(.leading, lerp(16 + 150, 56 + 130, collapseProgress))
                    .padding(.top, lerp(164, topBarY + 12, collapseProgress))
                    .opacity(1 - collapseProgress)
            }
            
            // ── Expanded-only content (subtitle, filters) ─────────────
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Stay updated with events & community")
                        .font(.subheadline)
                        .foregroundStyle(Color.white.opacity(0.7))
                    Spacer()
                    Button(action: { viewModel.markAllAsRead() }) {
                        Text("Mark all read")
                            .font(.footnote)
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                }
                
                // Filter chips
                HStack(spacing: 8) {
                    ForEach(viewModel.filters, id: \.self) { filter in
                        Button(action: { viewModel.selectedFilter = filter }) {
                            Text(filter)
                                .font(.footnote)
                                .foregroundStyle(filter == viewModel.selectedFilter ? colorPrimaryTealDark : .white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(filter == viewModel.selectedFilter ? Color.white : Color.white.opacity(0.15))
                                .clipShape(.rect(cornerRadius: 20))
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
    
    // MARK: - Lerp
    
    private func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double {
        a + (b - a) * t
    }
}

// MARK: - Notification Row

private struct NotificationRow: View {
    let notification: NotificationItemModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(notification.type.color.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: notification.type.icon)
                    .font(.body)
                    .foregroundStyle(notification.type.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(1)
                    Spacer()
                    if !notification.isRead {
                        Circle()
                            .fill(notification.type.color)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(notification.message)
                    .font(.footnote)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(2)
                
                Text(notification.time)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary.opacity(0.7))
                    .padding(.top, 2)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            notification.isRead
                ? Color.clear
                : notification.type.color.opacity(0.04)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(notification.title), \(notification.message), \(notification.time)\(notification.isRead ? "" : ", unread")")
    }
}

#Preview {
    NotificationListView()
        .environment(NotificationsViewModel())
}
