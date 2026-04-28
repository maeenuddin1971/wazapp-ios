import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Language Option Model
// ══════════════════════════════════════════════════════════════════════════

private struct LanguageOption: Identifiable {
    let id: String // language code
    let name: String
    let nativeName: String
}

private let languages: [LanguageOption] = [
    LanguageOption(id: "en", name: "English", nativeName: "English"),
    LanguageOption(id: "bn", name: "Bengali", nativeName: "বাংলা"),
    LanguageOption(id: "ar", name: "Arabic", nativeName: "العربية"),
    LanguageOption(id: "ur", name: "Urdu", nativeName: "اردو"),
    LanguageOption(id: "hi", name: "Hindi", nativeName: "हिन्दी"),
    LanguageOption(id: "ms", name: "Malay", nativeName: "Bahasa Melayu"),
    LanguageOption(id: "id", name: "Indonesian", nativeName: "Bahasa Indonesia"),
    LanguageOption(id: "tr", name: "Turkish", nativeName: "Türkçe"),
]

// ══════════════════════════════════════════════════════════════════════════
// MARK: - LanguageView
// ══════════════════════════════════════════════════════════════════════════

struct LanguageView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLang = "en"

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                // Header
                LanguageHeader(onBack: { dismiss() })

                // Content
                VStack(spacing: 0) {
                    Spacer().frame(height: 16)

                    Text("Select Language")
                        .font(.footnote.bold())
                        .foregroundStyle(colorTextSecondary)
                        .tracking(0.5)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer().frame(height: 8)

                    ForEach(languages) { lang in
                        LanguageRow(
                            language: lang,
                            isSelected: lang.id == selectedLang,
                            onTap: { selectedLang = lang.id }
                        )
                    }

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
// MARK: - Language Header
// ══════════════════════════════════════════════════════════════════════════

private struct LanguageHeader: View {
    var onBack: () -> Void = {}

    var body: some View {
        ZStack {
            // Gradient background (VerifiedBadge → deep blue, matching Android)
            LinearGradient(
                colors: [colorVerifiedBadge, Color(red: 0.05, green: 0.28, blue: 0.63)],
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
                    Text("Language")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Choose your preferred language")
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
// MARK: - Language Row
// ══════════════════════════════════════════════════════════════════════════

private struct LanguageRow: View {
    let language: LanguageOption
    let isSelected: Bool
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Language code badge
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? colorPrimaryTeal.opacity(0.1) : Color.gray.opacity(0.08))
                        .frame(width: 40, height: 40)

                    Text(language.id.uppercased())
                        .font(.caption.bold())
                        .foregroundStyle(isSelected ? colorPrimaryTeal : colorTextSecondary)
                }

                // Language names
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.name)
                        .font(.subheadline)
                        .foregroundStyle(colorTextPrimary)
                    Text(language.nativeName)
                        .font(.caption)
                        .foregroundStyle(colorTextSecondary)
                }

                Spacer()

                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.body.bold())
                        .foregroundStyle(colorPrimaryTeal)
                }
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
    LanguageView()
}

#Preview("Dark") {
    LanguageView()
        .preferredColorScheme(.dark)
}
