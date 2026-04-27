import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Navigation Route
// ══════════════════════════════════════════════════════════════════════════

enum HomeRoute: Hashable {
    case eventDetail(EventItemModel)
    case maulanaDetail(MaulanaItemModel)
    case notificationList
    case notificationDetail(NotificationItemModel)
    case editProfile
    case privacySecurity
    case savedEvents
    case following
    case myReminders
    case eventHistory
    case about
    case settings
    case helpFeedback
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - HomeView
// ══════════════════════════════════════════════════════════════════════════

enum HomeTab: Int, CaseIterable {
    case home, events, maulana, profile
}

struct HomeView: View {
    @State private var selectedTab: HomeTab = .home
    @State private var navigationPath = NavigationPath()
    @Environment(EventsViewModel.self) private var eventsViewModel
    @Environment(MaulanaViewModel.self) private var maulanaViewModel
    @Environment(NotificationsViewModel.self) private var notificationsViewModel

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                switch selectedTab {
                case .home:
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            HomeHeader(
                                unreadCount: notificationsViewModel.unreadCount,
                                onNotificationTap: {
                                    navigationPath.append(HomeRoute.notificationList)
                                },
                                onSearchTap: {
                                    selectedTab = .events
                                }
                            )
                            QuickActionsSection()
                            UpcomingEventsSection(
                                events: eventsViewModel.upcomingEvents,
                                onEventClick: { event in
                                    navigationPath.append(HomeRoute.eventDetail(event))
                                }
                            )
                            FeaturedMaulanaSection(
                                maulanas: maulanaViewModel.featuredMaulanas,
                                onMaulanaClick: { maulana in
                                    navigationPath.append(HomeRoute.maulanaDetail(maulana))
                                }
                            )
                            RecentActivitySection()
                            Spacer().frame(height: 16)
                        }
                    }
                    .scrollIndicators(.hidden)
                case .events:
                    EventsView(onEventClick: { event in
                        navigationPath.append(HomeRoute.eventDetail(event))
                    })
                case .maulana:
                    MaulanaView(onMaulanaClick: { maulana in
                        navigationPath.append(HomeRoute.maulanaDetail(maulana))
                    })
                case .profile:
                    ProfileView(
                        onNotificationsTap: {
                            navigationPath.append(HomeRoute.notificationList)
                        },
                        onEditProfileTap: {
                            navigationPath.append(HomeRoute.editProfile)
                        },
                        onPrivacySecurityTap: {
                            navigationPath.append(HomeRoute.privacySecurity)
                        },
                        onSavedEventsTap: {
                            navigationPath.append(HomeRoute.savedEvents)
                        },
                        onFollowingTap: {
                            navigationPath.append(HomeRoute.following)
                        },
                        onMyRemindersTap: {
                            navigationPath.append(HomeRoute.myReminders)
                        },
                        onEventHistoryTap: {
                            navigationPath.append(HomeRoute.eventHistory)
                        },
                        onAboutTap: {
                            navigationPath.append(HomeRoute.about)
                        },
                        onSettingsTap: {
                            navigationPath.append(HomeRoute.settings)
                        },
                        onHelpFeedbackTap: {
                            navigationPath.append(HomeRoute.helpFeedback)
                        }
                    )
                }
                HomeBottomNavBar(selectedTab: $selectedTab)
            }
            .background(colorBackgroundCream)
            .ignoresSafeArea(.container, edges: .top)
            .navigationBarHidden(true)
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .eventDetail(let event):
                    EventDetailView(event: event)
                        .navigationBarHidden(true)
                case .maulanaDetail(let maulana):
                    MaulanaDetailView(maulana: maulana, onEventClick: { event in
                        navigationPath.append(HomeRoute.eventDetail(event))
                    })
                    .navigationBarHidden(true)
                case .notificationList:
                    NotificationListView(onNotificationClick: { notification in
                        navigationPath.append(HomeRoute.notificationDetail(notification))
                    })
                    .navigationBarHidden(true)
                case .notificationDetail(let notification):
                    NotificationDetailView(
                        notification: notification,
                        onEventClick: { eventId in
                            if let event = eventsViewModel.event(byId: eventId) {
                                navigationPath.append(HomeRoute.eventDetail(event))
                            }
                        }
                    )
                    .navigationBarHidden(true)
                case .editProfile:
                    EditProfileView()
                        .navigationBarHidden(true)
                case .privacySecurity:
                    PrivacySecurityView()
                        .navigationBarHidden(true)
                case .savedEvents:
                    SavedEventsView()
                        .navigationBarHidden(true)
                case .following:
                    FollowingView()
                        .navigationBarHidden(true)
                case .myReminders:
                    MyRemindersView()
                        .navigationBarHidden(true)
                case .eventHistory:
                    EventHistoryView()
                        .navigationBarHidden(true)
                case .about:
                    AboutView()
                        .navigationBarHidden(true)
                case .settings:
                    SettingsView(
                        onEditProfileTap: {
                            navigationPath.append(HomeRoute.editProfile)
                        },
                        onNotificationsTap: {
                            navigationPath.append(HomeRoute.notificationList)
                        },
                        onPrivacySecurityTap: {
                            navigationPath.append(HomeRoute.privacySecurity)
                        },
                        onAboutTap: {
                            navigationPath.append(HomeRoute.about)
                        }
                    )
                    .navigationBarHidden(true)
                case .helpFeedback:
                    HelpFeedbackView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}


