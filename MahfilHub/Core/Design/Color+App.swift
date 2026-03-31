import SwiftUI
import UIKit

// MARK: - App Color Palette
// All colors are defined as Asset Catalog Color Sets with light/dark mode support.
// Access via Color.appXxx for SwiftUI or UIColor.appXxx for UIKit.

extension Color {
    // ── Brand / Primary ─────────────────────────────────────────────
    static let appPrimaryTeal      = Color("PrimaryTeal")
    static let appPrimaryTealDark  = Color("PrimaryTealDark")
    static let appPrimaryTealLight = Color("PrimaryTealLight")
    static let appDeepTeal         = Color("DeepTeal")
    static let appAccentOrange     = Color("AccentOrange")

    // ── Semantic ────────────────────────────────────────────────────
    static let appSuccessGreen     = Color("SuccessGreen")
    static let appErrorRed         = Color("ErrorRed")
    static let appInfoBlue         = Color("InfoBlue")
    static let appVerifiedBadge    = Color("VerifiedBadge")
    static let appSecondaryGreen   = Color("SecondaryGreen")

    // ── Islamic Auth Theme (always-dark screens) ────────────────────
    static let appIslamicDark1     = Color("IslamicDark1")
    static let appIslamicDark2     = Color("IslamicDark2")
    static let appIslamicDark3     = Color("IslamicDark3")
    static let appIslamicGold      = Color("IslamicGold")
    static let appIslamicGoldLight = Color("IslamicGoldLight")
    static let appIslamicGoldMuted = Color("IslamicGoldMuted")

    // ── Surface / Background ────────────────────────────────────────
    static let appBackgroundCream  = Color("BackgroundCream")
    static let appTextPrimary      = Color("TextPrimary")
    static let appTextSecondary    = Color("TextSecondary")

    // ── Glass Effects ───────────────────────────────────────────────
    static let appGlassBorder      = Color("GlassBorder")
    static let appGlassBackground  = Color("GlassBackground")
    static let appInputBackground  = Color("InputBackground")
    static let appInputBorder      = Color("InputBorder")
    static let appInputBorderFocus = Color("InputBorderFocus")
    static let appSubtleText       = Color("SubtleText")
    static let appMutedText        = Color("MutedText")

    // ── Splash ──────────────────────────────────────────────────────
    static let appSplashTeal       = Color("SplashTeal")

    // ── Social Brand ────────────────────────────────────────────────
    static let appGoogleRed        = Color("GoogleRed")
    static let appFacebookBlue     = Color("FacebookBlue")

    // ── Surface ─────────────────────────────────────────────────────
    static let appCardSurface      = Color("CardSurface")
}

extension UIColor {
    static let appSplashTeal = UIColor(named: "SplashTeal") ?? UIColor(red: 0, green: 137/255, blue: 123/255, alpha: 1)
}
