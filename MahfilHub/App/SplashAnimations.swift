import SwiftUI

enum SplashAnimations {
    static let splashDisplayDuration: TimeInterval = 3.0 // Matches Android's 3000ms

    // --- Entrance Animations ---

    // Logo scale entrance: 0.3 -> 1.0, bouncy spring
    static var logoScaleAnimation: Animation {
        return .spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0)
    }

    // Logo alpha entrance: 0 -> 1.0, tween 800ms
    static var logoAlphaAnimation: Animation {
        return .easeInOut(duration: 0.8)
    }

    // Branding alpha entrance: 0 -> 1.0, wait 400ms then tween 600ms
    static var brandingAlphaAnimation: Animation {
        return .easeInOut(duration: 0.6).delay(0.4)
    }

    // Branding slide entrance: 30 -> 0, wait 200ms then easeOut 800ms
    static var brandingSlideAnimation: Animation {
        return .easeOut(duration: 0.8).delay(0.2)
    }

    // --- Continuous Animations ---

    // Glow pulse: 0.8 -> 1.2, infinite reversing, 1500ms
    static var glowPulseAnimation: Animation {
        return .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    }

    // Logo float: -8 -> 8, infinite reversing, 2000ms
    static var logoFloatAnimation: Animation {
        return .easeInOut(duration: 2.0).repeatForever(autoreverses: true)
    }
    
    // Background rotation: 0 -> 360, infinite linear, 80000ms
    static var bgRotationAnimation: Animation {
        return .linear(duration: 80.0).repeatForever(autoreverses: false)
    }
}
