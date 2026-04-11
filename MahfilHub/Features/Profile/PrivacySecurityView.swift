import SwiftUI

// MARK: - Scroll Offset Key

private struct PrivacySecurityScrollKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - PrivacySecurityView — Collapsing Header
// ══════════════════════════════════════════════════════════════════════════

struct PrivacySecurityView: View {
    @Environment(\.dismiss) private var dismiss

    // Toggle states
    @State private var biometricLock = false
    @State private var twoFactorAuth = true
    @State private var loginAlerts = true
    @State private var showOnlineStatus = true
    @State private var showLastSeen = false
    @State private var showProfilePhoto = true
    @State private var dataSharing = false
    @State private var personalizedContent = false

    // Scroll tracking
    @State private var scrollOffset: CGFloat = 0

    private let expandedHeight: CGFloat = 220
    private let collapsedHeight: CGFloat = 100

    /// 0 = expanded, 1 = collapsed
    private var collapseProgress: CGFloat {
        let maxScroll = expandedHeight - collapsedHeight
        guard maxScroll > 0 else { return 0 }
        return min(max(-scrollOffset / maxScroll, 0), 1)
    }

    private var currentHeaderHeight: CGFloat {
        max(expandedHeight + min(scrollOffset, 0), collapsedHeight)
    }

    var body: some View {
        ZStack(alignment: .top) {
            colorBackgroundCream.ignoresSafeArea()

            // ── Scrollable Content ────────────────────────────────────
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header spacer — drives collapse
                    Color.clear
                        .frame(height: expandedHeight + 8)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: PrivacySecurityScrollKey.self,
                                    value: geo.frame(in: .named("privacySecurityScroll")).origin.y
                                )
                            }
                        )

                    VStack(spacing: 0) {
                        Spacer().frame(height: 16)

                        // ── Security Section ──────────────────────────
                        SecuritySectionLabel(text: "Security")
                        Spacer().frame(height: 8)

                        SecurityActionRow(
                            icon: "lock",
                            title: "Change Password",
                            subtitle: "Last changed 30 days ago",
                            color: colorInfoBlue,
                            action: {}
                        )

                        SecurityToggleRow(
                            icon: "touchid",
                            title: "Biometric Lock",
                            subtitle: "Use fingerprint or face to unlock",
                            color: colorPrimaryTeal,
                            isOn: $biometricLock
                        )

                        SecurityToggleRow(
                            icon: "shield",
                            title: "Two-Factor Authentication",
                            subtitle: "Extra security for your account",
                            color: colorSecondaryGreen,
                            isOn: $twoFactorAuth
                        )

                        SecurityToggleRow(
                            icon: "bell.badge",
                            title: "Login Alerts",
                            subtitle: "Get notified of new sign-ins",
                            color: colorAccentOrange,
                            isOn: $loginAlerts
                        )

                        Spacer().frame(height: 24)

                        // ── Privacy Section ───────────────────────────
                        SecuritySectionLabel(text: "Privacy")
                        Spacer().frame(height: 8)

                        SecurityToggleRow(
                            icon: "eye",
                            title: "Online Status",
                            subtitle: "Show when you're active",
                            color: colorSecondaryGreen,
                            isOn: $showOnlineStatus
                        )

                        SecurityToggleRow(
                            icon: "clock",
                            title: "Last Seen",
                            subtitle: "Show your last active time",
                            color: colorInfoBlue,
                            isOn: $showLastSeen
                        )

                        SecurityToggleRow(
                            icon: "person.circle",
                            title: "Profile Photo Visibility",
                            subtitle: "Let others see your photo",
                            color: colorPrimaryTeal,
                            isOn: $showProfilePhoto
                        )

                        Spacer().frame(height: 24)

                        // ── Data & Permissions Section ────────────────
                        SecuritySectionLabel(text: "Data & Permissions")
                        Spacer().frame(height: 8)

                        SecurityToggleRow(
                            icon: "square.and.arrow.up",
                            title: "Data Sharing",
                            subtitle: "Share usage data to improve app",
                            color: colorAccentOrange,
                            isOn: $dataSharing
                        )

                        SecurityToggleRow(
                            icon: "megaphone",
                            title: "Personalized Content",
                            subtitle: "See tailored event recommendations",
                            color: colorPrimaryTealDark,
                            isOn: $personalizedContent
                        )

                        SecurityActionRow(
                            icon: "externaldrive",
                            title: "Download My Data",
                            subtitle: "Get a copy of your personal data",
                            color: colorInfoBlue,
                            action: {}
                        )

                        SecurityActionRow(
                            icon: "trash",
                            title: "Clear App Data",
                            subtitle: "Remove cached files and preferences",
                            color: colorErrorRed,
                            action: {}
                        )

                        Spacer().frame(height: 24)

                        // ── Active Sessions Section ───────────────────
                        SecuritySectionLabel(text: "Active Sessions")
                        Spacer().frame(height: 8)

                        ActiveSessionCard(
                            device: "iPhone 15 Pro",
                            location: "Dhaka, Bangladesh",
                            lastActive: "Active now",
                            isCurrent: true
                        )

                        ActiveSessionCard(
                            device: "Chrome on MacOS",
                            location: "Dhaka, Bangladesh",
                            lastActive: "2 hours ago",
                            isCurrent: false
                        )

                        Spacer().frame(height: 8)

                        // ── Sign Out All Sessions ─────────────────────
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.subheadline)
                                Text("Sign Out All Other Sessions")
                                    .font(.subheadline.weight(.semibold))
                            }
                            .foregroundStyle(colorErrorRed)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(colorErrorRed.opacity(0.4), lineWidth: 1.5)
                            )
                        }

                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .coordinateSpace(name: "privacySecurityScroll")
            .onPreferenceChange(PrivacySecurityScrollKey.self) { value in
                scrollOffset = value
            }

            // ── Collapsing Header ─────────────────────────────────────
            collapsingHeader
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarHidden(true)
    }

    // MARK: - Collapsing Header

    private var collapsingHeader: some View {
        ZStack(alignment: .topLeading) {
            // Gradient background (blue tones matching Android)
            LinearGradient(
                colors: [colorInfoBlue, Color(red: 0.10, green: 0.23, blue: 0.36)],
                startPoint: .top,
                endPoint: .bottom
            )

            // Decorative circles
            Canvas { ctx, size in
                let fade = 1 - collapseProgress
                ctx.fill(
                    Circle().path(in: CGRect(
                        x: size.width * 0.85 - 120,
                        y: size.height * 0.2 - 120,
                        width: 240, height: 240
                    )),
                    with: .color(Color.white.opacity(0.06 * fade))
                )
                ctx.fill(
                    Circle().path(in: CGRect(
                        x: size.width * 0.1 - 80,
                        y: size.height * 0.8 - 80,
                        width: 160, height: 160
                    )),
                    with: .color(Color.white.opacity(0.04 * fade))
                )
                ctx.fill(
                    Circle().path(in: CGRect(
                        x: size.width * 0.5 - 50,
                        y: size.height * 0.05 - 50,
                        width: 100, height: 100
                    )),
                    with: .color(Color.white.opacity(0.03 * fade))
                )
            }
            .allowsHitTesting(false)

            // ── Back button ───────────────────────────────────────────
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.15 * (1 - collapseProgress)))
                    .clipShape(Circle())
            }
            .padding(.leading, 12)
            .padding(.top, topSafeAreaInset + 8)

            // ── Animated Title ────────────────────────────────────────
            Text("Privacy & Security")
                .font(.system(size: lerp(22, 18, collapseProgress), weight: .bold))
                .foregroundStyle(.white)
                .padding(.leading, lerp(16, 56, collapseProgress))
                .padding(.top, lerp(topSafeAreaInset + 70, topSafeAreaInset + 12, collapseProgress))

            // ── Subtitle (fades on collapse) ─────────────────────────
            Text("Manage your account security and privacy settings")
                .font(.subheadline)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(.leading, 16)
                .padding(.top, lerp(topSafeAreaInset + 100, topSafeAreaInset + 40, collapseProgress))
                .opacity(max(1 - collapseProgress * 2, 0))

            // ── Shield Icon (fades on collapse) ──────────────────────
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "shield")
                        .font(.system(size: 80))
                        .foregroundStyle(Color.white.opacity(0.15))
                        .padding(.trailing, 24)
                        .padding(.bottom, 16)
                }
            }
            .opacity(max(1 - collapseProgress * 2.5, 0))
        }
        .frame(height: currentHeaderHeight)
        .clipped()
    }

    // MARK: - Lerp

    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Components
