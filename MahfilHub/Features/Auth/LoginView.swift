import SwiftUI

// MARK: - Islamic Auth Colors (Asset Catalog backed)
private let islamicDark1      = Color.appIslamicDark1
private let islamicDark2      = Color.appIslamicDark2
private let islamicDark3      = Color.appIslamicDark3
private let islamicGold       = Color.appIslamicGold
private let islamicGoldLight  = Color.appIslamicGoldLight
private let islamicGoldMuted  = Color.appIslamicGoldMuted
private let glassBorder       = Color.appGlassBorder
private let glassBackground   = Color.appGlassBackground
private let inputBackground   = Color.appInputBackground
private let inputBorder       = Color.appInputBorder
private let inputBorderFocus  = Color.appInputBorderFocus
private let subtleText        = Color.appSubtleText
private let mutedText         = Color.appMutedText

// MARK: - LoginView
struct LoginView: View {
    @Binding var currentScreen: AppScreen
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var showPasswordReset = false

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                Spacer().frame(height: 50)

                // ── Crescent Moon + Star ─────────────────────────
                CrescentMoonView(size: 80)

                Spacer().frame(height: 12)

                // ── Bismillah ────────────────────────────────────
                Text("بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ")
                    .font(.title3)
                    .foregroundStyle(islamicGold)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 24)

                Text("Assalamu Alaikum")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                Spacer().frame(height: 4)

                Text("Sign in to discover Islamic events near you")
                    .font(.subheadline)
                    .foregroundStyle(subtleText)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 36)

                // ── Email Field ──────────────────────────────────
                IslamicTextField(
                    label: "Email Address",
                    placeholder: "Enter your email",
                    icon: "envelope",
                    text: $email
                )

                Spacer().frame(height: 16)

                // ── Password Field ───────────────────────────────
                IslamicPasswordField(
                    label: "Password",
                    placeholder: "Enter password",
                    text: $password,
                    isSecure: $isSecure
                )

                // Forgot Password
                HStack {
                    Spacer()
                    Button("Forgot password?") {
                        showPasswordReset = true
                    }
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(islamicGoldLight)
                }
                .padding(.top, 8)

                Spacer().frame(height: 28)

                // ── Login Button ─────────────────────────────────
                Button(action: performLogin) {
                    ZStack {
                        LinearGradient(
                            colors: [colorPrimaryTeal, colorPrimaryTealLight],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(.rect(cornerRadius: 14))

                        Text("Sign In")
                            .font(.callout.bold())
                            .foregroundStyle(.white)
                            .tracking(0.5)
                    }
                    .frame(height: 54)
                    .contentShape(Rectangle())
                }

                Spacer().frame(height: 28)

                // ── OR Divider with Islamic star ─────────────────
                IslamicDivider()

                Spacer().frame(height: 28)

                // ── Social Login ─────────────────────────────────
                HStack(spacing: 14) {
                    SocialGlassButton(title: "Google", iconName: "g.circle.fill", iconColor: .appGoogleRed)
                    SocialGlassButton(title: "Facebook", iconName: "person.crop.square.fill", iconColor: .appFacebookBlue)
                }

                Spacer().frame(height: 14)

                // Guest Mode
                Button {
                    print("Guest mode tapped! Setting currentScreen = .main")
                    SessionManager.shared.login(name: "Guest User", email: "guest@mahfilhub.com")
                    withAnimation(.easeInOut(duration: 0.35)) {
                        currentScreen = .main
                    }
                } label: {
                    Text("Continue as Guest")
                        .font(.subheadline)
                        .foregroundStyle(mutedText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .contentShape(Rectangle())
                }

                Spacer().frame(height: 20)

                // ── Sign Up Link ─────────────────────────────────
                Button {
                    print("Register clicked! Setting currentScreen = .register")
                    withAnimation(.easeInOut(duration: 0.35)) {
                        currentScreen = .register
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.subheadline)
                            .foregroundStyle(subtleText)
                        Text("Register")
                            .font(.subheadline.bold())
                            .foregroundStyle(islamicGoldLight)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .contentShape(Rectangle())
                }
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 28)
        }
        .scrollIndicators(.hidden)
        .background(
            ZStack {
                LinearGradient(
                    colors: [islamicDark1, islamicDark2, islamicDark3],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                IslamicBackgroundCanvas()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        )
        .sheet(isPresented: $showPasswordReset) {
            PasswordResetSheet()
        }
    }

    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty
    }

    private func performLogin() {
        SessionManager.shared.login(name: "Bipul Ahmed", email: "bipul@mahfilhub.com")
        withAnimation(.easeInOut(duration: 0.35)) {
            currentScreen = .main
        }
    }
}

