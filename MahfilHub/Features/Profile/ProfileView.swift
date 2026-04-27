import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - ProfileView
// ══════════════════════════════════════════════════════════════════════════

struct ProfileView: View {
    var onNotificationsTap: (() -> Void)? = nil
    var onEditProfileTap: (() -> Void)? = nil
    var onPrivacySecurityTap: (() -> Void)? = nil
    var onSavedEventsTap: (() -> Void)? = nil
    var onFollowingTap: (() -> Void)? = nil
    var onMyRemindersTap: (() -> Void)? = nil
    var onEventHistoryTap: (() -> Void)? = nil
    var onAboutTap: (() -> Void)? = nil
    var onSettingsTap: (() -> Void)? = nil
    var onHelpFeedbackTap: (() -> Void)? = nil

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                // ── Header ─────────────────────────────────────
                ProfileHeader(onSettingsTap: onSettingsTap)

                // ── Stats Row ──────────────────────────────────
                ProfileStatsRow()

                // ── Account Section ────────────────────────────
                ProfileSectionTitle(title: "Account")
                ProfileMenuGroup(items: [
                    ProfileMenuItemModel(
                        icon: "person", title: "Edit Profile",
                        subtitle: "Update your information",
                        color: colorPrimaryTeal,
                        action: onEditProfileTap
                    ),
                    ProfileMenuItemModel(
                        icon: "bell", title: "Notifications",
                        subtitle: "Manage notification preferences",
                        color: colorAccentOrange,
                        action: onNotificationsTap
                    ),
                    ProfileMenuItemModel(
                        icon: "lock", title: "Privacy & Security",
                        subtitle: "Password, account security",
                        color: colorInfoBlue,
                        action: onPrivacySecurityTap
                    )
                ])

                // ── Activity Section ───────────────────────────
                ProfileSectionTitle(title: "My Activity")
                ProfileMenuGroup(items: [
                    ProfileMenuItemModel(
                        icon: "heart", title: "Saved Events",
                        subtitle: "12 events saved",
                        color: colorErrorRed, badge: "12",
                        action: onSavedEventsTap
                    ),
                    ProfileMenuItemModel(
                        icon: "person.2", title: "Following",
                        subtitle: "8 scholars followed",
                        color: colorPrimaryTeal, badge: "8",
                        action: onFollowingTap
                    ),
                    ProfileMenuItemModel(
                        icon: "calendar", title: "My Reminders",
                        subtitle: "3 upcoming reminders",
                        color: colorSecondaryGreen, badge: "3",
                        action: onMyRemindersTap
                    ),
                    ProfileMenuItemModel(
                        icon: "star.fill", title: "Event History",
                        subtitle: "Events you attended",
                        color: colorAccentOrange,
                        action: onEventHistoryTap
                    )
                ])

                // ── Preferences Section ────────────────────────
                ProfileSectionTitle(title: "Preferences")
                ProfileMenuGroup(items: [
                    ProfileMenuItemModel(
                        icon: "globe", title: "Language",
                        subtitle: "English",
                        color: colorVerifiedBadge
                    ),
                    ProfileMenuItemModel(
                        icon: "paintbrush", title: "Theme",
                        subtitle: "System default",
                        color: colorPrimaryTealDark
                    ),
                    ProfileMenuItemModel(
                        icon: "mappin", title: "Location",
                        subtitle: "Dhaka, Bangladesh",
                        color: colorSecondaryGreen
                    )
                ])

                // ── Support Section ────────────────────────────
                ProfileSectionTitle(title: "Support")
                ProfileMenuGroup(items: [
                    ProfileMenuItemModel(
                        icon: "info.circle", title: "About",
                        subtitle: "About MahfilHub v1.0",
                        color: colorPrimaryTeal,
                        action: onAboutTap
                    ),
                    ProfileMenuItemModel(
                        icon: "envelope", title: "Help & Feedback",
                        subtitle: "Contact us, report issues",
                        color: colorInfoBlue,
                        action: onHelpFeedbackTap
                    ),
                    ProfileMenuItemModel(
                        icon: "square.and.arrow.up", title: "Share App",
                        subtitle: "Invite friends to MahfilHub",
                        color: colorAccentOrange
                    )
                ])

                // ── Logout Button ──────────────────────────────
                ProfileLogoutButton()

