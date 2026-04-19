import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - EventHistoryView
// ══════════════════════════════════════════════════════════════════════════

struct EventHistoryView: View {
    @Environment(EventHistoryViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    var onEventClick: ((HistoryEventItem) -> Void)? = nil

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                // Header
                HistoryHeader(
                    totalEvents: viewModel.totalEvents,
                    onBack: { dismiss() }
                )

                // Stats bar
                HistoryStatsBar(
                    totalEvents: viewModel.totalEvents,
                    averageRating: viewModel.averageRating
                )

                // Event cards
                ForEach(Array(viewModel.events.enumerated()), id: \.element.id) { index, event in
                    HistoryEventCard(
                        event: event,
                        onTap: { onEventClick?(event) }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .bottom)),
                        removal: .opacity
                    ))
                    .animation(
                        .easeOut(duration: 0.3).delay(Double(index) * 0.05),
                        value: viewModel.totalEvents
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
// MARK: - History Header
// ══════════════════════════════════════════════════════════════════════════

private struct HistoryHeader: View {
    let totalEvents: Int
    var onBack: () -> Void = {}

    /// Dark orange for gradient end (matches Android Color(0xFFE65100))
    private let orangeDark = Color(red: 230/255, green: 81/255, blue: 0/255)

    var body: some View {
        ZStack {
            // Gradient background (orange theme — matches Android)
            LinearGradient(
                colors: [colorAccentOrange, orangeDark],
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
                    Text("Event History")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Events you have attended")
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                Spacer().frame(height: 16)

                // Stats chip
                HStack(spacing: 8) {
                    HistoryHeaderChip(
                        icon: "checkmark",
                        label: "\(totalEvents) Attended"
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

private struct HistoryHeaderChip: View {
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

private struct HistoryStatsBar: View {
    let totalEvents: Int
    let averageRating: Float

    var body: some View {
        HStack {
            Text("\(totalEvents) events attended")
                .font(.caption)
                .foregroundStyle(colorTextSecondary)

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundStyle(colorAccentOrange)
                Text("Avg \(String(format: "%.1f", averageRating))")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(colorAccentOrange)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - History Event Card
// ══════════════════════════════════════════════════════════════════════════

private struct HistoryEventCard: View {
    let event: HistoryEventItem
    var onTap: () -> Void = {}

    private var dateParts: [String] {
        event.date.split(separator: " ").map(String.init)
    }

    private var dayNumber: String {
        guard dateParts.count >= 2 else { return "" }
        return dateParts[1].replacing(",", with: "")
    }

    private var monthAbbr: String {
        guard !dateParts.isEmpty else { return "" }
        return dateParts[0]
    }

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 16) {
                // Date column
                VStack(spacing: 0) {
                    Text(dayNumber)
                        .font(.title2.bold())
                        .foregroundStyle(colorTextSecondary)
                    Text(monthAbbr)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(colorTextSecondary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 12))
                .frame(width: 52)

                // Event details
                VStack(alignment: .leading, spacing: 4) {
                    // Title
                    Text(event.title)
                        .font(.callout.bold())
                        .foregroundStyle(colorTextPrimary)
                        .lineLimit(1)

                    // Maulana
                    HStack(spacing: 4) {
                        Image(systemName: "person")
                            .font(.caption)
                            .foregroundStyle(colorPrimaryTeal)
                        Text(event.maulana)
                            .font(.caption)
                            .foregroundStyle(colorTextSecondary)
                            .lineLimit(1)
                    }

                    // Location
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.caption)
                            .foregroundStyle(colorAccentOrange)
                        Text(event.location)
                            .font(.caption)
                            .foregroundStyle(colorTextSecondary)
                            .lineLimit(1)
                    }

                    Spacer().frame(height: 4)

                    // Bottom row: rating badge + attendees badge
                    HStack {
                        // Rating badge
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundStyle(colorAccentOrange)
                            Text(String(format: "%.1f", event.rating))
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(colorAccentOrange)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(colorAccentOrange.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 8))

                        Spacer()

                        // Attendees badge
                        Text("\(event.attendees) attended")
                            .font(.caption2)
                            .foregroundStyle(colorTextSecondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 8))
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
    EventHistoryView()
        .environment(EventHistoryViewModel())
}

#Preview("Dark") {
    EventHistoryView()
        .environment(EventHistoryViewModel())
        .preferredColorScheme(.dark)
}
