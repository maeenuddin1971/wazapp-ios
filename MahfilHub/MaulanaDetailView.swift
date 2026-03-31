import SwiftUI

// MARK: - MaulanaDetailView

struct MaulanaDetailView: View {
    let maulana: MaulanaItemModel
    var onBack: () -> Void = {}
    var onEventClick: ((EventItemModel) -> Void)? = nil

    @State private var isFollowing: Bool

    init(maulana: MaulanaItemModel, onBack: @escaping () -> Void = {}, onEventClick: ((EventItemModel) -> Void)? = nil) {
        self.maulana = maulana
        self.onBack = onBack
        self.onEventClick = onEventClick
        _isFollowing = State(initialValue: maulana.isFollowing)
    }

    private var initial: String {
        maulana.name.split(separator: " ").last.map(String.init)?.first.map(String.init) ?? "M"
    }

    private var maulanaEvents: [EventItemModel] {
        sampleEventsPublic.filter { $0.maulana == maulana.name }
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Scrollable Content ───────────────────────────────────
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Hero Header ──────────────────────────────────
                    ZStack(alignment: .top) {
                        LinearGradient(
                            colors: [colorPrimaryTeal, colorPrimaryTealDark],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 320)

                        // Decorative circles
                        Canvas { ctx, size in
                            ctx.fill(Circle().path(in: CGRect(x: size.width*0.7, y: size.height*0.05, width: 320, height: 320)), with: .color(Color.white.opacity(0.06)))
                            ctx.fill(Circle().path(in: CGRect(x: -40, y: size.height*0.5, width: 240, height: 240)), with: .color(Color.white.opacity(0.04)))
                            ctx.fill(Circle().path(in: CGRect(x: size.width*0.35, y: -60, width: 160, height: 160)), with: .color(Color.white.opacity(0.03)))
                        }
                        .frame(height: 320)
                        .allowsHitTesting(false)

                        VStack(spacing: 0) {
                            // ── Top Bar ──────────────────────────────
                            HStack {
                                Button(action: onBack) {
                                    Image(systemName: "arrow.left")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.white.opacity(0.15))
                                        .clipShape(Circle())
                                }
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.white.opacity(0.15))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 54)

                            Spacer().frame(height: 12)

                            // ── Avatar ───────────────────────────────
                            ZStack {
                                LinearGradient(
                                    colors: [colorPrimaryTealLight, colorPrimaryTeal],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                Text(initial)
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.white)
                            }
                            .frame(width: 96, height: 96)
                            .clipShape(Circle())

                            Spacer().frame(height: 12)

                            // ── Name + Verified ──────────────────────
                            HStack(spacing: 6) {
                                Text(maulana.name)
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                if maulana.isVerified {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.body)
                                }
                            }

