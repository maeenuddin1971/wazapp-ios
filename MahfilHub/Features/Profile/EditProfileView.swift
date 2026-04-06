import SwiftUI

// MARK: - Scroll Offset Key

private struct EditProfileScrollKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// ══════════════════════════════════════════════════════════════════════════
// MARK: - EditProfileView — Collapsing Header
// ══════════════════════════════════════════════════════════════════════════

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    // Form state
    @State private var fullName = SessionManager.shared.userName
    @State private var email = SessionManager.shared.userEmail
    @State private var phone = "+880 1712-345678"
    @State private var location = "Dhaka, Bangladesh"
    @State private var bio = "A passionate follower of Islamic knowledge. Love attending mahfils and connecting with scholars."

    @State private var emailNotifications = true
    @State private var locationServices = true
    @State private var publicProfile = false
    @State private var isSaving = false

    // Scroll tracking
    @State private var scrollOffset: CGFloat = 0

    private let expandedHeight: CGFloat = 260
    private let collapsedHeight: CGFloat = 100

    /// 0 = expanded, 1 = collapsed
    private var collapseProgress: CGFloat {
        let maxScroll = expandedHeight - collapsedHeight
        guard maxScroll > 0 else { return 0 }
        return min(max(-scrollOffset / maxScroll, 0), 1)
    }

    private var currentHeaderHeight: CGFloat {
        return max(expandedHeight + min(scrollOffset, 0), collapsedHeight)
    }

    var body: some View {
        ZStack(alignment: .top) {
            colorBackgroundCream.ignoresSafeArea()

            // ── Scrollable Form ───────────────────────────────────────
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header spacer — drives collapse
                    Color.clear
                        .frame(height: expandedHeight + 8)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: EditProfileScrollKey.self,
                                    value: geo.frame(in: .named("editProfileScroll")).origin.y
                                )
                            }
                        )

                    VStack(spacing: 0) {
                        // ── Personal Information ──────────────────────
                        SectionLabel(text: "Personal Information")

                        EditField(
                            value: $fullName,
                            label: "Full Name",
                            icon: "person",
                            iconColor: colorPrimaryTeal
                        )
                        EditField(
                            value: $email,
                            label: "Email Address",
                            icon: "envelope",
                            iconColor: colorInfoBlue
                        )
                        EditField(
                            value: $phone,
                            label: "Phone Number",
                            icon: "phone",
                            iconColor: colorSecondaryGreen
                        )
                        EditField(
                            value: $location,
                            label: "Location",
                            icon: "mappin.and.ellipse",
                            iconColor: colorAccentOrange
                        )

                        Spacer().frame(height: 24)

                        // ── About Me ─────────────────────────────────
                        SectionLabel(text: "About Me")

                        EditField(
                            value: $bio,
                            label: "Bio",
                            icon: "info.circle",
                            iconColor: colorPrimaryTealDark,
                            axis: .vertical
                        )

                        Spacer().frame(height: 24)

                        // ── Preferences ──────────────────────────────
                        SectionLabel(text: "Preferences")

                        PreferenceToggle(
                            icon: "bell",
                            title: "Email Notifications",
                            subtitle: "Receive event updates via email",
                            color: colorAccentOrange,
                            isOn: $emailNotifications
                        )
                        PreferenceToggle(
                            icon: "location",
                            title: "Location Services",
                            subtitle: "Show nearby events & mosques",
                            color: colorSecondaryGreen,
                            isOn: $locationServices
                        )
                        PreferenceToggle(
                            icon: "eye",
                            title: "Public Profile",
                            subtitle: "Let others see your profile",
                            color: colorInfoBlue,
                            isOn: $publicProfile
                        )

                        Spacer().frame(height: 32)

                        // ── Save Button ──────────────────────────────
                        Button(action: {
                            isSaving = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isSaving = false
                                dismiss()
                            }
                        }) {
                            HStack(spacing: 8) {
                                if isSaving {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.8)
                                }
                                Text(isSaving ? "Saving…" : "Save Changes")
                                    .font(.subheadline.bold())
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(colorPrimaryTeal)
                            .clipShape(.rect(cornerRadius: 14))
                        }
                        .disabled(isSaving)

                        Spacer().frame(height: 12)

                        // ── Delete Account ───────────────────────────
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Image(systemName: "trash")
                                    .font(.subheadline)
                                Text("Delete Account")
                                    .font(.subheadline.weight(.semibold))
                            }
                            .foregroundStyle(colorErrorRed)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
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
            .coordinateSpace(name: "editProfileScroll")
            .onPreferenceChange(EditProfileScrollKey.self) { value in
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
            // Gradient background
            LinearGradient(
                colors: [colorPrimaryTeal, colorPrimaryTealDark],
                startPoint: .top,
                endPoint: .bottom
            )

            // Decorative circles
            Canvas { ctx, size in
                let fade = 1 - collapseProgress
                ctx.fill(Circle().path(in: CGRect(x: size.width * 0.75, y: size.height * 0.05, width: 260, height: 260)),
                         with: .color(Color.white.opacity(0.06 * fade)))
                ctx.fill(Circle().path(in: CGRect(x: -60, y: size.height * 0.65, width: 180, height: 180)),
                         with: .color(Color.white.opacity(0.04 * fade)))
                ctx.fill(Circle().path(in: CGRect(x: size.width * 0.4, y: -40, width: 120, height: 120)),
                         with: .color(Color.white.opacity(0.03 * fade)))
            }
            .allowsHitTesting(false)

            // ── Back button (always visible) ──────────────────────────
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
            Text("Edit Profile")
                .font(.system(size: lerp(22, 18, collapseProgress), weight: .bold))
                .foregroundStyle(.white)
                .padding(.leading, lerp(16, 56, collapseProgress))
                .padding(.top, lerp(topSafeAreaInset + 80, topSafeAreaInset + 12, collapseProgress))

            // ── Avatar (fades out) ────────────────────────────────────
            VStack {
                Spacer()
                HStack {
                    Spacer()
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
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.black.opacity(0.15), radius: 4, y: 2)

                            Text(String(fullName.prefix(1)))
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        }

                        // Camera badge
                        ZStack {
                            Circle()
                                .fill(colorAccentOrange)
                                .frame(width: 26, height: 26)
                                .shadow(color: Color.black.opacity(0.2), radius: 2, y: 1)

                            Image(systemName: "pencil")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                        }
                        .offset(x: -2, y: -2)
                    }
                    Spacer()
                }
                Spacer().frame(height: 16)
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

private struct SectionLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.footnote.bold())
            .foregroundStyle(colorTextSecondary)
            .tracking(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 8)
    }
}

private struct EditField: View {
    @Binding var value: String
    let label: String
    let icon: String
    let iconColor: Color
    var axis: Axis = .horizontal

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(iconColor)
            }
            .padding(.top, 10)

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(colorTextSecondary)

                if axis == .vertical {
                    TextEditor(text: $value)
                        .font(.subheadline)
                        .foregroundStyle(colorTextPrimary)
                        .frame(minHeight: 80)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, -4)
                } else {
                    TextField(label, text: $value)
                        .font(.subheadline)
                        .foregroundStyle(colorTextPrimary)
                }
            }
        }
        .padding(12)
        .background(Color.appCardSurface)
        .clipShape(.rect(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.03), radius: 2, y: 1)
        .padding(.bottom, 8)
    }
}

private struct PreferenceToggle: View {
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
                .tint(colorPrimaryTeal)
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
        EditProfileView()
    }
}

#Preview("Dark") {
    NavigationStack {
        EditProfileView()
    }
    .preferredColorScheme(.dark)
}
