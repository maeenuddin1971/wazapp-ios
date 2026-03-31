import SwiftUI

// MARK: - Scroll Offset Key

private struct DetailScrollKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - NotificationDetailView — Collapsing Header

struct NotificationDetailView: View {
    let notification: NotificationItemModel
    var onBack: () -> Void = {}
    var onEventClick: ((Int) -> Void)? = nil
    var onMaulanaClick: ((Int) -> Void)? = nil
    
    @State private var scrollOffset: CGFloat = 0
    
    private let expandedHeight: CGFloat = 300
    private let collapsedHeight: CGFloat = 100
    
    private var headerColors: [Color] {
        switch notification.type {
        case .event:     return [colorPrimaryTeal, colorPrimaryTealDark]
        case .maulana:   return [colorInfoBlue, Color(red: 0.08, green: 0.40, blue: 0.75)]
        case .system:    return [colorAccentOrange, Color(red: 0.90, green: 0.32, blue: 0)]
        case .reminder:  return [colorSecondaryGreen, Color(red: 0.15, green: 0.50, blue: 0.25)]
        case .community: return [colorErrorRed, Color(red: 0.78, green: 0.16, blue: 0.16)]
        }
    }
    
    /// 0 = expanded, 1 = collapsed
    private var collapseProgress: CGFloat {
        let maxScroll = expandedHeight - collapsedHeight
        guard maxScroll > 0 else { return 0 }
        return min(max(-scrollOffset / maxScroll, 0), 1)
    }
    
    private var currentHeaderHeight: CGFloat {
        return max(expandedHeight + min(scrollOffset, 0), collapsedHeight)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackgroundCream.ignoresSafeArea()
            
            // ── Scrollable Content ────────────────────────────────────
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header spacer — drives collapse offset
                    Color.clear
                        .frame(height: expandedHeight + 8)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: DetailScrollKey.self,
                                    value: geo.frame(in: .named("detailScroll")).origin.y
                                )
                            }
                        )
                    
                    VStack(spacing: 16) {
                        // Message Card
                        detailCard(title: "Message") {
                            Text(notification.message)
                                .font(.system(size: 14))
                                .foregroundColor(Color.appTextSecondary)
                                .lineSpacing(6)
                        }
                        
                        // Details Card
                        detailCard(title: "Details") {
                            VStack(spacing: 12) {
                                DetailInfoRow(
                                    icon: "info.circle",
                                    label: "Type",
                                    value: notification.type.displayName,
                                    color: notificationColor(for: notification.type)
                                )
                                DetailInfoRow(
                                    icon: "clock",
                                    label: "Time",
                                    value: notification.time,
                                    color: Color.appTextSecondary
                                )
                                DetailInfoRow(
                                    icon: notification.isRead ? "checkmark.circle.fill" : "circle",
                                    label: "Status",
                                    value: notification.isRead ? "Read" : "Unread",
                                    color: notification.isRead ? colorSecondaryGreen : colorAccentOrange
                                )
                            }
                        }
                        
                        // Action Button
                        if let relatedId = notification.relatedId {
                            actionButton(relatedId: relatedId)
                        }
                        
                        Spacer().frame(height: 20)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .coordinateSpace(name: "detailScroll")
            .onPreferenceChange(DetailScrollKey.self) { value in
                scrollOffset = value
            }
            
            // ── Collapsing Header ─────────────────────────────────────
            collapsingHeader
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // MARK: - Collapsing Header
    
    private var collapsingHeader: some View {
        ZStack(alignment: .topLeading) {
            // Gradient
            LinearGradient(
                colors: headerColors,
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
            
            // ── Delete button (fades out) ─────────────────────────────
            HStack {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "trash")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.15 * (1 - collapseProgress)))
                        .clipShape(Circle())
                }
                .opacity(1 - collapseProgress)
            }
            .padding(.trailing, 12)
            .padding(.top, 54)
            
            // ── Animated Title ────────────────────────────────────────
            Text(notification.title)
                .font(.system(size: lerp(22, 18, collapseProgress), weight: .bold))
                .foregroundColor(.white)
                .lineLimit(collapseProgress > 0.5 ? 1 : 2)
                .padding(.leading, lerp(16, 56, collapseProgress))
                .padding(.trailing, 16)
                .padding(.top, lerp(160, 58, collapseProgress))
            
            // ── Expanded-only: type icon ──────────────────────────────
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 56, height: 56)
                Image(systemName: notificationIcon(for: notification.type))
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            .padding(.top, 108)
            .padding(.leading, 16)
            .opacity(max(1 - collapseProgress * 2.5, 0))
            
            // ── Expanded-only: time + type badge at bottom ────────────
            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.7))
                Text(notification.time)
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.7))
                
                Text(notification.type.displayName)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.leading, 16)
            .padding(.bottom, 16)
            .opacity(max(1 - collapseProgress * 2.5, 0))
        }
        .frame(height: currentHeaderHeight)
        .clipped()
    }
    
    // MARK: - Detail Card
    
    private func detailCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.appTextPrimary)
            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appCardSurface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
    }
    
    // MARK: - Action Button
    
    @ViewBuilder
    private func actionButton(relatedId: Int) -> some View {
        let actionText: String? = {
            switch notification.type {
            case .event, .reminder: return "View Event"
            case .maulana: return "View Maulana Profile"
            default: return nil
            }
        }()
        
        let actionIcon: String = {
            switch notification.type {
            case .event, .reminder: return "calendar"
            case .maulana: return "person.fill"
            default: return "info.circle"
            }
        }()
        
        if let text = actionText {
            Button(action: {
                switch notification.type {
                case .event, .reminder:
                    onEventClick?(relatedId)
                case .maulana:
                    onMaulanaClick?(relatedId)
                default: break
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: actionIcon)
                        .font(.system(size: 16))
                    Text(text)
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(notificationColor(for: notification.type))
                .cornerRadius(14)
            }
        }
    }
    
    // MARK: - Lerp
    
    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }
}

// MARK: - Detail Info Row

private struct DetailInfoRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(Color.appTextSecondary)
                Text(value)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.appTextPrimary)
            }
            Spacer()
        }
    }
}

#Preview {
    NotificationDetailView(
        notification: sampleNotifications[0]
    )
}