                            Text(maulana.title)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))

                            Spacer().frame(height: 6)

                            // ── Rating badge ─────────────────────────
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(colorAccentOrange)
                                Text(String(format: "%.1f", maulana.rating))
                                    .font(.footnote.bold())
                                    .foregroundColor(colorAccentOrange)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(colorAccentOrange.opacity(0.25))
                            .cornerRadius(12)

                            Spacer().frame(height: 16)
                        }
                        .frame(height: 320)
                    }

                    // ── Stats Row ────────────────────────────────────
                    HStack(spacing: 12) {
                        MaulanaStatCard(value: "\(maulana.totalEvents)", label: "Total Events", color: colorPrimaryTeal)
                        MaulanaStatCard(value: "\(maulana.upcomingEvents)", label: "Upcoming", color: colorAccentOrange)
                        MaulanaStatCard(value: formatMaulanaFollowers(maulana.followers), label: "Followers", color: colorInfoBlue)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                    Spacer().frame(height: 20)

                    // ── About Card ───────────────────────────────────
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.headline)
                            .foregroundColor(colorTextPrimary)

                        MaulanaInfoRow(icon: "info.circle", label: "Specialization", value: maulana.specialization, color: colorAccentOrange)
                        MaulanaInfoRow(icon: "location.fill", label: "Location", value: maulana.location, color: colorSecondaryGreen)
                        MaulanaInfoRow(icon: "calendar", label: "Events Conducted", value: "\(maulana.totalEvents) events", color: colorPrimaryTeal)
                        MaulanaInfoRow(icon: "person.2.fill", label: "Followers", value: "\(formatMaulanaFollowers(maulana.followers)) followers", color: colorInfoBlue)

                        Spacer().frame(height: 4)

                        Text("\(maulana.name) is a renowned Islamic scholar specializing in \(maulana.specialization). Based in \(maulana.location), they have conducted \(maulana.totalEvents) events and have a community of \(formatMaulanaFollowers(maulana.followers)) devoted followers. Known for their eloquent delivery and deep knowledge, they continue to inspire and educate communities across the region.")
                            .font(.subheadline)
                            .foregroundColor(colorTextSecondary)
                            .lineSpacing(6)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color.appCardSurface)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 20)

                    // ── Events by Maulana ────────────────────────────
                    Text("Events by \(maulana.name.split(separator: " ").last.map(String.init) ?? maulana.name)")
                        .font(.headline)
                        .foregroundColor(colorTextPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                    Spacer().frame(height: 12)

                    if maulanaEvents.isEmpty {
                        // Empty state
                        VStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .font(.largeTitle)
                                .foregroundColor(colorPrimaryTeal.opacity(0.5))
                            Text("No upcoming events")
                                .font(.subheadline)
                                .foregroundColor(colorTextSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(32)
                        .background(Color.appCardSurface)
                        .cornerRadius(16)
                        .padding(.horizontal, 16)
                    } else {
                        ForEach(maulanaEvents) { event in
                            MaulanaEventMiniCard(event: event) {
                                onEventClick?(event)
                            }
                        }
                    }

                    Spacer().frame(height: 100)
                }
            }

            // ── Bottom Action Bar ────────────────────────────────────
            HStack(spacing: 12) {
                Button(action: { isFollowing.toggle() }) {
                    HStack(spacing: 6) {
                        Image(systemName: isFollowing ? "heart.fill" : "heart")
                            .font(.subheadline)
                            .foregroundColor(isFollowing ? colorErrorRed : colorTextPrimary)
                        Text(isFollowing ? "Following" : "Follow")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(isFollowing ? colorPrimaryTeal : colorTextPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isFollowing ? colorPrimaryTeal : colorTextSecondary.opacity(0.4), lineWidth: 1.5)
                    )
                }

                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "envelope.fill")
                            .font(.subheadline)
                        Text("Contact")
                            .font(.subheadline.bold())
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .background(colorPrimaryTeal)
                    .cornerRadius(14)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Color.appCardSurface
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: -2)
            )
        }
        .ignoresSafeArea(edges: .top)
        .background(colorBackgroundCream)
    }
}

// MARK: - Helper functions

private func formatMaulanaFollowers(_ count: Int) -> String {
    count >= 1000 ? String(format: "%.1fK", Double(count) / 1000.0) : "\(count)"
}

// MARK: - Sub-components