// MARK: - Reusable Islamic Components

/// Glassmorphic text field with label
private struct IslamicTextField: View {
    let label: String
    let placeholder: String
    let icon: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(subtleText)
                .padding(.leading, 4)

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(islamicGold)
                    .font(.callout)
                    .frame(width: 20)
                TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(mutedText))
                    .foregroundStyle(.white)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding(14)
            .background(inputBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(inputBorder, lineWidth: 1)
            )
        }
    }
}

/// Glassmorphic password field with visibility toggle
private struct IslamicPasswordField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    @Binding var isSecure: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(subtleText)
                .padding(.leading, 4)

            HStack(spacing: 10) {
                Image(systemName: "lock")
                    .foregroundStyle(islamicGold)
                    .font(.callout)
                    .frame(width: 20)
                Group {
                    if isSecure {
                        SecureField("", text: $text, prompt: Text(placeholder).foregroundStyle(mutedText))
                    } else {
                        TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(mutedText))
                    }
                }
                .foregroundStyle(.white)

                Button(isSecure ? "Show Password" : "Hide Password",
                       systemImage: isSecure ? "eye.slash" : "eye",
                       action: { isSecure.toggle() })
                    .labelStyle(.iconOnly)
                    .foregroundStyle(mutedText)
                    .font(.subheadline)
            }
            .padding(14)
            .background(inputBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(inputBorder, lineWidth: 1)
            )
        }
    }
}

/// Social login glass button
private struct SocialGlassButton: View {
    let title: String
    let iconName: String
    let iconColor: Color

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.body)
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(glassBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(glassBorder, lineWidth: 1)
            )
        }
    }
}

/// Islamic star as OR divider
struct IslamicDivider: View {
    var body: some View {
        HStack {
            Rectangle()
                .fill(islamicGoldMuted)
                .frame(height: 1)
            IslamicStarShape(points: 5, innerRatio: 0.45)
                .fill(islamicGold.opacity(0.5))
                .frame(width: 22, height: 22)
                .padding(.horizontal, 10)
            Rectangle()
                .fill(islamicGoldMuted)
                .frame(height: 1)
        }
    }
}

/// Crescent Moon + Star icon drawn with SwiftUI shapes
struct CrescentMoonView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            // Outer moon circle
            Circle()
                .fill(islamicGold)
                .frame(width: size * 0.76, height: size * 0.76)

            // Inner cut-out circle
            Circle()
                .fill(islamicDark1)
                .frame(width: size * 0.76 * 0.78, height: size * 0.76 * 0.78)
                .offset(x: size * 0.76 * 0.35 / 2, y: -size * 0.76 * 0.1 / 2)

            // Star
            IslamicStarShape(points: 5, innerRatio: 0.45)
                .fill(islamicGold)
                .frame(width: size * 0.15, height: size * 0.15)
                .offset(x: size * 0.06, y: -size * 0.02)
        }
        .frame(width: size, height: size)
    }
}

/// Reusable 5-pointed star shape
struct IslamicStarShape: Shape {
    let points: Int
    let innerRatio: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * innerRatio
        let angleOffset = -CGFloat.pi / 2

        for i in 0..<(points * 2) {
            let r = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = angleOffset + CGFloat(i) * .pi / CGFloat(points)
            let pt = CGPoint(x: center.x + r * cos(angle), y: center.y + r * sin(angle))
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}

/// Full-screen decorative Islamic background canvas
struct IslamicBackgroundCanvas: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            Canvas { ctx, size in
                // Golden glow top-right
                let topRight = CGPoint(x: w * 0.85, y: h * 0.06)
                ctx.fill(
                    Circle().path(in: CGRect(x: topRight.x - 140, y: topRight.y - 140, width: 280, height: 280)),
                    with: .radialGradient(
                        Gradient(colors: [islamicGold.opacity(0.07), .clear]),
                        center: topRight, startRadius: 0, endRadius: 140
                    )
                )