// ══════════════════════════════════════════════════════════════════════════
// MARK: - Header
// ══════════════════════════════════════════════════════════════════════════

private struct HomeHeader: View {
    var unreadCount: Int = 0
    var onNotificationTap: () -> Void = {}
    var onSearchTap: () -> Void = {}

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
                // Top row: Greeting + Notification
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Assalamu Alaikum")
                            .font(.subheadline)
                            .foregroundStyle(Color.white.opacity(0.8))
                        Text("Welcome Back 👋")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    // Notification bell with dynamic badge
                    Button(action: onNotificationTap) {
                        ZStack(alignment: .topTrailing) {
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "bell")
                                        .font(.body)
                                        .foregroundStyle(.white)
                                )

                            if unreadCount > 0 {
                                Text("\(unreadCount)")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                    .frame(width: 18, height: 18)
                                    .background(colorAccentOrange)
                                    .clipShape(Circle())
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                    .accessibilityLabel("Notifications\(unreadCount > 0 ? ", \(unreadCount) unread" : "")")
                }
                .padding(.horizontal, 16)
                .padding(.top, topSafeAreaInset + 8)

                Spacer().frame(height: 16)

                // Search bar — tappable, navigates to Events tab
                Button(action: onSearchTap) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.callout)
                            .foregroundStyle(Color.white.opacity(0.7))
                        Text("Search for events…")
                            .font(.subheadline)
                            .foregroundStyle(Color.white.opacity(0.6))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .background(Color.white.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 24))
                }
                .accessibilityLabel("Search for events")
                .accessibilityHint("Switches to Events tab to search")
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

private struct QuickActionModel: Identifiable {
    let id = UUID()
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
                .font(.callout.bold())
                .foregroundStyle(colorTextPrimary)

