import SwiftUI

// ──────────────────────────────────────────────────────────────────────────
// MARK: - Sample Maulana Data
// ──────────────────────────────────────────────────────────────────────────

// NOTE: Using Int IDs with seed data. Migrate to UUID or String when
// connecting to a backend API to avoid collision risks.
struct MaulanaItemModel: Identifiable, Hashable {
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

// ══════════════════════════════════════════════════════════════════════════
// MARK: - MaulanaView
// ══════════════════════════════════════════════════════════════════════════

struct MaulanaView: View {
    @Environment(MaulanaViewModel.self) private var viewModel
    var onMaulanaClick: ((MaulanaItemModel) -> Void)? = nil

    var body: some View {
        @Bindable var vm = viewModel
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                // ── Header ─────────────────────────────────────
                MaulanaHeader(searchQuery: $vm.searchQuery)

                // ── Stats Row ──────────────────────────────────
                MaulanaStatsRow()

                // ── Filter Chips ───────────────────────────────
                MaulanaFilterChips(
                    filters: vm.filters,
                    selectedFilter: $vm.selectedFilter
                )

                // ── Results Count ──────────────────────────────
                HStack {
                    Text("\(vm.filteredMaulanas.count) scholars found")
                        .font(.caption)
                        .foregroundStyle(colorTextSecondary)
                    Spacer()
                    Text("\(vm.verifiedCount) Verified")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(colorVerifiedBadge)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

                // ── Maulana Cards ──────────────────────────────
                if vm.filteredMaulanas.isEmpty {
                    MaulanaEmptyPlaceholder()
                } else {
                    ForEach(vm.filteredMaulanas) { maulana in
                        MaulanaProfileCard(maulana: maulana, onTap: { onMaulanaClick?(maulana) })
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .background(colorBackgroundCream)
        .ignoresSafeArea(.container, edges: .top)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Header
// ══════════════════════════════════════════════════════════════════════════

private struct MaulanaHeader: View {
    @Binding var searchQuery: String

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [colorPrimaryTeal, colorPrimaryTealDark],
                startPoint: .top,
                endPoint: .bottom
            )

            // Decorative circles
            Canvas { ctx, size in
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.9 - 110,
                        y: size.height * 0.25 - 110,
                        width: 220, height: 220
                    )),
                    with: .color(Color.white.opacity(0.06))
                )
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.1 - 80,
                        y: size.height * 0.75 - 80,
                        width: 160, height: 160
                    )),
                    with: .color(Color.white.opacity(0.04))
                )
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.5 - 50,
                        y: size.height * 0.1 - 50,
                        width: 100, height: 100
                    )),
                    with: .color(Color.white.opacity(0.03))
                )
            }

            VStack(spacing: 0) {
                    Spacer().frame(height: topSafeAreaInset + 4)

                    // Title row
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Maulana")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                            Text("Find renowned Islamic scholars")
                                .font(.caption)
                                .foregroundStyle(Color.white.opacity(0.7))
                        }

                        Spacer()

                        // Sort button
                        Button("Sort", systemImage: "list.bullet", action: {})
                            .labelStyle(.iconOnly)
                            .font(.callout)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(Circle().fill(Color.white.opacity(0.15)))
                            .accessibilityLabel("Sort scholars")
                    }
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 16)

                    // Search bar
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.callout)
                            .foregroundStyle(Color.white.opacity(0.7))

                        TextField("", text: $searchQuery, prompt: Text("Search scholars…")
                            .foregroundStyle(Color.white.opacity(0.5)))
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .tint(.white)

                        if !searchQuery.isEmpty {
                            Button("Clear", systemImage: "xmark.circle.fill", action: { searchQuery = "" })
                                .labelStyle(.iconOnly)
                                .font(.callout)
                                .foregroundStyle(Color.white.opacity(0.7))
                                .accessibilityLabel("Clear search")
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .background(Color.white.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 24))
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
// MARK: - Stats Row
// ══════════════════════════════════════════════════════════════════════════

private struct MaulanaStatsRow: View {
    @Environment(MaulanaViewModel.self) private var viewModel

