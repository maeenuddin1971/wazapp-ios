import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - SavedEventsView
// ══════════════════════════════════════════════════════════════════════════

struct SavedEventsView: View {
    @Environment(SavedEventsViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    var onEventClick: ((SavedEventItem) -> Void)? = nil

    var body: some View {
        @Bindable var vm = viewModel
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                // Header
                SavedEventsHeader(
                    totalSaved: vm.totalSaved,
                    upcomingCount: vm.upcomingCount,
                    pastCount: vm.pastCount,
                    onBack: { dismiss() }
                )

                // Filter chips
                SavedEventsFilterChips(
                    filters: vm.filters,
                    selectedFilter: $vm.selectedFilter
                )

                // Stats bar
                SavedEventsStatsBar(
                    totalSaved: vm.filteredEvents.count,
                    upcomingCount: vm.filteredEvents.count(where: \.isUpcoming)
                )

                // Events list or empty state
                if vm.filteredEvents.isEmpty {
                    SavedEventsEmptyState()
                } else {
                    ForEach(Array(vm.filteredEvents.enumerated()), id: \.element.id) { index, event in
                        SavedEventCard(event: event, onTap: { onEventClick?(event) })
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .bottom)),
                                removal: .opacity
                            ))
                            .animation(
                                .easeOut(duration: 0.3).delay(Double(index) * 0.05),
                                value: vm.selectedFilter
                            )
                    }
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
// MARK: - Saved Events Header
// ══════════════════════════════════════════════════════════════════════════

private struct SavedEventsHeader: View {
    let totalSaved: Int
    let upcomingCount: Int
    let pastCount: Int
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
                        x: size.width * 0.85 - 130,
                        y: size.height * 0.25 - 130,
                        width: 260, height: 260
                    )),
                    with: .color(Color.white.opacity(0.06))
                )
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.1 - 90,
                        y: size.height * 0.8 - 90,
                        width: 180, height: 180
                    )),
                    with: .color(Color.white.opacity(0.04))
                )
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.5 - 60,
                        y: size.height * 0.1 - 60,
                        width: 120, height: 120
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

                Spacer().frame(height: 12)

                // Icon + Title
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundStyle(.white)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Saved Events")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                        Text("Your bookmarked events collection")
                            .font(.caption)
                            .foregroundStyle(Color.white.opacity(0.7))
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)

                Spacer().frame(height: 16)

                // Stats chips
                HStack(spacing: 8) {
                    SavedHeaderChip(
                        icon: "heart.fill",
                        label: "\(totalSaved) Saved",
                        iconColor: colorErrorRed
                    )
                    SavedHeaderChip(
                        icon: "calendar",
                        label: "\(upcomingCount) Upcoming",
                        iconColor: colorAccentOrange
                    )
                    SavedHeaderChip(
                        icon: "checkmark",
                        label: "\(pastCount) Past",
                        iconColor: colorSuccessGreen
                    )
                }
                .padding(.horizontal, 16)

                Spacer().frame(height: 16)
            }
        }
        .frame(height: 240)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Header Chip
// ══════════════════════════════════════════════════════════════════════════

private struct SavedHeaderChip: View {
    let icon: String
    let label: String
    let iconColor: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(iconColor)
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
// MARK: - Filter Chips
// ══════════════════════════════════════════════════════════════════════════

private struct SavedEventsFilterChips: View {
    let filters: [String]
    @Binding var selectedFilter: String

    var body: some View {
        HStack(spacing: 8) {
            ForEach(filters, id: \.self) { filter in
                let isSelected = filter == selectedFilter

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedFilter = filter
                    }
                }) {
                    Text(filter)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .bold : .regular)
                        .foregroundStyle(isSelected ? .white : colorTextPrimary)
                        .padding(.horizontal, 16)
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
        .padding(.vertical, 16)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Stats Bar
// ══════════════════════════════════════════════════════════════════════════

private struct SavedEventsStatsBar: View {
    let totalSaved: Int
    let upcomingCount: Int