            HStack(spacing: 0) {
                ForEach(actions) { action in
                    Spacer()
                    QuickActionItem(action: action)
                        .accessibilityLabel(action.label)
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
                    .font(.title2)
                    .foregroundStyle(.white)
            }

            Text(action.label)
                .font(.caption)
                .foregroundStyle(colorTextPrimary)
        }
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Upcoming Events
// ══════════════════════════════════════════════════════════════════════════

private struct UpcomingEventsSection: View {
    let events: [EventItemModel]
    var onEventClick: ((EventItemModel) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Upcoming")
                    .font(.callout.bold())
                    .foregroundStyle(colorTextPrimary)
                Spacer()
                Button("View All") {}
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(colorPrimaryTeal)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(events) { event in
                        EventCard(
                            title: event.title,
                            maulana: event.maulana,
                            location: event.location,
                            date: event.date,
                            time: event.time,
                            isLive: event.isLive,
                            onClick: { onEventClick?(event) }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
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
    var onClick: () -> Void = {}

    var body: some View {
        Button(action: onClick) {
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
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .tracking(1)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(colorErrorRed)
                    .clipShape(.rect(cornerRadius: 12))
                    .shadow(radius: 2)
                    .padding(8)
                }

                // Date chip (bottom-left, slightly overlapping)
                VStack {
                    Spacer()
                    HStack {
                        Text(date)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(colorAccentOrange)
                            .clipShape(.rect(cornerRadius: 8))
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
                    .font(.callout.bold())
                    .foregroundStyle(colorTextPrimary)
                    .lineLimit(1)

                // Maulana row
                HStack(spacing: 4) {
                    Image(systemName: "person")
                        .font(.caption)
                        .foregroundStyle(colorPrimaryTeal)
                    Text(maulana)
                        .font(.caption)
                        .foregroundStyle(colorTextSecondary)
                        .lineLimit(1)
                }

                // Location row
                HStack(spacing: 4) {
                    Image(systemName: "mappin")
                        .font(.caption)
                        .foregroundStyle(colorAccentOrange)
                    Text(location)
                        .font(.caption)
                        .foregroundStyle(colorTextSecondary)
                        .lineLimit(1)
                }

                // Time row
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundStyle(colorSecondaryGreen)
                    Text(time)
                        .font(.caption)
                        .foregroundStyle(colorTextSecondary)
                }
            }
            .padding(16)
            .padding(.top, 8)
        }
                .frame(width: 280)
                .background(Color.appCardSurface)
                .clipShape(.rect(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Featured Maulana
// ══════════════════════════════════════════════════════════════════════════

private struct FeaturedMaulanaSection: View {
    let maulanas: [MaulanaItemModel]
    var onMaulanaClick: ((MaulanaItemModel) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Featured Maulana")
                    .font(.callout.bold())
                    .foregroundStyle(colorTextPrimary)
                Spacer()
                Button("View All") {}
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(colorPrimaryTeal)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(maulanas) { maulana in
                        MaulanaChip(
                            name: maulana.name,
                            eventCount: "\(maulana.totalEvents) Events",
                            isVerified: maulana.isVerified,
                            onClick: { onMaulanaClick?(maulana) }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.vertical, 16)
    }
}

private struct MaulanaChip: View {
    let name: String
    let eventCount: String
    let isVerified: Bool
    var onClick: () -> Void = {}

    private var displayName: String {
        let parts = name.split(separator: " ")
        return parts.suffix(2).joined(separator: " ")
    }

    var body: some View {
        Button(action: onClick) {
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
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }

                HStack(spacing: 4) {
                    Text(displayName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(colorTextPrimary)
                        .lineLimit(1)
                    if isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(colorVerifiedBadge)
                    }
                }

                Text(eventCount)
                    .font(.caption)
                    .foregroundStyle(colorTextSecondary)
            }
            .frame(width: 160)
            .padding(16)
            .background(Color.appCardSurface)
            .clipShape(.rect(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Recent Activity
// ══════════════════════════════════════════════════════════════════════════

private struct RecentActivitySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.callout.bold())
                .foregroundStyle(colorTextPrimary)

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
                    .font(.body)
                    .foregroundStyle(iconColor)
            }

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(colorTextPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(colorTextSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(time)
                .font(.caption)
                .foregroundStyle(colorTextSecondary)
        }
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Bottom Navigation Bar
// NOTE: Intentionally uses a custom nav bar instead of SwiftUI TabView/Tab
// to support the app's custom Islamic-themed visual design (gradient
// highlights, capsule indicators). If standard tab behaviour is needed
// later (e.g. badge API, haptics), consider migrating to the Tab API.
// ══════════════════════════════════════════════════════════════════════════

private struct HomeBottomNavBar: View {
    @Binding var selectedTab: HomeTab

    private let items: [(tab: HomeTab, label: String, selectedIcon: String, unselectedIcon: String)] = [
        (.home, "Home", "house.fill", "house"),
        (.events, "Events", "calendar", "calendar"),
        (.maulana, "Maulana", "person.fill", "person"),
        (.profile, "Profile", "person.circle.fill", "person.circle")
    ]

    var body: some View {
        HStack {
            ForEach(items, id: \.tab) { item in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = item.tab
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedTab == item.tab {
                                Capsule()
                                    .fill(colorPrimaryTeal.opacity(0.12))
                                    .frame(width: 56, height: 28)
                            }
                            Image(systemName: selectedTab == item.tab ? item.selectedIcon : item.unselectedIcon)
                                .font(.title3)
                                .foregroundStyle(selectedTab == item.tab ? colorPrimaryTeal : colorTextSecondary)
                        }
                        .frame(height: 28)

                        Text(item.label)
                            .font(.caption)
                            .fontWeight(selectedTab == item.tab ? .bold : .regular)
                            .foregroundStyle(selectedTab == item.tab ? colorPrimaryTeal : colorTextSecondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .accessibilityLabel("\(item.label) tab\(selectedTab == item.tab ? ", selected" : "")")
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 6)
        .background(
            Color.appCardSurface
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: -2)
        )
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Previews
// ══════════════════════════════════════════════════════════════════════════

#Preview("Light") {
    HomeView()
        .environment(EventsViewModel())
        .environment(MaulanaViewModel())
        .environment(NotificationsViewModel())
}

#Preview("Dark") {
    HomeView()
        .environment(EventsViewModel())
        .environment(MaulanaViewModel())
        .environment(NotificationsViewModel())
        .preferredColorScheme(.dark)
}