                // ── Version ────────────────────────────────────
                Text("MahfilHub v1.0.0")
                    .font(.caption)
                    .foregroundStyle(colorTextSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
        }
        .scrollIndicators(.hidden)
        .background(colorBackgroundCream)
        .ignoresSafeArea(.container, edges: .top)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Profile Header
// ══════════════════════════════════════════════════════════════════════════

private struct ProfileHeader: View {
    var onSettingsTap: (() -> Void)? = nil

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
                        y: size.height * 0.2 - 130,
                        width: 260, height: 260
                    )),
                    with: .color(Color.white.opacity(0.06))
                )
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.15 - 90,
                        y: size.height * 0.8 - 90,
                        width: 180, height: 180
                    )),
                    with: .color(Color.white.opacity(0.04))
                )
                ctx.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.5 - 60,
                        y: size.height * 0.05 - 60,
                        width: 120, height: 120
                    )),
                    with: .color(Color.white.opacity(0.03))
                )
            }

            VStack(spacing: 0) {
                Spacer().frame(height: 52) // Matches status bar height under .ignoresSafeArea

                // Title row with settings
                HStack {
                    Text("Profile")
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    Spacer()

                    Button("Settings", systemImage: "gearshape", action: { onSettingsTap?() })
                        .labelStyle(.iconOnly)
                        .font(.callout)
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.white.opacity(0.15)))
                        .accessibilityLabel("Settings")
                }
                .padding(.horizontal, 16)

                Spacer().frame(height: 24)

                // Avatar with edit badge
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [colorPrimaryTealLight, colorPrimaryTeal],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 96, height: 96)
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)

                        Text("A")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                    }

                    // Camera edit badge
                    ZStack {
                        Circle()
                            .fill(colorAccentOrange)
                            .frame(width: 28, height: 28)
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)

                        Image(systemName: "pencil")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                    }
                    .offset(x: -2, y: -2)
                }

                Spacer().frame(height: 16)

                // Name
                Text(SessionManager.shared.userName)
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Spacer().frame(height: 4)

                // Email
                Text(SessionManager.shared.userEmail)
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.7))

                Spacer().frame(height: 8)

                // Member badge
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(colorAccentOrange)
                    Text("Premium Member")
                        .font(.caption.bold())
                        .foregroundStyle(colorAccentOrange)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(colorAccentOrange.opacity(0.2))
                .clipShape(.rect(cornerRadius: 16))

                Spacer().frame(height: 20)
            }
        }
        .frame(minHeight: 360)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Stats Row
// ══════════════════════════════════════════════════════════════════════════

private struct ProfileStatsRow: View {
    var body: some View {
        HStack(spacing: 16) {
            ProfileStatCard(value: "24", label: "Attended", icon: "checkmark", color: colorSuccessGreen)
            ProfileStatCard(value: "12", label: "Saved", icon: "heart.fill", color: colorErrorRed)
            ProfileStatCard(value: "8", label: "Following", icon: "person.fill", color: colorInfoBlue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

private struct ProfileStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(color)
            }
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(colorTextPrimary)
            Text(label)
                .font(.caption)
                .foregroundStyle(colorTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.appCardSurface)
        .clipShape(.rect(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 1)
    }
}

// TODO: #11 — Stats and "Premium Member" badge are currently hardcoded.
// Wire to SessionManager or a ProfileViewModel when user profile API is available.
// ══════════════════════════════════════════════════════════════════════════
// MARK: - Section Title
// ══════════════════════════════════════════════════════════════════════════

private struct ProfileSectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.footnote.bold())
            .foregroundStyle(colorTextSecondary)
            .tracking(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Menu Group
// ══════════════════════════════════════════════════════════════════════════

private struct ProfileMenuItemModel: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var badge: String? = nil
    var action: (() -> Void)? = nil
}

private struct ProfileMenuGroup: View {
    let items: [ProfileMenuItemModel]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                ProfileMenuRow(item: item)
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
        .padding(.horizontal, 16)
    }
}

private struct ProfileMenuRow: View {
    let item: ProfileMenuItemModel

    var body: some View {
        Button(action: { item.action?() }) {
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

                // Badge
                if let badge = item.badge {
                    Text(badge)
                        .font(.caption.bold())
                        .foregroundStyle(item.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(item.color.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 10))
                }

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(colorTextSecondary.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .accessibilityElement(children: .combine)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Logout Button
// ══════════════════════════════════════════════════════════════════════════

private struct ProfileLogoutButton: View {
    var body: some View {
        Button("Logout", systemImage: "rectangle.portrait.and.arrow.right", action: {})
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .foregroundStyle(colorErrorRed)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorErrorRed.opacity(0.5), lineWidth: 1.5)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Previews
// ══════════════════════════════════════════════════════════════════════════

#Preview("Light") {
    ProfileView()
}

#Preview("Dark") {
    ProfileView()
        .preferredColorScheme(.dark)
}
