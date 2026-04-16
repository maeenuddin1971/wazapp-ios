import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - MyRemindersView
// ══════════════════════════════════════════════════════════════════════════

struct MyRemindersView: View {
    @Environment(MyRemindersViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    var onEventClick: ((ReminderItem) -> Void)? = nil

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                // Header
                RemindersHeader(
                    totalReminders: viewModel.totalReminders,
                    onBack: { dismiss() }
                )

                // Stats bar
                RemindersStatsBar(totalReminders: viewModel.totalReminders)

                // Reminder cards
                ForEach(Array(viewModel.reminders.enumerated()), id: \.element.id) { index, reminder in
                    ReminderCard(
                        reminder: reminder,
                        onTap: { onEventClick?(reminder) }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .bottom)),
                        removal: .opacity
                    ))
                    .animation(
                        .easeOut(duration: 0.3).delay(Double(index) * 0.05),
                        value: viewModel.totalReminders
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
// MARK: - Reminders Header
// ══════════════════════════════════════════════════════════════════════════

private struct RemindersHeader: View {
    let totalReminders: Int
    var onBack: () -> Void = {}

    /// Darker shade of SecondaryGreen for gradient end
    private let greenDark = Color.appSecondaryGreen.opacity(0.75)

    var body: some View {
        ZStack {
            // Gradient background (green theme — matches Android)
            LinearGradient(
                colors: [colorSecondaryGreen, greenDark],
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
                    Text("My Reminders")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Never miss an important event")
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                Spacer().frame(height: 16)

                // Stats chip
                HStack(spacing: 8) {
                    RemindersHeaderChip(
                        icon: "bell.fill",
                        label: "\(totalReminders) Reminders"
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

private struct RemindersHeaderChip: View {
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

private struct RemindersStatsBar: View {
    let totalReminders: Int

    var body: some View {
        HStack {
            Text("\(totalReminders) active reminders")
                .font(.caption)
                .foregroundStyle(colorTextSecondary)

            Spacer()

            HStack(spacing: 4) {
                Circle()
                    .fill(colorSecondaryGreen)
                    .frame(width: 8, height: 8)
                Text("All active")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(colorSecondaryGreen)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Reminder Card
// ══════════════════════════════════════════════════════════════════════════

private struct ReminderCard: View {
    let reminder: ReminderItem
    var onTap: () -> Void = {}

    /// Darker shade of SecondaryGreen for gradient end
    private let greenDark = Color.appSecondaryGreen.opacity(0.75)

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Top accent strip (green gradient)
                LinearGradient(
                    colors: [colorSecondaryGreen, greenDark],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 6)

                // Content row
                HStack(alignment: .top, spacing: 16) {
                    // Days-until column
                    VStack(spacing: 0) {
                        Text("\(reminder.daysUntil)")
                            .font(.title2.bold())
                            .foregroundStyle(colorSecondaryGreen)
                        Text("days")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(colorSecondaryGreen)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(colorSecondaryGreen.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 12))

                    // Event details
                    VStack(alignment: .leading, spacing: 4) {
                        // Title
                        Text(reminder.eventTitle)
                            .font(.callout.bold())
                            .foregroundStyle(colorTextPrimary)
                            .lineLimit(1)

                        // Maulana
                        HStack(spacing: 4) {
                            Image(systemName: "person")
                                .font(.caption)
                                .foregroundStyle(colorPrimaryTeal)
                            Text(reminder.maulana)
                                .font(.caption)
                                .foregroundStyle(colorTextSecondary)
                                .lineLimit(1)
                        }

                        // Location
                        HStack(spacing: 4) {
                            Image(systemName: "mappin")
                                .font(.caption)
                                .foregroundStyle(colorAccentOrange)
                            Text(reminder.location)
                                .font(.caption)
                                .foregroundStyle(colorTextSecondary)
                                .lineLimit(1)
                        }

                        // Date & time
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption)
                                .foregroundStyle(colorInfoBlue)
                            Text("\(reminder.date) · \(reminder.time)")
                                .font(.caption)
                                .foregroundStyle(colorTextSecondary)
                        }

                        Spacer().frame(height: 4)

                        // Reminder time badge
                        HStack(spacing: 4) {
                            Image(systemName: "bell")
                                .font(.caption2)
                                .foregroundStyle(colorAccentOrange)
                            Text(reminder.reminderTime)
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(colorAccentOrange)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(colorAccentOrange.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 8))
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
// MARK: - Previews
// ══════════════════════════════════════════════════════════════════════════

#Preview("Light") {
    MyRemindersView()
        .environment(MyRemindersViewModel())
}

#Preview("Dark") {
    MyRemindersView()
        .environment(MyRemindersViewModel())
        .preferredColorScheme(.dark)
}