                // Teal glow left
                let leftGlow = CGPoint(x: w * 0.08, y: h * 0.4)
                ctx.fill(
                    Circle().path(in: CGRect(x: leftGlow.x - 110, y: leftGlow.y - 110, width: 220, height: 220)),
                    with: .radialGradient(
                        Gradient(colors: [colorPrimaryTeal.opacity(0.08), .clear]),
                        center: leftGlow, startRadius: 0, endRadius: 110
                    )
                )

                // Gold glow bottom
                let bottomGlow = CGPoint(x: w * 0.6, y: h * 0.9)
                ctx.fill(
                    Circle().path(in: CGRect(x: bottomGlow.x - 100, y: bottomGlow.y - 100, width: 200, height: 200)),
                    with: .radialGradient(
                        Gradient(colors: [islamicGold.opacity(0.05), .clear]),
                        center: bottomGlow, startRadius: 0, endRadius: 100
                    )
                )

                // Mosque silhouette
                let mosqueColor = Color.white.opacity(0.03)
                let mosqueY = h * 0.88

                // Central dome
                var dome = Path()
                dome.move(to: CGPoint(x: w * 0.3, y: mosqueY))
                dome.addQuadCurve(to: CGPoint(x: w * 0.7, y: mosqueY), control: CGPoint(x: w * 0.5, y: mosqueY - 80))
                dome.addLine(to: CGPoint(x: w * 0.7, y: h))
                dome.addLine(to: CGPoint(x: w * 0.3, y: h))
                dome.closeSubpath()
                ctx.fill(dome, with: .color(mosqueColor))

                // Left minaret
                var mL = Path()
                mL.move(to: CGPoint(x: w * 0.18, y: mosqueY + 10))
                mL.addLine(to: CGPoint(x: w * 0.18, y: mosqueY - 50))
                mL.addQuadCurve(to: CGPoint(x: w * 0.22, y: mosqueY - 50), control: CGPoint(x: w * 0.20, y: mosqueY - 70))
                mL.addLine(to: CGPoint(x: w * 0.22, y: h))
                mL.addLine(to: CGPoint(x: w * 0.18, y: h))
                mL.closeSubpath()
                ctx.fill(mL, with: .color(mosqueColor))

                // Right minaret
                var mR = Path()
                mR.move(to: CGPoint(x: w * 0.78, y: mosqueY + 10))
                mR.addLine(to: CGPoint(x: w * 0.78, y: mosqueY - 50))
                mR.addQuadCurve(to: CGPoint(x: w * 0.82, y: mosqueY - 50), control: CGPoint(x: w * 0.80, y: mosqueY - 70))
                mR.addLine(to: CGPoint(x: w * 0.82, y: h))
                mR.addLine(to: CGPoint(x: w * 0.78, y: h))
                mR.closeSubpath()
                ctx.fill(mR, with: .color(mosqueColor))

                // Tiny crescent on dome
                ctx.fill(
                    Circle().path(in: CGRect(x: w * 0.5 - 5, y: mosqueY - 90, width: 10, height: 10)),
                    with: .color(islamicGold.opacity(0.06))
                )
            }
        }
    }
}

// MARK: - Password Reset Sheet
private struct PasswordResetSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [islamicDark1, islamicDark2],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Enter your email to reset your password.")
                        .font(.subheadline)
                        .foregroundStyle(subtleText)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    IslamicTextField(
                        label: "Email",
                        placeholder: "you@example.com",
                        icon: "envelope",
                        text: $email
                    )

                    Button("Send Reset Link") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [colorPrimaryTeal, colorPrimaryTealLight],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 14))

                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(islamicGoldLight)
                }
            }
        }
    }
}

#Preview {
    LoginView(currentScreen: .constant(.login))
}
