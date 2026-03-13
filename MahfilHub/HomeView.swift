import SwiftUI

// MARK: - Additional Colors (matching Android Color.kt)
let colorPrimaryTealLight = Color(red: 0x4D/255.0, green: 0xB6/255.0, blue: 0xAC/255.0)
let colorSecondaryGreen   = Color(red: 0x66/255.0, green: 0xBB/255.0, blue: 0x6A/255.0)
let colorInfoBlue         = Color(red: 0x21/255.0, green: 0x96/255.0, blue: 0xF3/255.0)
let colorSuccessGreen     = Color(red: 0x4C/255.0, green: 0xAF/255.0, blue: 0x50/255.0)
let colorErrorRed         = Color(red: 0xF4/255.0, green: 0x43/255.0, blue: 0x36/255.0)
let colorVerifiedBadge    = Color(red: 0x19/255.0, green: 0x76/255.0, blue: 0xD2/255.0)
let colorBackgroundCream  = Color(red: 0xF5/255.0, green: 0xF5/255.0, blue: 0xF0/255.0)
let colorTextSecondary    = Color(red: 0x75/255.0, green: 0x75/255.0, blue: 0x75/255.0)
let colorTextPrimary      = Color(red: 0x21/255.0, green: 0x21/255.0, blue: 0x21/255.0)

// ══════════════════════════════════════════════════════════════════════════
// MARK: - HomeView
// ══════════════════════════════════════════════════════════════════════════

struct HomeView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            // Switch content based on selected tab
            switch selectedTab {
            case 0:
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        HomeHeader()
                        QuickActionsSection()
                        UpcomingEventsSection()
                        FeaturedMaulanaSection()
                        RecentActivitySection()
                        Spacer().frame(height: 16)
                    }
                }
            case 1:
                EventsView()
            case 2:
                MaulanaView()
            default:
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        HomeHeader()
                        QuickActionsSection()
                        UpcomingEventsSection()
                        FeaturedMaulanaSection()
                        RecentActivitySection()
                        Spacer().frame(height: 16)
                    }
                }
            }

            // Bottom Navigation Bar
            HomeBottomNavBar(selectedTab: $selectedTab)
        }
        .background(colorBackgroundCream)
        .ignoresSafeArea(.container, edges: .top)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Header
// ══════════════════════════════════════════════════════════════════════════

private struct HomeHeader: View {
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [colorPrimaryTeal, colorPrimaryTealDark],
                startPoint: .top,
                endPoint: .bottom
            )

            // Decorative circles
            Canvas { ctx, size in
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.9 - 120,
                        y: size.height * 0.2 - 120,
                        width: 240, height: 240
                    )),
                    with: .color(Color.white.opacity(0.05))
                )
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.1 - 80,
                        y: size.height * 0.8 - 80,
                        width: 160, height: 160
                    )),
                    with: .color(Color.white.opacity(0.04))
                )
            }

            VStack(spacing: 0) {
                // Safe area spacer
                Color.clear.frame(height: 0)
                    .safeAreaInset(edge: .top) { Color.clear.frame(height: 0) }

                // Top row: Greeting + Notification
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Assalamu Alaikum")
                            .font(.system(size: 14))
                            .foregroundColor(Color.white.opacity(0.8))
                        Text("Welcome Back 👋")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // Notification bell with badge
                    Button(action: {}) {
                        ZStack(alignment: .topTrailing) {
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "bell")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                )

                            // Badge
                            Text("3")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 18, height: 18)
                                .background(colorAccentOrange)
                                .clipShape(Circle())
                                .offset(x: 2, y: -2)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 52) // approximate safe area top

                Spacer().frame(height: 16)

                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.7))
                    Text("Search for events…")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.6))
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                .background(Color.white.opacity(0.15))
                .cornerRadius(24)
                .padding(.horizontal, 16)

                Spacer().frame(height: 12)
            }
        }
        .frame(height: 210)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Quick Actions
// ══════════════════════════════════════════════════════════════════════════

private struct QuickActionModel {
    let icon: String
    let label: String
    let color: Color
}