    var body: some View {
        HStack {
            Text("\(totalSaved) saved events")
                .font(.caption)
                .foregroundStyle(colorTextSecondary)

            Spacer()

            if upcomingCount > 0 {
                HStack(spacing: 4) {
                    Circle()
                        .fill(colorSuccessGreen)
                        .frame(width: 8, height: 8)
                    Text("\(upcomingCount) Upcoming")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(colorSuccessGreen)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Saved Event Card
// ══════════════════════════════════════════════════════════════════════════

private struct SavedEventCard: View {
    let event: SavedEventItem
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

    private var accentColors: [Color] {
        if event.isLive {
            return [colorErrorRed, colorErrorRed.opacity(0.8)]
        } else if event.isUpcoming {
            return [colorPrimaryTeal, colorPrimaryTealDark]
        } else {
            return [Color.gray.opacity(0.4), Color.gray.opacity(0.4)]
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Top accent strip
                LinearGradient(
                    colors: accentColors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 6)

                // Content row
                HStack(alignment: .top, spacing: 16) {
                    // Date column
                    VStack(spacing: 0) {
                        Text(dayNumber)
                            .font(.title2.bold())
                            .foregroundStyle(
                                event.isUpcoming ? colorPrimaryTeal : colorTextSecondary
                            )
                        Text(monthAbbr)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(
                                event.isUpcoming ? colorPrimaryTeal : colorTextSecondary
                            )
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        event.isUpcoming
                            ? colorPrimaryTeal.opacity(0.1)
                            : Color.gray.opacity(0.1)
                    )
                    .clipShape(.rect(cornerRadius: 12))
                    .frame(width: 52)

                    // Event details
                    VStack(alignment: .leading, spacing: 6) {
                        // Title + LIVE badge
                        HStack(spacing: 8) {
                            Text(event.title)
                                .font(.callout.bold())
                                .foregroundStyle(colorTextPrimary)
                                .lineLimit(1)

                            if event.isLive {
                                HStack(spacing: 3) {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 5, height: 5)
                                    Text("LIVE")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(.white)
                                        .tracking(0.5)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(colorErrorRed)
                                .clipShape(.rect(cornerRadius: 8))
                            }
                        }

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

                        // Time
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption)
                                .foregroundStyle(colorSecondaryGreen)
                            Text(event.time)
                                .font(.caption)
                                .foregroundStyle(colorTextSecondary)
                        }

                        // Bottom row: saved date + actions
                        HStack {
                            HStack(spacing: 4) {
                                Image(systemName: "heart")
                                    .font(.caption2)
                                    .foregroundStyle(colorErrorRed.opacity(0.7))
                                Text(event.savedDate)
                                    .font(.caption2)
                                    .foregroundStyle(colorTextSecondary)
                            }

                            Spacer()

                            HStack(spacing: 4) {
                                Button(action: {}) {
                                    Image(systemName: "heart.fill")
                                        .font(.callout)
                                        .foregroundStyle(colorErrorRed)
                                        .frame(width: 32, height: 32)
                                }
                                Button(action: {}) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.caption)
                                        .foregroundStyle(colorTextSecondary)
                                        .frame(width: 32, height: 32)
                                }
                            }
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(16)
            }
            .background(Color.appCardSurface)
            .clipShape(.rect(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Empty State
// ══════════════════════════════════════════════════════════════════════════

private struct SavedEventsEmptyState: View {
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(colorErrorRed.opacity(0.1))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "heart")
                        .font(.largeTitle)
                        .foregroundStyle(colorErrorRed)
                )

            Text("No Saved Events")
                .font(.headline)
                .foregroundStyle(colorTextPrimary)

            Text("Events you save will appear here.\nTap the heart icon on any event to save it.")
                .font(.subheadline)
                .foregroundStyle(colorTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
        .padding(.horizontal, 32)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Previews
// ══════════════════════════════════════════════════════════════════════════

#Preview("Light") {
    SavedEventsView()
        .environment(SavedEventsViewModel())
}

#Preview("Dark") {
    SavedEventsView()
        .environment(SavedEventsViewModel())
        .preferredColorScheme(.dark)
}
