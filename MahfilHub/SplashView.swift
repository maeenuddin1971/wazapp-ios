//
//  SplashView.swift
//  MahfilHub
//
//  Created by Antigravity — mirrors the Android splash screen design.
//
//  Design:
//    • Background : #00897B  (same as Android `splash_background`)
//    • Center icon: White mosque + orange (#FF9800) crescent & minaret tops
//    • Branding   : "Mahfil" in white + "Hub" in orange (#FF9800)
//    • Exit anim  : Explosive scale-burst (1 → 20) + simultaneous fade-out,
//                   matching the Android AccelerateInterpolator(2f) over 700 ms.
//

import SwiftUI

// MARK: - Brand Constants
private let splashBg   = Color(red: 0/255, green: 137/255, blue: 123/255)    // #00897B
private let brandWhite = Color.white
private let brandOrange = Color(red: 1.0,  green: 152/255, blue: 0/255)       // #FF9800

// MARK: - Mosque Icon (matches ic_splash_logo.xml paths)
struct MosqueIcon: View {
    var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let h = size.height

            // The Android vector viewport is 108×108 with a group scaled 0.8
            // and translated to centre (54, 54).  We replicate the same
            // normalised geometry here.
            let cx = w / 2
            let cy = h / 2
            let s  = min(w, h) / 108.0 * 0.8   // same 0.8 scale factor

            // Helper: translate & scale an Android path coordinate pair
            // (x, y are in Android's centred coordinate space)
            func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
                CGPoint(x: cx + x * s, y: cy + y * s)
            }

            // ── Central Dome ─────────────────────────────────────────────────
            // M0,-25 C-15,-25 -15,-15 -15,-10 L-15,5 L15,5 L15,-10 C15,-15 15,-25 0,-25 Z
            var dome = Path()
            dome.move(to: pt(0, -25))
            dome.addCurve(to: pt(-15, -10),
                          control1: pt(-15, -25),
                          control2: pt(-15, -15))
            dome.addLine(to: pt(-15, 5))
            dome.addLine(to: pt(15, 5))
            dome.addLine(to: pt(15, -10))
            dome.addCurve(to: pt(0, -25),
                          control1: pt(15, -15),
                          control2: pt(15, -25))
            dome.closeSubpath()
            ctx.fill(dome, with: .color(brandWhite))

            // ── Left Minaret ──────────────────────────────────────────────────
            // M-25,-20 L-25,15 L-20,15 L-20,-20 Z
            var leftMin = Path()
            leftMin.move(to: pt(-25, -20))
            leftMin.addLine(to: pt(-25, 15))
            leftMin.addLine(to: pt(-20, 15))
            leftMin.addLine(to: pt(-20, -20))
            leftMin.closeSubpath()
            ctx.fill(leftMin, with: .color(brandWhite))

            // ── Right Minaret ─────────────────────────────────────────────────
            // M20,-20 L20,15 L25,15 L25,-20 Z
            var rightMin = Path()
            rightMin.move(to: pt(20, -20))
            rightMin.addLine(to: pt(20, 15))
            rightMin.addLine(to: pt(25, 15))
            rightMin.addLine(to: pt(25, -20))
            rightMin.closeSubpath()
            ctx.fill(rightMin, with: .color(brandWhite))

            // ── Base ──────────────────────────────────────────────────────────
            // M-30,15 L30,15 L30,20 L-30,20 Z
            var base = Path()
            base.move(to: pt(-30, 15))
            base.addLine(to: pt(30, 15))
            base.addLine(to: pt(30, 20))
            base.addLine(to: pt(-30, 20))
            base.closeSubpath()
            ctx.fill(base, with: .color(brandWhite))

            // ── Crescent on Dome (orange) ─────────────────────────────────────
            // Approximated as a thin oval/ellipse at (0, -30)
            var crescent = Path()
            crescent.move(to: pt(0, -30))
            crescent.addCurve(to: pt(-3, -25),
                              control1: pt(-3, -30),
                              control2: pt(-3, -27))
            crescent.addCurve(to: pt(0, -25),
                              control1: pt(-1, -23),
                              control2: pt(0, -25))
            crescent.addCurve(to: pt(3, -25),
                              control1: pt(0, -25),
                              control2: pt(1, -23))
            crescent.addCurve(to: pt(0, -30),
                              control1: pt(3, -27),
                              control2: pt(3, -30))
            crescent.closeSubpath()
            ctx.fill(crescent, with: .color(brandOrange))

            // ── Left Minaret Top (orange circle) ──────────────────────────────
            // Center: (-22.5, -23), radius 2.5
            let leftTopCenter = pt(-22.5, -23)
            let r = 2.5 * s
            var leftCircle = Path()
            leftCircle.addEllipse(in: CGRect(x: leftTopCenter.x - r,
                                             y: leftTopCenter.y - r,
                                             width: r * 2, height: r * 2))
            ctx.fill(leftCircle, with: .color(brandOrange))

            // ── Right Minaret Top (orange circle) ─────────────────────────────
            // Center: (22.5, -23), radius 2.5
            let rightTopCenter = pt(22.5, -23)
            var rightCircle = Path()
            rightCircle.addEllipse(in: CGRect(x: rightTopCenter.x - r,
                                              y: rightTopCenter.y - r,
                                              width: r * 2, height: r * 2))
            ctx.fill(rightCircle, with: .color(brandOrange))
        }
    }
}

// MARK: - "MahfilHub" Branding Text
private struct BrandingText: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("Mahfil")
                .foregroundColor(brandWhite)
            Text("Hub")
                .foregroundColor(brandOrange)
        }
        .font(.system(size: 32, weight: .bold, design: .rounded))
        .tracking(1.2)
    }
}

// MARK: - SplashView
struct SplashView: View {

    // Animation state
    @State private var iconScale:   CGFloat = 1.0
    @State private var iconOpacity: Double  = 1.0
    @State private var bgOpacity:   Double  = 1.0

    // Callback: called when the transition ends so the root can swap views
    var onFinished: () -> Void

    var body: some View {
        ZStack {
            splashBg
                .ignoresSafeArea()
                .opacity(bgOpacity)

            VStack(spacing: 24) {
                MosqueIcon()
                    .frame(width: 120, height: 120)
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)

                BrandingText()
                    .opacity(iconOpacity)
            }
        }
        .onAppear(perform: startAnimation)
    }

    // ── Exit animation identical to Android ──────────────────────────────────
    // Android: scale 1→20, duration 700ms, AccelerateInterpolator(2f)
    // Swift   : easeIn curve ≈ AccelerateInterpolator
    private func startAnimation() {
        // Brief hold (matches Android's 400ms windowSplashScreenAnimationDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.timingCurve(0.55, 0, 1, 1, duration: 0.7)) {
                iconScale   = 20.0
                iconOpacity = 0.0
                bgOpacity   = 0.0
            }
            // Signal parent after animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.72) {
                onFinished()
            }
        }
    }
}

#Preview {
    SplashView(onFinished: {})
}
