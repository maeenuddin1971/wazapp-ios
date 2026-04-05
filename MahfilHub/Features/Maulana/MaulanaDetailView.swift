import SwiftUI

// MARK: - MaulanaDetailView

struct MaulanaDetailView: View {
    let maulana: MaulanaItemModel
    var onEventClick: ((EventItemModel) -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @Environment(EventsViewModel.self) private var eventsViewModel

    @State private var isFollowing: Bool

    init(maulana: MaulanaItemModel, onEventClick: ((EventItemModel) -> Void)? = nil) {
        self.maulana = maulana
        self.onEventClick = onEventClick
        _isFollowing = State(initialValue: maulana.isFollowing)
    }

    private var initial: String {
        if let lastWord = maulana.name.split(separator: " ").last,
           let firstChar = lastWord.first {
            String(firstChar)
        } else {
            "M"
        }
    }

    private var maulanaEvents: [EventItemModel] {
        eventsViewModel.events(forMaulana: maulana.name)
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Scrollable Content ───────────────────────────────────
            ScrollView(.vertical) {
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
                                Button("Back", systemImage: "arrow.left", action: { dismiss() })
                                    .labelStyle(.iconOnly)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white.opacity(0.15))
                                    .clipShape(Circle())
                                    .accessibilityLabel("Go back")
                                Spacer()
                                Button("Share", systemImage: "square.and.arrow.up", action: {})
                                    .labelStyle(.iconOnly)
                                    .font(.body)
                                    .foregroundStyle(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white.opacity(0.15))
                                    .clipShape(Circle())
                                    .accessibilityLabel("Share scholar profile")
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 54) // Matches status bar height under .ignoresSafeArea

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
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 96, height: 96)
                            .clipShape(Circle())

                            Spacer().frame(height: 12)

                            // ── Name + Verified ──────────────────────
                            HStack(spacing: 6) {
                                Text(maulana.name)
                                    .font(.title2.bold())
                                    .foregroundStyle(.white)
                                if maulana.isVerified {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.white)
                                        .font(.body)
                                }
                            }

                            Text(maulana.title)
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))

                            Spacer().frame(height: 6)

                            // ── Rating badge ─────────────────────────
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundStyle(colorAccentOrange)
                                Text(maulana.rating.formatted(.number.precision(.fractionLength(1))))
                                    .font(.footnote.bold())
                                    .foregroundStyle(colorAccentOrange)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(colorAccentOrange.opacity(0.25))
                            .clipShape(.rect(cornerRadius: 12))

                            Spacer().frame(height: 16)
                        }
                        .frame(height: 320)
                    }

                    // ── Stats Row ────────────────────────────────────
                    HStack(spacing: 12) {
                        MaulanaStatCard(value: "\(maulana.totalEvents)", label: "Total Events", color: colorPrimaryTeal)
                        MaulanaStatCard(value: "\(maulana.upcomingEvents)", label: "Upcoming", color: colorAccentOrange)
                        MaulanaStatCard(value: formatFollowerCount(maulana.followers), label: "Followers", color: colorInfoBlue)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                    Spacer().frame(height: 20)

                    // ── About Card ───────────────────────────────────
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.headline)
                            .foregroundStyle(colorTextPrimary)

                        MaulanaInfoRow(icon: "info.circle", label: "Specialization", value: maulana.specialization, color: colorAccentOrange)
                        MaulanaInfoRow(icon: "location.fill", label: "Location", value: maulana.location, color: colorSecondaryGreen)
                        MaulanaInfoRow(icon: "calendar", label: "Events Conducted", value: "\(maulana.totalEvents) events", color: colorPrimaryTeal)
                        MaulanaInfoRow(icon: "person.2.fill", label: "Followers", value: "\(formatFollowerCount(maulana.followers)) followers", color: colorInfoBlue)

                        Spacer().frame(height: 4)

                        Text("\(maulana.name) is a renowned Islamic scholar specializing in \(maulana.specialization). Based in \(maulana.location), they have conducted \(maulana.totalEvents) events and have a community of \(formatFollowerCount(maulana.followers)) devoted followers. Known for their eloquent delivery and deep knowledge, they continue to inspire and educate communities across the region.")
                            .font(.subheadline)
                            .foregroundStyle(colorTextSecondary)
                            .lineSpacing(6)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color.appCardSurface)
                    .clipShape(.rect(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 20)

                    // ── Events by Maulana ────────────────────────────
                    Text("Events by \(maulana.name.split(separator: " ").last.map(String.init) ?? maulana.name)")
                        .font(.headline)
                        .foregroundStyle(colorTextPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                    Spacer().frame(height: 12)

                    if maulanaEvents.isEmpty {
                        // Empty state
                        VStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .font(.largeTitle)
                                .foregroundStyle(colorPrimaryTeal.opacity(0.5))
                            Text("No upcoming events")
                                .font(.subheadline)
                                .foregroundStyle(colorTextSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(32)
                        .background(Color.appCardSurface)
                        .clipShape(.rect(cornerRadius: 16))
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
            .scrollIndicators(.hidden)

            // ── Bottom Action Bar ────────────────────────────────────
            HStack(spacing: 12) {
                Button(action: { isFollowing.toggle() }) {
                    HStack(spacing: 6) {
                        Image(systemName: isFollowing ? "heart.fill" : "heart")
                            .font(.subheadline)
                            .foregroundStyle(isFollowing ? colorErrorRed : colorTextPrimary)
                        Text(isFollowing ? "Following" : "Follow")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(isFollowing ? colorPrimaryTeal : colorTextPrimary)
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
                    .foregroundStyle(.white)
                    .background(colorPrimaryTeal)
                    .clipShape(.rect(cornerRadius: 14))
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

// MARK: - Sub-components

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
                    .foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(colorTextSecondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(colorTextPrimary)
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
                let day = parts.dropFirst().first.map(String.init)?.replacing(",", with: "") ?? ""

                VStack(spacing: 0) {
                    Text(day)
                        .font(.headline)
                        .foregroundStyle(colorPrimaryTeal)
                    Text(month)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(colorPrimaryTeal)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(colorPrimaryTeal.opacity(0.1))
                .clipShape(.rect(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(event.title)
                            .font(.subheadline.bold())
                            .foregroundStyle(colorTextPrimary)
                            .lineLimit(1)
                        if event.isLive {
                            Text("LIVE")
                                .font(.caption.bold())
                                .foregroundStyle(colorErrorRed)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(colorErrorRed.opacity(0.15))
                                .clipShape(.rect(cornerRadius: 4))
                        }
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundStyle(colorAccentOrange)
                        Text(event.location)
                            .font(.caption)
                            .foregroundStyle(colorTextSecondary)
                            .lineLimit(1)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundStyle(colorSecondaryGreen)
                        Text(event.time)
                            .font(.caption)
                            .foregroundStyle(colorTextSecondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(colorTextSecondary.opacity(0.4))
            }
            .padding(14)
            .background(Color.appCardSurface)
            .clipShape(.rect(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}

#Preview {
    MaulanaDetailView(maulana: MaulanaItemModel(
        id: 1, name: "Maulana Abdul Karim", title: "Senior Scholar",
        specialization: "Tafseer & Hadith", location: "Dhaka, Bangladesh",
        totalEvents: 120, upcomingEvents: 3, followers: 4520, rating: 4.9, isVerified: true
    ))
    .environment(EventsViewModel())
}
