import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - FollowingView
// ══════════════════════════════════════════════════════════════════════════

struct FollowingView: View {
    @Environment(FollowingViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    var onScholarClick: ((FollowedScholar) -> Void)? = nil

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                // Header
                FollowingHeader(
                    totalFollowing: viewModel.totalFollowing,
                    totalUpcomingEvents: viewModel.totalUpcomingEvents,
                    onBack: { dismiss() }
                )

                // Stats bar
                FollowingStatsBar(
                    totalFollowing: viewModel.totalFollowing,
                    withUpcoming: viewModel.withUpcomingCount
                )

                // Scholar cards
                ForEach(Array(viewModel.scholars.enumerated()), id: \.element.id) { index, scholar in
                    FollowedScholarCard(
                        scholar: scholar,
                        onTap: { onScholarClick?(scholar) }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .bottom)),
                        removal: .opacity
                    ))
                    .animation(
                        .easeOut(duration: 0.3).delay(Double(index) * 0.05),
                        value: viewModel.totalFollowing
                    )
                }
            }
        }
        .scrollIndicators(.hidden)
        .background(colorBackgroundCream)
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarHidden(true)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Following Header
// ══════════════════════════════════════════════════════════════════════════

private struct FollowingHeader: View {
    let totalFollowing: Int
    let totalUpcomingEvents: Int
    var onBack: () -> Void = {}

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
                        x: size.width * 0.85 - 120,
                        y: size.height * 0.2 - 120,
                        width: 240, height: 240
                    )),
                    with: .color(Color.white.opacity(0.06))
                )
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.1 - 80,
                        y: size.height * 0.8 - 80,
                        width: 160, height: 160
                    )),
                    with: .color(Color.white.opacity(0.04))
                )
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.5 - 50,
                        y: size.height * 0.05 - 50,
                        width: 100, height: 100
                    )),
                    with: .color(Color.white.opacity(0.03))
                )
            }

            VStack(spacing: 0) {
                Spacer().frame(height: topSafeAreaInset + 4)

                // Toolbar row
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "arrow.left")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Go back")

                    Spacer()
                }
                .padding(.horizontal, 16)

                Spacer().frame(height: 16)

                // Title + subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text("Following")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Scholars you follow for event updates")
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                Spacer().frame(height: 16)

                // Stats chips
                HStack(spacing: 8) {
                    FollowingHeaderChip(
                        icon: "person.fill",
                        label: "\(totalFollowing) Following"
                    )
                    FollowingHeaderChip(
                        icon: "calendar",
                        label: "\(totalUpcomingEvents) Upcoming"
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                Spacer().frame(height: 16)
            }
        }
        .frame(height: 220)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Header Chip
// ══════════════════════════════════════════════════════════════════════════

private struct FollowingHeaderChip: View {
    let icon: String
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.15))
        .clipShape(.rect(cornerRadius: 20))
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Stats Bar
// ══════════════════════════════════════════════════════════════════════════

private struct FollowingStatsBar: View {
    let totalFollowing: Int
    let withUpcoming: Int

    var body: some View {
        HStack {
            Text("\(totalFollowing) scholars followed")
                .font(.caption)
                .foregroundStyle(colorTextSecondary)

            Spacer()

            if withUpcoming > 0 {
                HStack(spacing: 4) {
                    Circle()
                        .fill(colorSuccessGreen)
                        .frame(width: 8, height: 8)
                    Text("\(withUpcoming) with events")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(colorSuccessGreen)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Followed Scholar Card
// ══════════════════════════════════════════════════════════════════════════

private struct FollowedScholarCard: View {
    let scholar: FollowedScholar
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 16) {
                // Avatar circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.appPrimaryTealLight, colorPrimaryTeal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)

                    Text(scholar.initial)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }

                // Scholar details
                VStack(alignment: .leading, spacing: 2) {
                    // Name + verified badge
                    HStack(spacing: 4) {
                        Text(scholar.name)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(colorTextPrimary)
                            .lineLimit(1)

                        if scholar.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundStyle(colorVerifiedBadge)
                        }
                    }

                    // Title
                    Text(scholar.title)
                        .font(.caption)
                        .foregroundStyle(colorTextSecondary)

                    Spacer().frame(height: 2)

                    // Location
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.caption2)
                            .foregroundStyle(colorAccentOrange)
                        Text(scholar.location)
                            .font(.caption2)
                            .foregroundStyle(colorTextSecondary)
                    }

                    Spacer().frame(height: 6)

                    // Bottom row: followed since + badges
                    HStack {
                        Text(scholar.followedSince)
                            .font(.caption2)
                            .foregroundStyle(colorTextSecondary)

                        Spacer()

                        HStack(spacing: 6) {
                            if scholar.upcomingEvents > 0 {
                                Text("\(scholar.upcomingEvents) upcoming")
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(colorPrimaryTeal)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(colorPrimaryTeal.opacity(0.12))
                                    .clipShape(.rect(cornerRadius: 8))
                            }

                            Text("\(scholar.totalEvents) total")
                                .font(.caption2)
                                .foregroundStyle(colorTextSecondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(.rect(cornerRadius: 8))
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.appCardSurface)
            .clipShape(.rect(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Previews
// ══════════════════════════════════════════════════════════════════════════

#Preview("Light") {
    FollowingView()
        .environment(FollowingViewModel())
}

#Preview("Dark") {
    FollowingView()
        .environment(FollowingViewModel())
        .preferredColorScheme(.dark)
}
