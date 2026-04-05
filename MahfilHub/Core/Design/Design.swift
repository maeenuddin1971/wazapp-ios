import SwiftUI

// ══════════════════════════════════════════════════════════════════════════
// MARK: - Design Constants
// Consolidated color aliases for the entire app.
// All backed by the Asset Catalog via Color extensions.
// ══════════════════════════════════════════════════════════════════════════

// MARK: - App Design Token Namespace
enum AppDesign {
    // MARK: Primary
    static let primaryTeal      = Color.appPrimaryTeal
    static let primaryTealLight = Color.appPrimaryTealLight
    static let primaryTealDark  = Color.appPrimaryTealDark
    static let deepTeal         = Color.appDeepTeal

    // MARK: Accent & Status
    static let accentOrange     = Color.appAccentOrange
    static let secondaryGreen   = Color.appSecondaryGreen
    static let infoBlue         = Color.appInfoBlue
    static let successGreen     = Color.appSuccessGreen
    static let errorRed         = Color.appErrorRed
    static let verifiedBadge    = Color.appVerifiedBadge

    // MARK: Neutrals
    static let white            = Color.white
    static let backgroundCream  = Color.appBackgroundCream
    static let textPrimary      = Color.appTextPrimary
    static let textSecondary    = Color.appTextSecondary
}

// MARK: - Legacy global aliases (migrate to AppDesign.xxx over time)
let colorPrimaryTeal      = AppDesign.primaryTeal
let colorPrimaryTealLight = AppDesign.primaryTealLight
let colorPrimaryTealDark  = AppDesign.primaryTealDark
let colorDeepTeal         = AppDesign.deepTeal

let colorAccentOrange     = AppDesign.accentOrange
let colorSecondaryGreen   = AppDesign.secondaryGreen
let colorInfoBlue         = AppDesign.infoBlue
let colorSuccessGreen     = AppDesign.successGreen
let colorErrorRed         = AppDesign.errorRed
let colorVerifiedBadge    = AppDesign.verifiedBadge

let colorWhite            = AppDesign.white
let colorBackgroundCream  = AppDesign.backgroundCream
let colorTextPrimary      = AppDesign.textPrimary
let colorTextSecondary    = AppDesign.textSecondary
