import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - SettingsView
// ══════════════════════════════════════════════════════════════════════════

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    // Navigation callbacks (for items that push to another screen)
    var onEditProfileTap: (() -> Void)? = nil
    var onNotificationsTap: (() -> Void)? = nil
    var onPrivacySecurityTap: (() -> Void)? = nil
    var onLanguageTap: (() -> Void)? = nil
    var onAboutTap: (() -> Void)? = nil
    var onHelpFeedbackTap: (() -> Void)? = nil

    // Toggle states
    @State private var isDarkTheme = false
    @State private var autoplayAudio = true
    @State private var downloadOverWifi = true

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                // Header
                SettingsHeader(onBack: { dismiss() })

                // Content
                VStack(spacing: 0) {
                    Spacer().frame(height: 8)

                    // ── General ──────────────────────────────────────
                    SettingsSectionTitle(title: "General")
                    Spacer().frame(height: 8)
                    SettingsMenuGroup(items: [
                        SettingsItem(
                            icon: "person", title: "Edit Profile",
                            subtitle: "Update your personal information",
                            color: colorPrimaryTeal, action: onEditProfileTap
                        ),
                        SettingsItem(
                            icon: "bell", title: "Notifications",
                            subtitle: "Push notifications, sounds, badges",
                            color: colorAccentOrange, action: onNotificationsTap
                        ),
                        SettingsItem(
                            icon: "lock", title: "Privacy & Security",
                            subtitle: "Password, 2FA, data privacy",
                            color: colorInfoBlue, action: onPrivacySecurityTap
                        ),
                    ])

                    Spacer().frame(height: 24)

                    // ── Appearance ───────────────────────────────────
                    SettingsSectionTitle(title: "Appearance")
                    Spacer().frame(height: 8)
                    SettingsMenuGroup(items: [
                        SettingsItem(
                            icon: "globe", title: "Language",
                            subtitle: "English",
                            color: colorVerifiedBadge, action: onLanguageTap
                        ),
                        SettingsItem(
                            icon: "paintbrush", title: "Theme",
                            subtitle: isDarkTheme ? "Dark" : "Light",
                            color: colorPrimaryTealDark,
                            hasToggle: true, isToggled: $isDarkTheme
                        ),
                        SettingsItem(
                            icon: "mappin", title: "Location",
                            subtitle: "Dhaka, Bangladesh",
                            color: colorSecondaryGreen
                        ),
                    ])

                    Spacer().frame(height: 24)

                    // ── Content ──────────────────────────────────────
                    SettingsSectionTitle(title: "Content")
                    Spacer().frame(height: 8)
                    SettingsMenuGroup(items: [
                        SettingsItem(
                            icon: "play.circle", title: "Auto-play Audio",
                            subtitle: "Auto-play event audio previews",
                            color: colorPrimaryTeal,
                            hasToggle: true, isToggled: $autoplayAudio
                        ),
                        SettingsItem(
                            icon: "wifi", title: "Download over Wi-Fi only",
                            subtitle: "Save mobile data",
                            color: colorInfoBlue,
                            hasToggle: true, isToggled: $downloadOverWifi
                        ),
                    ])

                    Spacer().frame(height: 24)

                    // ── Support ──────────────────────────────────────
                    SettingsSectionTitle(title: "Support")
                    Spacer().frame(height: 8)
                    SettingsMenuGroup(items: [
                        SettingsItem(
                            icon: "info.circle", title: "About",
                            subtitle: "About MahfilHub v1.0",
                            color: colorPrimaryTeal, action: onAboutTap
                        ),
                        SettingsItem(
                            icon: "envelope", title: "Help & Feedback",
                            subtitle: "Contact us, report issues",
                            color: colorInfoBlue, action: onHelpFeedbackTap
                        ),
                        SettingsItem(
                            icon: "square.and.arrow.up", title: "Share App",
                            subtitle: "Invite friends to MahfilHub",
                            color: colorAccentOrange
                        ),
                    ])

                    Spacer().frame(height: 24)

                    // ── Data & Storage ───────────────────────────────
                    SettingsSectionTitle(title: "Data & Storage")
                    Spacer().frame(height: 8)
                    SettingsMenuGroup(items: [
                        SettingsItem(
                            icon: "trash", title: "Clear Cache",
                            subtitle: "Free up storage space",
                            color: colorErrorRed
                        ),
                        SettingsItem(
                            icon: "arrow.triangle.2.circlepath", title: "Sync Data",
                            subtitle: "Last synced: Today, 10:30 AM",
                            color: colorSecondaryGreen
                        ),
                    ])

                    Spacer().frame(height: 24)

                    // Version footer
                    Text("MahfilHub v1.0.0 (Build 2026.04.01)")
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
// MARK: - Settings Header
// ══════════════════════════════════════════════════════════════════════════

private struct SettingsHeader: View {
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
                    Text("Settings")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Customize your experience")
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                Spacer().frame(height: 16)

                // Chip
                HStack(spacing: 8) {
                    SettingsHeaderChip(icon: "gearshape.fill", label: "App Settings")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                Spacer().frame(height: 16)
            }
        }
        .frame(height: 200)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Header Chip
// ══════════════════════════════════════════════════════════════════════════

private struct SettingsHeaderChip: View {
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
// MARK: - Section Title
// ══════════════════════════════════════════════════════════════════════════

private struct SettingsSectionTitle: View {
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
// MARK: - Settings Item Model
// ══════════════════════════════════════════════════════════════════════════

private struct SettingsItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var action: (() -> Void)? = nil
    var hasToggle: Bool = false
    var isToggled: Binding<Bool>? = nil
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Settings Menu Group
// ══════════════════════════════════════════════════════════════════════════

private struct SettingsMenuGroup: View {
    let items: [SettingsItem]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                SettingsMenuRow(item: item)

                if index < items.count - 1 {
                    Divider()
                        .padding(.leading, 68)
                        .padding(.trailing, 16)
                }
            }
        }
        .background(Color.appCardSurface)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.04), radius: 1, x: 0, y: 1)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Settings Menu Row
// ══════════════════════════════════════════════════════════════════════════

private struct SettingsMenuRow: View {
    let item: SettingsItem

    var body: some View {
        Button(action: {
            if !item.hasToggle {
                item.action?()
            }
        }) {
            HStack(spacing: 16) {
                // Icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(item.color.opacity(0.1))
                        .frame(width: 40, height: 40)

                    Image(systemName: item.icon)
                        .font(.body)
                        .foregroundStyle(item.color)
                }

                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.subheadline)
                        .foregroundStyle(colorTextPrimary)
                    Text(item.subtitle)
                        .font(.caption)
                        .foregroundStyle(colorTextSecondary)
                }

                Spacer()

                // Toggle or chevron
                if item.hasToggle, let binding = item.isToggled {
                    Toggle("", isOn: binding)
                        .labelsHidden()
                        .tint(colorPrimaryTeal)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(colorTextSecondary.opacity(0.5))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
        .disabled(item.hasToggle)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Previews
// ══════════════════════════════════════════════════════════════════════════

#Preview("Light") {
    SettingsView()
}

#Preview("Dark") {
    SettingsView()
        .preferredColorScheme(.dark)
}