// ══════════════════════════════════════════════════════════════════════════

private struct SecuritySectionLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.footnote.bold())
            .foregroundStyle(colorTextSecondary)
            .tracking(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 4)
    }
}

private struct SecurityToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(colorTextPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(colorTextSecondary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(color)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.appCardSurface)
        .clipShape(.rect(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.03), radius: 2, y: 1)
        .padding(.bottom, 6)
    }
}

private struct SecurityActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.body)
                        .foregroundStyle(color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(colorTextPrimary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(colorTextSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(colorTextSecondary.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.appCardSurface)
            .clipShape(.rect(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.03), radius: 2, y: 1)
        }
        .padding(.bottom, 6)
    }
}

private struct ActiveSessionCard: View {
    let device: String
    let location: String
    let lastActive: String
    let isCurrent: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isCurrent
                            ? colorSecondaryGreen.opacity(0.1)
                            : colorTextSecondary.opacity(0.08)
                    )
                    .frame(width: 40, height: 40)
                Image(systemName: device.contains("Chrome") ? "desktopcomputer" : "iphone")
                    .font(.body)
                    .foregroundStyle(isCurrent ? colorSecondaryGreen : colorTextSecondary)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Text(device)
                        .font(.subheadline)
                        .foregroundStyle(colorTextPrimary)

                    if isCurrent {
                        Text("Current")
                            .font(.caption2.bold())
                            .foregroundStyle(colorSecondaryGreen)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(colorSecondaryGreen.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 6))
                    }
                }
                Text("\(location) · \(lastActive)")
                    .font(.caption)
                    .foregroundStyle(colorTextSecondary)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.appCardSurface)
        .clipShape(.rect(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.03), radius: 2, y: 1)
        .padding(.bottom, 6)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Previews
// ══════════════════════════════════════════════════════════════════════════

#Preview("Light") {
    NavigationStack {
        PrivacySecurityView()
    }
}

#Preview("Dark") {
    NavigationStack {
        PrivacySecurityView()
    }
    .preferredColorScheme(.dark)
}