    var body: some View {
        HStack(spacing: 16) {
            MaulanaStatCard(
                value: "\(viewModel.totalCount)",
                label: "Total",
                icon: "person.fill",
                color: colorPrimaryTeal
            )
            MaulanaStatCard(
                value: "\(viewModel.verifiedCount)",
                label: "Verified",
                icon: "checkmark.seal.fill",
                color: colorVerifiedBadge
            )
            MaulanaStatCard(
                value: "\(viewModel.totalUpcomingEvents)",
                label: "Upcoming",
                icon: "calendar",
                color: colorAccentOrange
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Filter Chips
// ══════════════════════════════════════════════════════════════════════════

private struct MaulanaFilterChips: View {
    let filters: [String]
    @Binding var selectedFilter: String

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    let isSelected = filter == selectedFilter

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    }) {
                        HStack(spacing: 6) {
                            if filter == "Verified" {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.caption)
                                    .foregroundStyle(isSelected ? .white : colorTextPrimary)
                            }
                            Text(filter)
                                .font(.subheadline)
                                .fontWeight(isSelected ? .bold : .regular)
                                .foregroundStyle(isSelected ? .white : colorTextPrimary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(isSelected ? colorPrimaryTeal : Color.white)
                        .clipShape(.rect(cornerRadius: 20))
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
        .scrollIndicators(.hidden)
        .padding(.bottom, 16)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Profile Card
// ══════════════════════════════════════════════════════════════════════════

private struct MaulanaProfileCard: View {
    let maulana: MaulanaItemModel
    var onTap: () -> Void = {}

    private var initial: String {
        let parts = maulana.name.split(separator: " ")
        return String(parts.last?.prefix(1) ?? "M")
    }

    var body: some View {
        Button(action: { onTap() }) {
        VStack(spacing: 0) {
            // Top gradient banner with badges
            ZStack(alignment: .topLeading) {
                ZStack {
                    LinearGradient(
                        colors: [colorPrimaryTeal, colorPrimaryTealDark],
                        startPoint: .leading,
                        endPoint: .trailing
                    )

                    // Decorative pattern
                    Canvas { ctx, size in
                        let w = size.width
                        let h = size.height
                        for i in 0..<5 {
                            let cx = w * (0.15 + CGFloat(i) * 0.2)
                            ctx.fill(
                                Path(ellipseIn: CGRect(
                                    x: cx - 20, y: h * 0.5 - 20,
                                    width: 40, height: 40
                                )),
                                with: .color(Color.white.opacity(0.04))
                            )
                        }
                    }
                }
                .frame(height: 56)

                // Right: Badges
                HStack {
                    Spacer()
                    HStack(spacing: 6) {
                        if maulana.isVerified {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                                Text("Verified")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.white.opacity(0.2))
                            .clipShape(.rect(cornerRadius: 8))
                        }

                        // Rating badge
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundStyle(.white)
                            Text(maulana.rating.formatted(.number.precision(.fractionLength(1))))
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(colorAccentOrange)
                        .clipShape(.rect(cornerRadius: 8))
                    }
                    .padding(.trailing, 16)
                }
                .frame(height: 56)
            }

            // Content: Avatar + Details
            HStack(alignment: .top, spacing: 16) {
                // Overlapping avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [colorPrimaryTealLight, colorPrimaryTeal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)

                    Text(initial)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }
                .offset(y: -24)

                // Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(maulana.name)
                        .font(.callout.bold())
                        .foregroundStyle(colorTextPrimary)
                        .lineLimit(1)

                    Text(maulana.title)
                        .font(.caption)
                        .foregroundStyle(colorPrimaryTeal)

                    Spacer().frame(height: 2)

                    // Specialization
                    HStack(spacing: 4) {
                        Image(systemName: "info.circle")
                            .font(.caption)
                            .foregroundStyle(colorAccentOrange)
                        Text(maulana.specialization)
                            .font(.caption)
                            .foregroundStyle(colorTextSecondary)
                            .lineLimit(1)
                    }

                    // Location
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.caption)
                            .foregroundStyle(colorSecondaryGreen)
                        Text(maulana.location)
                            .font(.caption)
                            .foregroundStyle(colorTextSecondary)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Stats row
            HStack(spacing: 0) {
                MaulanaInlineStat(
                    value: "\(maulana.totalEvents)",
                    label: "Events",
                    color: colorPrimaryTeal
                )
                Divider()
                    .frame(height: 36)
                MaulanaInlineStat(
                    value: "\(maulana.upcomingEvents)",
                    label: "Upcoming",
                    color: colorAccentOrange
                )
                Divider()
                    .frame(height: 36)
                MaulanaInlineStat(
                    value: formatFollowerCount(maulana.followers),
                    label: "Followers",
                    color: colorInfoBlue
                )
            }
            .padding(.horizontal, 16)

            // Action buttons
            HStack(spacing: 8) {
                // View Details button
                Button(action: { onTap() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "person")
                            .font(.footnote)
                        Text("View Details")
                            .font(.footnote.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(colorPrimaryTeal)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 10))
                }

                // Follow button
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: maulana.isFollowing ? "heart.fill" : "heart")
                            .font(.footnote)
                        Text(maulana.isFollowing ? "Following" : "Follow")
                            .font(.footnote.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorPrimaryTeal, lineWidth: 1.5)
                    )
                    .foregroundStyle(colorPrimaryTeal)
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            Spacer().frame(height: 8)
        }
        .background(Color.appCardSurface)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

private struct MaulanaInlineStat: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.callout.bold())
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(colorTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 8)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Empty State
// ══════════════════════════════════════════════════════════════════════════

private struct MaulanaEmptyPlaceholder: View {
    var body: some View {
        ContentUnavailableView(
            "No results found",
            systemImage: "person",
            description: Text("Try adjusting your search or filters")
        )
        .padding(.vertical, 40)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Previews
// ══════════════════════════════════════════════════════════════════════════

#Preview("Light") {
    MaulanaView()
        .environment(MaulanaViewModel())
}

#Preview("Dark") {
    MaulanaView()
        .environment(MaulanaViewModel())
        .preferredColorScheme(.dark)
}
