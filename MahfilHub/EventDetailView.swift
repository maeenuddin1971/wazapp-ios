import SwiftUI

// MARK: - EventDetailView

struct EventDetailView: View {
    let event: EventItemModel
    var onBack: () -> Void = {}
    var onMaulanaClick: ((Int) -> Void)? = nil

    @State private var isSaved = false

    private var heroColors: [Color] {
        event.isLive
            ? [Color(red: 0xF4/255, green: 0x43/255, blue: 0x36/255), Color(red: 0xC6/255, green: 0x28/255, blue: 0x28/255)]
            : [colorPrimaryTeal, colorPrimaryTealDark]
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Scrollable Content ───────────────────────────────────
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Hero Header ──────────────────────────────────
                    ZStack(alignment: .top) {
                        LinearGradient(
                            colors: heroColors,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 280)

                        // Decorative circles
                        Canvas { ctx, size in
                            ctx.fill(Circle().path(in: CGRect(x: size.width*0.7, y: size.height*0.05, width: 280, height: 280)), with: .color(Color.white.opacity(0.06)))
                            ctx.fill(Circle().path(in: CGRect(x: -40, y: size.height*0.5, width: 200, height: 200)), with: .color(Color.white.opacity(0.04)))
                            ctx.fill(Circle().path(in: CGRect(x: size.width*0.35, y: -40, width: 140, height: 140)), with: .color(Color.white.opacity(0.03)))
                        }
                        .frame(height: 280)
                        .allowsHitTesting(false)

                        VStack(alignment: .leading, spacing: 0) {
                            // ── Top Bar ──────────────────────────────
                            HStack {
                                Button(action: onBack) {
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.white.opacity(0.15))
                                        .clipShape(Circle())
                                }

                                Spacer()

                                HStack(spacing: 8) {
                                    Button(action: { isSaved.toggle() }) {
                                        Image(systemName: isSaved ? "heart.fill" : "heart")
                                            .font(.system(size: 17))
                                            .foregroundColor(isSaved ? Color(red: 0xF4/255, green: 0x43/255, blue: 0x36/255) : .white)
                                            .frame(width: 40, height: 40)
                                            .background(Color.white.opacity(0.15))
                                            .clipShape(Circle())
                                    }
                                    Button(action: {}) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 17))
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(Color.white.opacity(0.15))
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 8)

                            Spacer()

                            // Badges
                            HStack(spacing: 8) {
                                if event.isLive {
                                    EventBadge(text: "● LIVE NOW", bg: Color.white.opacity(0.25), fg: .white)
                                }
                                if event.isFeatured {
                                    EventBadge(text: "⭐ Featured", bg: colorAccentOrange, fg: .white)
                                }
                            }
                            .padding(.horizontal, 16)

                            Spacer().frame(height: 12)

                            Text(event.title)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .padding(.horizontal, 16)

                            Spacer().frame(height: 8)

                            HStack(spacing: 6) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("\(event.attendees) attending")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20)
                        }
                        .frame(height: 280)
                    }

                    // ── Info Cards ───────────────────────────────────
                    VStack(spacing: 12) {
                        Spacer().frame(height: 4)

                        EventInfoCard(
                            icon: "calendar",
                            iconColor: colorPrimaryTeal,
                            title: "Date & Time",
                            primaryText: event.date,
                            secondaryText: event.time
                        )

                        EventInfoCard(
                            icon: "location.fill",
                            iconColor: colorAccentOrange,
                            title: "Location",
                            primaryText: event.location,
                            secondaryText: "Tap for directions"
                        )

                        EventInfoCard(
                            icon: "person.fill",
                            iconColor: colorVerifiedBadge,
                            title: "Scholar",
                            primaryText: event.maulana,
                            secondaryText: "View profile"
                        )
                    }
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 20)

                    // ── About ────────────────────────────────────────
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About This Event")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(colorTextPrimary)

                        Text("Join us for an enlightening session of \(event.title) led by \(event.maulana). This event brings together the Muslim community for spiritual growth, knowledge sharing, and strengthening of faith. Everyone is welcome to attend and benefit from this blessed gathering.\n\nThe program will include recitation of the Holy Quran, an insightful lecture, and a Q&A session. Light refreshments will be provided after the event.")
                            .font(.system(size: 14))
                            .foregroundColor(colorTextSecondary)
                            .lineSpacing(6)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 20)

                    // ── Quick Stats ──────────────────────────────────
                    HStack(spacing: 12) {
                        EventQuickStatCard(
                            icon: "person.fill",
                            value: "\(event.attendees)",
                            label: "Attending",
                            color: colorPrimaryTeal
                        )
                        EventQuickStatCard(
                            icon: "star.fill",
                            value: event.isFeatured ? "Featured" : "Regular",
                            label: "Status",
                            color: colorAccentOrange
                        )
                        EventQuickStatCard(
                            icon: "checkmark.circle.fill",
                            value: event.category,
                            label: "Category",
                            color: colorSecondaryGreen
                        )
                    }
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 20)

                    // ── Guidelines ───────────────────────────────────
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle")
                                .foregroundColor(colorPrimaryTeal)
                                .font(.system(size: 18))
                            Text("Event Guidelines")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(colorPrimaryTeal)
                        }

                        let guidelines = [
                            "Please arrive 15 minutes early",
                            "Maintain silence during the lecture",
                            "Bring your own prayer mat if possible",
                            "Photography is not allowed during the program"
                        ]
                        ForEach(guidelines, id: \.self) { g in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(colorPrimaryTeal)
                                Text(g)
                                    .font(.system(size: 13))
                                    .foregroundColor(colorTextSecondary)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(colorPrimaryTeal.opacity(0.08))
                    .cornerRadius(16)
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 100)
                }
            }

            // ── Bottom Action Bar ────────────────────────────────────
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "bell")
                            .font(.system(size: 15))
                        Text("Remind Me")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(colorPrimaryTeal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(colorPrimaryTeal, lineWidth: 1.5)
                    )
                }

                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 15))
                        Text("Attend")
                            .font(.system(size: 15, weight: .bold))
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
                Color.white
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: -2)
            )
            .padding(.bottom, 0)
        }
        .ignoresSafeArea(edges: .top)
        .background(colorBackgroundCream)
    }
}

// MARK: - Sub-components

private struct EventBadge: View {
    let text: String; let bg: Color; let fg: Color
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(fg)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(bg)
            .cornerRadius(8)
    }
}

private struct EventInfoCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let primaryText: String
    let secondaryText: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(colorTextSecondary)
                Text(primaryText)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(colorTextPrimary)
                Text(secondaryText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(iconColor)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(colorTextSecondary.opacity(0.4))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

private struct EventQuickStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
            }
            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(colorTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(colorTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    EventDetailView(event: EventItemModel(
        id: 1, title: "Friday Waz Mahfil", maulana: "Maulana Abdul Karim",
        location: "Dhaka Central Mosque, Motijheel", date: "Mar 14, 2026",
        time: "After Jummah", isLive: true, isFeatured: true, attendees: 245, category: "Today"
    ))
}