private struct MaulanaStatCard: View {
    let value: String; let label: String; let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(colorTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.appCardSurface)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

private struct MaulanaInfoRow: View {
    let icon: String; let label: String; let value: String; let color: Color
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(colorTextSecondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(colorTextPrimary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

private struct MaulanaEventMiniCard: View {
    let event: EventItemModel
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 14) {
                // Date Pill
                let parts = event.date.split(separator: " ")
                let month = parts.first.map(String.init) ?? ""
                let day = parts.dropFirst().first.map(String.init)?.replacingOccurrences(of: ",", with: "") ?? ""

                VStack(spacing: 0) {
                    Text(day)
                        .font(.headline)
                        .foregroundColor(colorPrimaryTeal)
                    Text(month)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(colorPrimaryTeal)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(colorPrimaryTeal.opacity(0.1))
                .cornerRadius(10)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(event.title)
                            .font(.subheadline.bold())
                            .foregroundColor(colorTextPrimary)
                            .lineLimit(1)
                        if event.isLive {
                            Text("LIVE")
                                .font(.caption2.bold())
                                .foregroundColor(colorErrorRed)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(colorErrorRed.opacity(0.15))
                                .cornerRadius(4)
                        }
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundColor(colorAccentOrange)
                        Text(event.location)
                            .font(.caption)
                            .foregroundColor(colorTextSecondary)
                            .lineLimit(1)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(colorSecondaryGreen)
                        Text(event.time)
                            .font(.caption)
                            .foregroundColor(colorTextSecondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(colorTextSecondary.opacity(0.4))
            }
            .padding(14)
            .background(Color.appCardSurface)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

// MARK: - Public sample data accessor (used by MaulanaDetailView)
let sampleEventsPublic: [EventItemModel] = [
    EventItemModel(id: 1, title: "Friday Waz Mahfil", maulana: "Maulana Abdul Karim", location: "Dhaka Central Mosque, Motijheel", date: "Mar 14, 2026", time: "After Jummah", isLive: true, isFeatured: true, attendees: 245, category: "Today"),
    EventItemModel(id: 2, title: "Tafseer Al-Quran", maulana: "Maulana Tariq Jameel", location: "Baitul Mukarram National Mosque", date: "Mar 15, 2026", time: "After Maghrib", isFeatured: true, attendees: 180, category: "This Week"),
    EventItemModel(id: 3, title: "Seerah Conference", maulana: "Maulana Hassan Ali", location: "Chittagong Grand Masjid", date: "Mar 18, 2026", time: "10:00 AM", attendees: 320, category: "This Week"),
    EventItemModel(id: 4, title: "Youth Islamic Seminar", maulana: "Maulana Ibrahim Khalil", location: "Sylhet Central Eidgah", date: "Mar 20, 2026", time: "3:00 PM", attendees: 150, category: "This Month"),
    EventItemModel(id: 5, title: "Quran Recitation Night", maulana: "Qari Muhammad Yusuf", location: "Rajshahi City Mosque", date: "Mar 22, 2026", time: "After Isha", attendees: 95, category: "This Month"),
    EventItemModel(id: 6, title: "Islamic Finance Workshop", maulana: "Mufti Abdul Rahman", location: "BICC, Dhaka", date: "Mar 25, 2026", time: "9:00 AM", attendees: 75, category: "This Month"),
    EventItemModel(id: 7, title: "Milad-un-Nabi Program", maulana: "Maulana Shah Ahmed", location: "Khulna Boro Masjid", date: "Mar 28, 2026", time: "After Asr", isFeatured: true, attendees: 400, category: "This Month"),
    EventItemModel(id: 8, title: "Dua & Zikr Evening", maulana: "Maulana Noor Islam", location: "Comilla Central Mosque", date: "Mar 14, 2026", time: "After Maghrib", attendees: 60, category: "Today")
]

let sampleMaulanasPublic: [MaulanaItemModel] = [
    MaulanaItemModel(id: 1, name: "Maulana Abdul Karim", title: "Senior Scholar", specialization: "Tafseer & Hadith", location: "Dhaka, Bangladesh", totalEvents: 120, upcomingEvents: 3, followers: 4520, rating: 4.9, isVerified: true, category: "Popular"),
    MaulanaItemModel(id: 2, name: "Maulana Tariq Jameel", title: "International Speaker", specialization: "Dawah & Islah", location: "Lahore, Pakistan", totalEvents: 85, upcomingEvents: 2, followers: 12800, rating: 4.8, isVerified: true, category: "Popular"),
    MaulanaItemModel(id: 3, name: "Maulana Hassan Ali", title: "Quran Teacher", specialization: "Tafseer Al-Quran", location: "Chittagong, Bangladesh", totalEvents: 64, upcomingEvents: 1, followers: 2150, rating: 4.7, category: "Popular"),
    MaulanaItemModel(id: 4, name: "Maulana Ibrahim Khalil", title: "Youth Mentor", specialization: "Youth & Contemporary Issues", location: "Sylhet, Bangladesh", totalEvents: 42, upcomingEvents: 2, followers: 1800, rating: 4.6, category: "New"),
    MaulanaItemModel(id: 5, name: "Qari Muhammad Yusuf", title: "Hafiz & Qari", specialization: "Quran Recitation & Tajweed", location: "Rajshahi, Bangladesh", totalEvents: 35, upcomingEvents: 1, followers: 980, rating: 4.9, isVerified: true, category: "New")
]

#Preview {
    MaulanaDetailView(maulana: MaulanaItemModel(
        id: 1, name: "Maulana Abdul Karim", title: "Senior Scholar",
        specialization: "Tafseer & Hadith", location: "Dhaka, Bangladesh",
        totalEvents: 120, upcomingEvents: 3, followers: 4520, rating: 4.9, isVerified: true
    ))
}