private struct QuickActionsSection: View {
    let actions: [QuickActionModel] = [
        QuickActionModel(icon: "calendar", label: "Events", color: colorPrimaryTeal),
        QuickActionModel(icon: "person.fill", label: "Maulana", color: colorAccentOrange),
        QuickActionModel(icon: "mappin.and.ellipse", label: "Nearby", color: colorSecondaryGreen),
        QuickActionModel(icon: "star.fill", label: "Saved", color: colorInfoBlue)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(colorTextPrimary)

            HStack(spacing: 0) {
                ForEach(0..<actions.count, id: \.self) { index in
                    Spacer()
                    QuickActionItem(action: actions[index])
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

private struct QuickActionItem: View {
    let action: QuickActionModel

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [action.color, action.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: action.color.opacity(0.3), radius: 4, x: 0, y: 2)

                Image(systemName: action.icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
            }

            Text(action.label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(colorTextPrimary)
        }
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Upcoming Events
// ══════════════════════════════════════════════════════════════════════════

private struct UpcomingEventsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Section header
            HStack {
                Text("Upcoming")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colorTextPrimary)
                Spacer()
                Button("View All") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(colorPrimaryTeal)
            }
            .padding(.horizontal, 16)

            // Horizontal scrolling event cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    EventCard(
                        title: "Friday Waz Mahfil",
                        maulana: "Maulana Abdul Karim",
                        location: "Dhaka Central Mosque",
                        date: "Mar 14, 2026",
                        time: "After Jummah",
                        isLive: false
                    )
                    EventCard(
                        title: "Tafseer Al-Quran",
                        maulana: "Maulana Tariq Jameel",
                        location: "Baitul Mukarram",
                        date: "Mar 15, 2026",
                        time: "After Maghrib",
                        isLive: true
                    )
                    EventCard(
                        title: "Seerah Conference",
                        maulana: "Maulana Hassan",
                        location: "Chittagong Grand Masjid",
                        date: "Mar 18, 2026",
                        time: "10:00 AM",
                        isLive: false
                    )
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 8)
    }
}

private struct EventCard: View {
    let title: String
    let maulana: String
    let location: String
    let date: String
    let time: String
    let isLive: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Top accent strip
            ZStack(alignment: .topTrailing) {
                // Gradient background with Islamic arch patterns
                ZStack {
                    LinearGradient(
                        colors: [colorPrimaryTeal, colorPrimaryTealDark],
                        startPoint: .leading,
                        endPoint: .trailing
                    )

                    // Islamic arch decorations
                    Canvas { ctx, size in
                        let w = size.width
                        let h = size.height

                        // Center arch
                        let centerArch = Path(ellipseIn: CGRect(
                            x: w * 0.3, y: h * 0.1,
                            width: w * 0.4, height: h * 0.8
                        ))
                        ctx.fill(centerArch, with: .color(Color.white.opacity(0.08)))

                        // Left arch
                        let leftArch = Path(ellipseIn: CGRect(
                            x: w * 0.1, y: h * 0.3,
                            width: w * 0.2, height: h * 0.6
                        ))
                        ctx.fill(leftArch, with: .color(Color.white.opacity(0.06)))

                        // Right arch
                        let rightArch = Path(ellipseIn: CGRect(
                            x: w * 0.7, y: h * 0.3,
                            width: w * 0.2, height: h * 0.6
                        ))
                        ctx.fill(rightArch, with: .color(Color.white.opacity(0.06)))
                    }
                }
                .frame(height: 100)

                // LIVE badge
                if isLive {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 6, height: 6)
                        Text("LIVE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .tracking(1)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(colorErrorRed)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(8)
                }

                // Date chip (bottom-left, slightly overlapping)
                VStack {
                    Spacer()
                    HStack {
                        Text(date)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(colorAccentOrange)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .padding(.leading, 8)
                            .offset(y: 12)
                        Spacer()
                    }
                }
                .frame(height: 100)
            }

            // Content section
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colorTextPrimary)
                    .lineLimit(1)

                // Maulana row
                HStack(spacing: 4) {
                    Image(systemName: "person")
                        .font(.system(size: 12))
                        .foregroundColor(colorPrimaryTeal)
                    Text(maulana)
                        .font(.system(size: 12))
                        .foregroundColor(colorTextSecondary)
                        .lineLimit(1)
                }

                // Location row
                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.system(size: 12))
                        .foregroundColor(colorAccentOrange)
                    Text(location)
                        .font(.system(size: 12))
                        .foregroundColor(colorTextSecondary)
                        .lineLimit(1)
                }

                // Time row
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(colorSecondaryGreen)
                    Text(time)
                        .font(.system(size: 12))
                        .foregroundColor(colorTextSecondary)
                }
            }
            .padding(16)
            .padding(.top, 8)
        }
        .frame(width: 280)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Featured Maulana
