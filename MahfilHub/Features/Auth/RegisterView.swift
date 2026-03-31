import SwiftUI

// MARK: - RegisterView  (Islamic Premium Design — matches Android)

struct RegisterView: View {
    @Binding var currentScreen: AppScreen
    @State private var name = ""
    @State private var emailOrPhone = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var agreeTerms = false

    // Color tokens (Asset Catalog backed)
    private let dark1    = Color.appIslamicDark1
    private let dark2    = Color.appIslamicDark2
    private let dark3    = Color.appIslamicDark3
    private let gold     = Color.appIslamicGold
    private let goldLight = Color.appIslamicGoldLight
    private let goldMuted = Color.appIslamicGoldMuted
    private let subtle   = Color.appSubtleText
    private let muted    = Color.appMutedText
    private let glassBg  = Color.appGlassBackground
    private let glassBdr = Color.appGlassBorder
    private let inpBg    = Color.appInputBackground
    private let inpBdr   = Color.appInputBorder

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                Spacer().frame(height: 36)

                // ── Crescent Moon + Star ─────────────────────────
                CrescentMoonView(size: 56)

                Spacer().frame(height: 8)

                // ── Bismillah ────────────────────────────────────
                Text("بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ")
                    .font(.body)
                    .foregroundStyle(gold)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 16)

                Text("Join the Ummah")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Spacer().frame(height: 4)

                Text("Create your account to explore Islamic events")
                    .font(.footnote)
                    .foregroundStyle(subtle)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 28)

                // ── Full Name ────────────────────────────────────
                regTextField(
                    label: "Full Name",
                    placeholder: "Enter your name",
                    icon: "person",
                    text: $name
                )

                Spacer().frame(height: 12)

                // ── Email or Phone ───────────────────────────────
                regTextField(
                    label: "Email or Phone Number",
                    placeholder: "Enter email or phone number",
                    icon: "envelope",
                    text: $emailOrPhone
                )

                Spacer().frame(height: 12)

                // ── Password ─────────────────────────────────────
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(subtle)
                        .padding(.leading, 4)

                    HStack(spacing: 10) {
                        Image(systemName: "lock")
                            .foregroundStyle(gold)
                            .font(.callout)
                            .frame(width: 20)
                        Group {
                            if isSecure {
                                SecureField("", text: $password, prompt: Text("Enter password").foregroundStyle(muted))
                            } else {
                                TextField("", text: $password, prompt: Text("Enter password").foregroundStyle(muted))
                            }
                        }
                        .foregroundStyle(.white)

                        Button(action: { isSecure.toggle() }) {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundStyle(muted)
                                .font(.subheadline)
                        }
                    }
                    .padding(14)
                    .background(inpBg)
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(inpBdr, lineWidth: 1)
                    )
                }

                Spacer().frame(height: 12)

                // ── Terms Checkbox ───────────────────────────────
                HStack(alignment: .center, spacing: 8) {
                    Button(action: { agreeTerms.toggle() }) {
                        Image(systemName: agreeTerms ? "checkmark.square.fill" : "square")
                            .foregroundStyle(agreeTerms ? colorPrimaryTealLight : muted)
                            .font(.title3)
                    }
                    Button(action: { agreeTerms.toggle() }) {
                        Text("I agree to the Terms of Service and Privacy Policy")
                            .font(.caption)
                            .foregroundStyle(subtle)
                            .lineSpacing(2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer().frame(height: 20)

                // ── Create Account Button ───────────────────────
                Button {
                    print("Create Account tapped! Setting currentScreen = .main")
                    SessionManager.shared.login(name: "New User", email: "newuser@mahfilhub.com")
                    withAnimation(.easeInOut(duration: 0.35)) {
                        currentScreen = .main
                    }
                } label: {
                    ZStack {
                        LinearGradient(
                            colors: agreeTerms
                                ? [colorPrimaryTeal, colorPrimaryTealLight]
                                : [colorPrimaryTeal.opacity(0.3), colorPrimaryTealLight.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(.rect(cornerRadius: 14))

                        Text("Create Account")
                            .font(.callout.bold())
                            .foregroundStyle(agreeTerms ? .white : Color.white.opacity(0.4))
                            .tracking(0.5)
                    }
                    .frame(height: 54)
                    .contentShape(Rectangle())
                }
                .disabled(!agreeTerms)

                Spacer().frame(height: 24)

                // ── OR Divider ───────────────────────────────────
                HStack {
                    Rectangle().fill(goldMuted).frame(height: 1)
                    IslamicStarShape(points: 5, innerRatio: 0.45)
                        .fill(gold.opacity(0.5))
                        .frame(width: 22, height: 22)
                        .padding(.horizontal, 10)
                    Rectangle().fill(goldMuted).frame(height: 1)
                }

                Spacer().frame(height: 24)

                // ── Google Sign-up ───────────────────────────────
                Button(action: {}) {
                    HStack(spacing: 10) {
                        Image(systemName: "g.circle.fill")
                            .font(.body)
                            .foregroundStyle(Color.appGoogleRed)
                        Text("Sign up with Google")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(glassBg)
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(glassBdr, lineWidth: 1)
                    )
                }

                Spacer().frame(height: 24)

                // ── Login Link ───────────────────────────────────
                Button {
                    print("Sign In clicked from Register! Setting currentScreen = .login")
                    withAnimation(.easeInOut(duration: 0.35)) {
                        currentScreen = .login
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundStyle(subtle)
                        Text("Sign In")
                            .font(.subheadline.bold())
                            .foregroundStyle(goldLight)
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
                    colors: [dark1, dark2, dark3],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                IslamicBackgroundCanvas()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        )
    }

    // MARK: - Helpers

    @ViewBuilder
    private func regTextField(
        label: String,
        placeholder: String,
        icon: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(subtle)
                .padding(.leading, 4)

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(gold)
                    .font(.callout)
                    .frame(width: 20)
                TextField("", text: text, prompt: Text(placeholder).foregroundStyle(muted))
                    .foregroundStyle(.white)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding(14)
            .background(inpBg)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(inpBdr, lineWidth: 1)
            )
        }
    }

}

#Preview {
    RegisterView(currentScreen: .constant(.register))
}
