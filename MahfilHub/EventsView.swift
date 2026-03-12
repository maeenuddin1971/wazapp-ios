import SwiftUI

// ──────────────────────────────────────────────────────────────────────────
// MARK: - Sample Event Data
// ──────────────────────────────────────────────────────────────────────────

struct EventItemModel: Identifiable {
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

private let sampleEvents = [
    EventItemModel(id: 1, title: "Friday Waz Mahfil", maulana: "Maulana Abdul Karim", location: "Dhaka Central Mosque, Motijheel", date: "Mar 14, 2026", time: "After Jummah", isLive: true, isFeatured: true, attendees: 245, category: "Today"),
    EventItemModel(id: 2, title: "Tafseer Al-Quran", maulana: "Maulana Tariq Jameel", location: "Baitul Mukarram National Mosque", date: "Mar 15, 2026", time: "After Maghrib", isFeatured: true, attendees: 180, category: "This Week"),
    EventItemModel(id: 3, title: "Seerah Conference", maulana: "Maulana Hassan Ali", location: "Chittagong Grand Masjid", date: "Mar 18, 2026", time: "10:00 AM", attendees: 320, category: "This Week"),
    EventItemModel(id: 4, title: "Youth Islamic Seminar", maulana: "Maulana Ibrahim Khalil", location: "Sylhet Central Eidgah", date: "Mar 20, 2026", time: "3:00 PM", attendees: 150, category: "This Month"),
    EventItemModel(id: 5, title: "Quran Recitation Night", maulana: "Qari Muhammad Yusuf", location: "Rajshahi City Mosque", date: "Mar 22, 2026", time: "After Isha", attendees: 95, category: "This Month"),
    EventItemModel(id: 6, title: "Islamic Finance Workshop", maulana: "Mufti Abdul Rahman", location: "BICC, Dhaka", date: "Mar 25, 2026", time: "9:00 AM", attendees: 75, category: "This Month"),
    EventItemModel(id: 7, title: "Milad-un-Nabi Program", maulana: "Maulana Shah Ahmed", location: "Khulna Boro Masjid", date: "Mar 28, 2026", time: "After Asr", isFeatured: true, attendees: 400, category: "This Month"),
    EventItemModel(id: 8, title: "Dua & Zikr Evening", maulana: "Maulana Noor Islam", location: "Comilla Central Mosque", date: "Mar 14, 2026", time: "After Maghrib", attendees: 60, category: "Today")
]

// ══════════════════════════════════════════════════════════════════════════
// MARK: - EventsView
// ══════════════════════════════════════════════════════════════════════════

struct EventsView: View {
    @State private var selectedFilter = "All"
    @State private var searchQuery = ""

    private let filters = ["All", "Today", "This Week", "This Month"]

    private var filteredEvents: [EventItemModel] {
        sampleEvents.filter { event in
            let matchesFilter = selectedFilter == "All" || event.category == selectedFilter
            let matchesSearch = searchQuery.isEmpty ||
                event.title.localizedCaseInsensitiveContains(searchQuery) ||
                event.maulana.localizedCaseInsensitiveContains(searchQuery) ||
                event.location.localizedCaseInsensitiveContains(searchQuery)
            return matchesFilter && matchesSearch
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                // ── Header ─────────────────────────────────────────
                EventsHeader(searchQuery: $searchQuery)

                // ── Filter Chips ───────────────────────────────────
                EventsFilterChips(
                    filters: filters,
                    selectedFilter: $selectedFilter
                )

                // ── Stats Bar ──────────────────────────────────────
                EventsStatsBar(
                    totalEvents: filteredEvents.count,
                    liveCount: filteredEvents.filter { $0.isLive }.count
                )

                // ── Event Cards ────────────────────────────────────
                if filteredEvents.isEmpty {
                    EmptyEventsPlaceholder()
                } else {
                    ForEach(filteredEvents) { event in
                        EventListCard(event: event)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                }
            }
        }
        .background(colorBackgroundCream)
        .ignoresSafeArea(.container, edges: .top)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Events Header
// ══════════════════════════════════════════════════════════════════════════

private struct EventsHeader: View {
    @Binding var searchQuery: String

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
                        x: size.width * 0.85 - 100,
                        y: size.height * 0.3 - 100,
                        width: 200, height: 200
                    )),
                    with: .color(Color.white.opacity(0.05))
                )
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.15 - 70,
                        y: size.height * 0.7 - 70,
                        width: 140, height: 140
                    )),
                    with: .color(Color.white.opacity(0.04))
                )
            }

            VStack(spacing: 0) {
                Spacer().frame(height: 52)

                // Title row
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Events")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Text("Discover Islamic events near you")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.7))
                    }

                    Spacer()

                    // Filter icon
                    Button(action: {}) {
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "line.3.horizontal.decrease")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.horizontal, 16)

                Spacer().frame(height: 16)

                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.7))

                    TextField("", text: $searchQuery, prompt: Text("Search for events…")
                        .foregroundColor(Color.white.opacity(0.5)))
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .tint(.white)

                    if !searchQuery.isEmpty {
                        Button(action: { searchQuery = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                .background(Color.white.opacity(0.15))
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal, 16)

                Spacer().frame(height: 12)
            }
        }
        .frame(height: 200)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Filter Chips
// ══════════════════════════════════════════════════════════════════════════