// ══════════════════════════════════════════════════════════════════════════

private struct FeaturedMaulanaSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Featured Maulana")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colorTextPrimary)
                Spacer()
                Button("View All") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(colorPrimaryTeal)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    MaulanaChip(name: "Maulana Abdul Karim", eventCount: "120 Events", isVerified: true)
                    MaulanaChip(name: "Maulana Tariq Jameel", eventCount: "85 Events", isVerified: true)
                    MaulanaChip(name: "Maulana Hassan Ali", eventCount: "64 Events", isVerified: false)
                    MaulanaChip(name: "Maulana Ibrahim", eventCount: "42 Events", isVerified: false)
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 16)
    }
}

private struct MaulanaChip: View {
    let name: String
    let eventCount: String
    let isVerified: Bool

    private var displayName: String {
        let parts = name.split(separator: " ")
        return parts.suffix(2).joined(separator: " ")
    }

    var body: some View {
        VStack(spacing: 8) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [colorPrimaryTealLight, colorPrimaryTeal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)

                Text(String(name.prefix(1)))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }

            // Name + verified badge
            HStack(spacing: 4) {
                Text(displayName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(colorTextPrimary)
                    .lineLimit(1)

                if isVerified {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 12))
                        .foregroundColor(colorVerifiedBadge)
                }
            }

            Text(eventCount)
                .font(.system(size: 12))
                .foregroundColor(colorTextSecondary)
        }
        .frame(width: 160)
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 1)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Recent Activity
// ══════════════════════════════════════════════════════════════════════════

private struct RecentActivitySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(colorTextPrimary)

            ActivityItem(
                icon: "checkmark",
                iconColor: colorSuccessGreen,
                title: "Reminder Set",
                subtitle: "Friday Waz Mahfil — Mar 14",
                time: "2 hours ago"
            )
            ActivityItem(
                icon: "star.fill",
                iconColor: colorInfoBlue,
                title: "Event Saved",
                subtitle: "Tafseer Al-Quran — Baitul Mukarram",
                time: "5 hours ago"
            )
            ActivityItem(
                icon: "square.and.arrow.up",
                iconColor: colorAccentOrange,
                title: "Event Shared",
                subtitle: "Seerah Conference — Chittagong",
                time: "Yesterday"
            )
        }
        .padding(.horizontal, 16)
    }
}

private struct ActivityItem: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let time: String

    var body: some View {
        HStack(spacing: 16) {
            // Icon container
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
            }

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(colorTextPrimary)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(colorTextSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(time)
                .font(.system(size: 11))
                .foregroundColor(colorTextSecondary)
        }
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Bottom Navigation Bar
// ══════════════════════════════════════════════════════════════════════════

private struct NavItem {
    let label: String
    let selectedIcon: String
    let unselectedIcon: String
}

private struct HomeBottomNavBar: View {
    @Binding var selectedTab: Int

    private let items = [
        NavItem(label: "Home", selectedIcon: "house.fill", unselectedIcon: "house"),
        NavItem(label: "Events", selectedIcon: "calendar", unselectedIcon: "calendar"),
        NavItem(label: "Maulana", selectedIcon: "person.fill", unselectedIcon: "person"),
        NavItem(label: "Profile", selectedIcon: "person.circle.fill", unselectedIcon: "person.circle")
    ]

    var body: some View {
        HStack {
            ForEach(0..<items.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedTab == index {
                                Capsule()
                                    .fill(colorPrimaryTeal.opacity(0.12))
                                    .frame(width: 56, height: 28)
                            }
                            Image(systemName: selectedTab == index ? items[index].selectedIcon : items[index].unselectedIcon)
                                .font(.system(size: 20))
                                .foregroundColor(selectedTab == index ? colorPrimaryTeal : colorTextSecondary)
                        }
                        .frame(height: 28)

                        Text(items[index].label)
                            .font(.system(size: 11, weight: selectedTab == index ? .bold : .regular))
                            .foregroundColor(selectedTab == index ? colorPrimaryTeal : colorTextSecondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 6)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: -2)
        )
    }
}
