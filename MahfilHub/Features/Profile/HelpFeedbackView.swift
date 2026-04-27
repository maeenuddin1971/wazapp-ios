import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - HelpFeedbackView
// ══════════════════════════════════════════════════════════════════════════

struct HelpFeedbackView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                // Header
                HelpFeedbackHeader(onBack: { dismiss() })

                // Content
                VStack(spacing: 0) {
                    Spacer().frame(height: 16)

                    // ── Get Help ─────────────────────────────────────
                    HelpSectionTitle(title: "Get Help")
                    Spacer().frame(height: 8)

                    HelpActionRow(icon: "envelope", title: "Email Support", subtitle: "Get help via email", color: colorInfoBlue)
                    HelpActionRow(icon: "phone", title: "Call Support", subtitle: "+880 1700-000000", color: colorPrimaryTeal)
                    HelpActionRow(icon: "message", title: "Live Chat", subtitle: "Chat with our support team", color: colorSecondaryGreen)

                    Spacer().frame(height: 24)

                    // ── FAQ ──────────────────────────────────────────
                    HelpSectionTitle(title: "FAQ")
                    Spacer().frame(height: 8)

                    HelpActionRow(icon: "info.circle", title: "How to find events?", subtitle: "Browse or search for events near you", color: colorAccentOrange)
                    HelpActionRow(icon: "heart", title: "How to save events?", subtitle: "Tap the heart icon on any event", color: colorErrorRed)
                    HelpActionRow(icon: "bell", title: "How do reminders work?", subtitle: "Set reminders for upcoming events", color: colorSecondaryGreen)
                    HelpActionRow(icon: "person", title: "How to follow scholars?", subtitle: "Visit a scholar's profile and tap Follow", color: colorPrimaryTeal)

                    Spacer().frame(height: 24)

                    // ── Feedback ─────────────────────────────────────
                    HelpSectionTitle(title: "Feedback")
                    Spacer().frame(height: 8)

                    HelpActionRow(icon: "star", title: "Rate the App", subtitle: "Leave a review on App Store", color: colorAccentOrange)
                    HelpActionRow(icon: "exclamationmark.triangle", title: "Report a Bug", subtitle: "Help us fix issues", color: colorErrorRed)
                    HelpActionRow(icon: "lightbulb", title: "Suggest a Feature", subtitle: "Share your ideas with us", color: colorInfoBlue)

                    Spacer().frame(height: 32)
                }
                .padding(.horizontal, 16)
            }
        }
        .scrollIndicators(.hidden)
        .background(colorBackgroundCream)
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarHidden(true)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Help Feedback Header
// ══════════════════════════════════════════════════════════════════════════

private struct HelpFeedbackHeader: View {
    var onBack: () -> Void = {}

    var body: some View {
        ZStack {
            // Gradient background (blue theme — matches Android's InfoBlue)
            LinearGradient(
                colors: [colorInfoBlue, Color(red: 0.10, green: 0.23, blue: 0.36)],
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
                    Text("Help & Feedback")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Contact us, report issues")
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                Spacer().frame(height: 20)
            }
        }
        .frame(height: 180)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Section Title
// ══════════════════════════════════════════════════════════════════════════

private struct HelpSectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.footnote.bold())
            .foregroundStyle(colorTextSecondary)
            .tracking(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Help Action Row
// ══════════════════════════════════════════════════════════════════════════

private struct HelpActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                // Icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.1))
                        .frame(width: 40, height: 40)

                    Image(systemName: icon)
                        .font(.body)
                        .foregroundStyle(color)
                }

                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(colorTextPrimary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(colorTextSecondary)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.appCardSurface)
            .clipShape(.rect(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.04), radius: 1, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Previews
// ══════════════════════════════════════════════════════════════════════════

#Preview("Light") {
    HelpFeedbackView()
}

#Preview("Dark") {
    HelpFeedbackView()
        .preferredColorScheme(.dark)
}
