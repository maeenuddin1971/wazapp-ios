import SwiftUI

// MARK: - Islamic Auth Colors
private let islamicDark1  = Color(red: 0x08/255.0, green: 0x1C/255.0, blue: 0x15/255.0)
private let islamicDark2  = Color(red: 0x0B/255.0, green: 0x3D/255.0, blue: 0x2E/255.0)
private let islamicDark3  = Color(red: 0x05/255.0, green: 0x2E/255.0, blue: 0x22/255.0)
private let islamicGold     = Color(red: 0xD4/255.0, green: 0xA9/255.0, blue: 0x53/255.0)
private let islamicGoldLight = Color(red: 0xE8/255.0, green: 0xC9/255.0, blue: 0x75/255.0)
private let islamicGoldMuted = islamicGold.opacity(0.25)
private let glassBorder     = Color.white.opacity(0.16)
private let glassBackground = Color.white.opacity(0.08)
private let inputBackground = Color.white.opacity(0.11)
private let inputBorder     = Color.white.opacity(0.19)
private let inputBorderFocus = Color(red: 0x4D/255.0, green: 0xB6/255.0, blue: 0xAC/255.0)
private let subtleText      = Color.white.opacity(0.6)
private let mutedText       = Color.white.opacity(0.33)

// MARK: - LoginView
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var isLoggingIn = false
    @State private var showPasswordReset = false

    var onLoginSuccess: () -> Void = {}
    var onNavigateToRegister: () -> Void = {}
    var onGuestMode: () -> Void = {}

    var body: some View {
        ZStack {
            // ── Background gradient ─────────────────────────────────
            LinearGradient(
                colors: [islamicDark1, islamicDark2, islamicDark3],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // ── Decorative orbs + mosque ─────────────────────────────
            IslamicBackgroundCanvas()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 50)

                    // ── Crescent Moon + Star ─────────────────────────
                    CrescentMoonView(size: 80)

                    Spacer().frame(height: 12)

                    // ── Bismillah ────────────────────────────────────
                    Text("بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ")
                        .font(.system(size: 20))
                        .foregroundColor(islamicGold)
                        .multilineTextAlignment(.center)

                    Spacer().frame(height: 24)

                    Text("Assalamu Alaikum")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)

                    Spacer().frame(height: 4)

                    Text("Sign in to discover Islamic events near you")
                        .font(.system(size: 14))
                        .foregroundColor(subtleText)
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
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(islamicGoldLight)
                    }
                    .padding(.top, 8)

                    Spacer().frame(height: 28)

                    // ── Login Button ─────────────────────────────────
                    Button(action: { login() }) {
                        ZStack {
                            LinearGradient(
                                colors: [colorPrimaryTeal, colorPrimaryTealLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .cornerRadius(14)

                            if isLoggingIn {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                            } else {
                                Text("Sign In")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .tracking(0.5)
                            }
                        }
                        .frame(height: 54)
                    }
                    .disabled(!isFormValid || isLoggingIn)
                    .opacity(!isFormValid || isLoggingIn ? 0.6 : 1)

                    Spacer().frame(height: 28)

                    // ── OR Divider with Islamic star ─────────────────
                    IslamicDivider()

                    Spacer().frame(height: 28)

                    // ── Social Login ─────────────────────────────────
                    HStack(spacing: 14) {
                        SocialGlassButton(title: "Google", iconName: "g.circle.fill", iconColor: Color(red: 0xDB/255, green: 0x44/255, blue: 0x37/255))
                        SocialGlassButton(title: "Facebook", iconName: "person.crop.square.fill", iconColor: Color(red: 0x18/255, green: 0x77/255, blue: 0xF2/255))
                    }

                    Spacer().frame(height: 14)

                    // Guest Mode
                    Button(action: { onGuestMode() }) {
                        Text("Continue as Guest")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(mutedText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }

                    Spacer().frame(height: 20)

                    // ── Sign Up Link ─────────────────────────────────
                    Button(action: {
                        print("Register clicked!")
                        onNavigateToRegister()
                    }) {
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .font(.system(size: 14))
                                .foregroundColor(subtleText)
                            Text("Register")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(islamicGoldLight)
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 20)
                        .contentShape(Rectangle())
                    }
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 28)
            }
        }
        .sheet(isPresented: $showPasswordReset) {
            PasswordResetSheet()
        }
    }

    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty
    }

    private func login() {
        isLoggingIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoggingIn = false
            onLoginSuccess()
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
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(subtleText)
                .padding(.leading, 4)

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(islamicGold)
                    .font(.system(size: 16))
                    .frame(width: 20)
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(mutedText))
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(14)
            .background(inputBackground)
            .cornerRadius(14)
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
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(subtleText)
                .padding(.leading, 4)

            HStack(spacing: 10) {
                Image(systemName: "lock")
                    .foregroundColor(islamicGold)
                    .font(.system(size: 16))
                    .frame(width: 20)
                Group {
                    if isSecure {
                        SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(mutedText))
                    } else {
                        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(mutedText))
                    }
                }
                .foregroundColor(.white)

                Button(action: { isSecure.toggle() }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(mutedText)
                        .font(.system(size: 14))
                }
            }
            .padding(14)
            .background(inputBackground)
            .cornerRadius(14)
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
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(glassBackground)
            .cornerRadius(14)
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
                        .font(.system(size: 14))
                        .foregroundColor(subtleText)
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
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(
                            colors: [colorPrimaryTeal, colorPrimaryTealLight],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .cornerRadius(14)

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
                        .foregroundColor(islamicGoldLight)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