private struct EventsFilterChips: View {
    let filters: [String]
    @Binding var selectedFilter: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    let isSelected = filter == selectedFilter

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    }) {
                        Text(filter)
                            .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                            .foregroundColor(isSelected ? .white : colorTextPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Group {
                                    if isSelected {
                                        colorPrimaryTeal
                                    } else {
                                        Color.white
                                    }
                                }
                            )
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        isSelected ? Color.clear : Color.gray.opacity(0.3),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(
                                color: isSelected ? colorPrimaryTeal.opacity(0.3) : Color.clear,
                                radius: isSelected ? 2 : 0,
                                x: 0, y: 1
                            )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Stats Bar
// ══════════════════════════════════════════════════════════════════════════

private struct EventsStatsBar: View {
    let totalEvents: Int
    let liveCount: Int

    var body: some View {
        HStack {
            Text("\(totalEvents) events found")
                .font(.system(size: 12))
                .foregroundColor(colorTextSecondary)

            Spacer()

            if liveCount > 0 {
                HStack(spacing: 4) {
                    Circle()
                        .fill(colorErrorRed)
                        .frame(width: 8, height: 8)
                    Text("\(liveCount) Live Now")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(colorErrorRed)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Event List Card
// ══════════════════════════════════════════════════════════════════════════

private struct EventListCard: View {
    let event: EventItemModel

    private var dateParts: [String] {
        event.date.split(separator: " ").map(String.init)
    }

    private var dayNumber: String {
        guard dateParts.count >= 2 else { return "" }
        return dateParts[1].replacingOccurrences(of: ",", with: "")
    }

    private var monthAbbr: String {
        guard !dateParts.isEmpty else { return "" }
        return dateParts[0]
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top accent strip
            ZStack(alignment: .topLeading) {
                // Gradient
                ZStack {
                    LinearGradient(
                        colors: event.isLive
                            ? [colorErrorRed, colorErrorRed.opacity(0.8)]
                            : [colorPrimaryTeal, colorPrimaryTealDark],
                        startPoint: .leading,
                        endPoint: .trailing
                    )

                    // Islamic arch decorations (featured only)
                    if event.isFeatured {
                        Canvas { ctx, size in
                            let w = size.width
                            let h = size.height

                            let centerArch = Path(ellipseIn: CGRect(
                                x: w * 0.35, y: h * 0.1,
                                width: w * 0.3, height: h * 0.8
                            ))
                            ctx.fill(centerArch, with: .color(Color.white.opacity(0.08)))

                            let leftArch = Path(ellipseIn: CGRect(
                                x: w * 0.1, y: h * 0.3,
                                width: w * 0.15, height: h * 0.6
                            ))
                            ctx.fill(leftArch, with: .color(Color.white.opacity(0.06)))

                            let rightArch = Path(ellipseIn: CGRect(
                                x: w * 0.75, y: h * 0.3,
                                width: w * 0.15, height: h * 0.6
                            ))
                            ctx.fill(rightArch, with: .color(Color.white.opacity(0.06)))
                        }
                    }
                }
                .frame(height: event.isFeatured ? 80 : 6)

                // Badges + attendee count (featured cards only)
                if event.isFeatured {
                    // Left: LIVE + Featured badges
                    HStack(spacing: 6) {
                        if event.isLive {
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
                            .padding(.vertical, 3)
                            .background(Color.white.opacity(0.25))
                            .cornerRadius(8)
                        }

                        HStack(spacing: 0) {
                            Text("Featured")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(colorAccentOrange)
                        .cornerRadius(8)
                    }
                    .padding(8)

                    // Right: Attendee count
                    HStack {
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 11))
                                .foregroundColor(Color.white.opacity(0.8))
                            Text("\(event.attendees)")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Color.white.opacity(0.9))
                        }
                        .padding(8)
                    }
                }
            }

            // Content row: Date pill + Details + Actions
            HStack(alignment: .top, spacing: 16) {
                // Date column
                VStack(spacing: 0) {
                    Text(dayNumber)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(colorPrimaryTeal)
                    Text(monthAbbr)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(colorPrimaryTeal)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(colorPrimaryTeal.opacity(0.1))
                .cornerRadius(12)
                .frame(width: 52)

                // Event details
                VStack(alignment: .leading, spacing: 6) {
                    Text(event.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(colorTextPrimary)
                        .lineLimit(1)

                    // Maulana
                    HStack(spacing: 4) {
                        Image(systemName: "person")
                            .font(.system(size: 11))
                            .foregroundColor(colorPrimaryTeal)
                        Text(event.maulana)
                            .font(.system(size: 12))
                            .foregroundColor(colorTextSecondary)
                            .lineLimit(1)
                    }

                    // Location
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 11))
                            .foregroundColor(colorAccentOrange)
                        Text(event.location)
                            .font(.system(size: 12))
                            .foregroundColor(colorTextSecondary)
                            .lineLimit(1)
                    }

                    // Time
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                            .foregroundColor(colorSecondaryGreen)
                        Text(event.time)
                            .font(.system(size: 12))
                            .foregroundColor(colorTextSecondary)
                    }
                }

                Spacer(minLength: 0)

                // Action buttons
                VStack(spacing: 4) {
                    Button(action: {}) {
                        Image(systemName: "heart")
                            .font(.system(size: 18))
                            .foregroundColor(colorTextSecondary)
                            .frame(width: 36, height: 36)
                    }
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16))
                            .foregroundColor(colorTextSecondary)
                            .frame(width: 36, height: 36)
                    }
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Empty State
// ══════════════════════════════════════════════════════════════════════════

private struct EmptyEventsPlaceholder: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 40)

            ZStack {
                Circle()
                    .fill(colorPrimaryTeal.opacity(0.1))
                    .frame(width: 80, height: 80)
                Image(systemName: "calendar")
                    .font(.system(size: 36))
                    .foregroundColor(colorPrimaryTeal)
            }

            Text("No events found")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(colorTextPrimary)

            Text("There are no events matching your criteria")
                .font(.system(size: 14))
                .foregroundColor(colorTextSecondary)

            Spacer().frame(height: 40)
        }
        .frame(maxWidth: .infinity)
    }
}
