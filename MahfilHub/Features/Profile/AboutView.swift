import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - AboutView
// ══════════════════════════════════════════════════════════════════════════

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                // Header
                AboutHeader(onBack: { dismiss() })

                // Content
                VStack(spacing: 0) {
                    Spacer().frame(height: 16)

                    // App Info Card
                    AboutAppInfoCard()

                    Spacer().frame(height: 24)

                    // About section
                    AboutSectionTitle(title: "About")
                    Spacer().frame(height: 8)

                    AboutInfoRow(icon: "info.circle", title: "Version", value: "1.0.0", color: colorPrimaryTeal)
                    AboutInfoRow(icon: "hammer", title: "Build", value: "2026.04.01", color: colorInfoBlue)
                    AboutInfoRow(icon: "star", title: "Developer", value: "Maeen Technologies", color: colorAccentOrange)
                    AboutInfoRow(icon: "envelope", title: "Contact", value: "support@mahfilhub.com", color: colorSecondaryGreen)

                    Spacer().frame(height: 24)

                    // Legal section
                    AboutSectionTitle(title: "Legal")
                    Spacer().frame(height: 8)

                    AboutInfoRow(icon: "doc.text", title: "Privacy Policy", value: "View our privacy policy", color: colorInfoBlue)
                    AboutInfoRow(icon: "doc.plaintext", title: "Terms of Service", value: "View terms and conditions", color: colorPrimaryTeal)
                    AboutInfoRow(icon: "square.stack.3d.up", title: "Open Source Licenses", value: "Third-party libraries", color: colorAccentOrange)

                    Spacer().frame(height: 24)

                    // Copyright
                    Text("© 2026 Maeen Technologies. All rights reserved.")
                        .font(.caption2)
                        .foregroundStyle(colorTextSecondary)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

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
// MARK: - About Header
// ══════════════════════════════════════════════════════════════════════════

private struct AboutHeader: View {
    var onBack: () -> Void = {}

    var body: some View {
        ZStack {
            // Gradient background (teal theme)
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
                    Text("About")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("About MahfilHub v1.0")
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
// MARK: - App Info Card
// ══════════════════════════════════════════════════════════════════════════

private struct AboutAppInfoCard: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 24)

            // App icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.appPrimaryTealLight, colorPrimaryTeal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 72, height: 72)

                Text("M")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
            }

            Spacer().frame(height: 16)

            // App name
            Text("MahfilHub")
                .font(.title3.bold())
                .foregroundStyle(colorTextPrimary)

            // Version
            Text("Version 1.0.0")
                .font(.caption)
                .foregroundStyle(colorTextSecondary)

            Spacer().frame(height: 16)

            // Description
            Text("Your companion for discovering and attending Islamic events, Waz Mahfils, and connecting with scholars.")
                .font(.subheadline)
                .foregroundStyle(colorTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            Spacer().frame(height: 24)
        }
        .frame(maxWidth: .infinity)
        .background(Color.appCardSurface)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 1)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Section Title
// ══════════════════════════════════════════════════════════════════════════

private struct AboutSectionTitle: View {
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
// MARK: - Info Row
// ══════════════════════════════════════════════════════════════════════════

private struct AboutInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
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
                Text(value)
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
        .padding(.vertical, 4)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Previews
// ══════════════════════════════════════════════════════════════════════════

#Preview("Light") {
    AboutView()
}

#Preview("Dark") {
    AboutView()
        .preferredColorScheme(.dark)
}
