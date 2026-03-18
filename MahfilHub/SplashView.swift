import SwiftUI

// MARK: - Brand Colors (aliases to Asset Catalog)
let colorPrimaryTeal     = Color.appPrimaryTeal
let colorPrimaryTealDark = Color.appPrimaryTealDark
let colorDeepTeal        = Color.appDeepTeal
let colorAccentOrange    = Color.appAccentOrange
let colorWhite           = Color.white

struct SplashView: View {
    var onFinished: () -> Void

    // Entrance Animation States
    @State private var logoScale: CGFloat = 0.3
    @State private var logoAlpha: Double = 0.0
    @State private var brandingAlpha: Double = 0.0
    @State private var brandingOffset: CGFloat = 30.0

    // Continuous Animation States
    @State private var glowPulse: CGFloat = 0.8
    @State private var logoFloat: CGFloat = -12.0
    @State private var bgRotation: Double = 0.0

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [colorPrimaryTeal, colorPrimaryTealDark, colorDeepTeal],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Background Decorations
            SplashBackgroundDecorations(rotation: bgRotation)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                // Logo with glow
                ZStack {
                    // Glow circle
                    Circle()
                        .fill(RadialGradient(
                            colors: [colorWhite.opacity(0.2), colorWhite.opacity(0.05), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 70 * glowPulse)
                        )
                        .frame(width: 140 * glowPulse, height: 140 * glowPulse)
                        .opacity(logoAlpha * 0.6)

                    // Mosque Logo
                    SplashMosqueLogo()
                        .frame(width: 120, height: 120)
                        .scaleEffect(logoScale)
                        .opacity(logoAlpha)
                }
                .offset(y: logoFloat)

                // Branding Text
                VStack(spacing: 8) {
                    Text("MahfilHub")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(colorWhite)
                        .tracking(2.0)

                    Text("Your Islamic Events Compass") // Matches Android strings_bn fallback or splash_tagline
                        .font(.system(size: 14))
                        .foregroundColor(colorWhite.opacity(0.7))
                }
                .opacity(brandingAlpha)
                .offset(y: brandingOffset)
            }
        }
        .onAppear(perform: startAnimations)
    }

    private func startAnimations() {
        // Entrance Animations
        withAnimation(SplashAnimations.logoScaleAnimation) { logoScale = 1.0 }
        withAnimation(SplashAnimations.logoAlphaAnimation) { logoAlpha = 1.0 }
        withAnimation(SplashAnimations.brandingAlphaAnimation) { brandingAlpha = 1.0 }
        withAnimation(SplashAnimations.brandingSlideAnimation) { brandingOffset = 0.0 }
        
        // Continuous Animations
        withAnimation(SplashAnimations.glowPulseAnimation) { glowPulse = 1.2 }
        withAnimation(SplashAnimations.logoFloatAnimation) { logoFloat = 12.0 }
        withAnimation(SplashAnimations.bgRotationAnimation) { bgRotation = 360.0 }

        // Transition Timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + SplashAnimations.splashDisplayDuration) {
            onFinished()
        }
    }
}

// MARK: - SplashMosqueLogo
struct SplashMosqueLogo: View {
    var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let h = size.height
            let centerX = w / 2.0

            // Central dome
            var domePath = Path()
            domePath.move(to: CGPoint(x: centerX - w * 0.25, y: h * 0.52))
            domePath.addCurve(
                to: CGPoint(x: centerX + w * 0.25, y: h * 0.52),
                control1: CGPoint(x: centerX - w * 0.25, y: h * 0.18),
                control2: CGPoint(x: centerX + w * 0.25, y: h * 0.18)
            )
            domePath.closeSubpath()
            ctx.fill(domePath, with: .color(colorWhite))

            // Left minaret
            let leftMinaretRect = CGRect(x: centerX - w * 0.38, y: h * 0.25, width: w * 0.07, height: h * 0.45)
            ctx.fill(Path(leftMinaretRect), with: .color(colorWhite))

            // Right minaret
            let rightMinaretRect = CGRect(x: centerX + w * 0.31, y: h * 0.25, width: w * 0.07, height: h * 0.45)
            ctx.fill(Path(rightMinaretRect), with: .color(colorWhite))

            // Base
            let baseRect = CGRect(x: centerX - w * 0.42, y: h * 0.68, width: w * 0.84, height: h * 0.08)
            ctx.fill(Path(baseRect), with: .color(colorWhite))

            // Crescent on dome
            let crescentRadius = w * 0.045
            let crescentCenter = CGPoint(x: centerX, y: h * 0.14)
            ctx.fill(Path(ellipseIn: CGRect(x: crescentCenter.x - crescentRadius, y: crescentCenter.y - crescentRadius, width: crescentRadius * 2, height: crescentRadius * 2)), with: .color(colorAccentOrange))

            // Minaret tops
            let minaretTopRadius = w * 0.035
            let leftTopCenter = CGPoint(x: centerX - w * 0.345, y: h * 0.22)
            ctx.fill(Path(ellipseIn: CGRect(x: leftTopCenter.x - minaretTopRadius, y: leftTopCenter.y - minaretTopRadius, width: minaretTopRadius * 2, height: minaretTopRadius * 2)), with: .color(colorAccentOrange))

            let rightTopCenter = CGPoint(x: centerX + w * 0.345, y: h * 0.22)
            ctx.fill(Path(ellipseIn: CGRect(x: rightTopCenter.x - minaretTopRadius, y: rightTopCenter.y - minaretTopRadius, width: minaretTopRadius * 2, height: minaretTopRadius * 2)), with: .color(colorAccentOrange))

            // Decorative arch
            var archPath = Path()
            archPath.move(to: CGPoint(x: centerX - w * 0.1, y: h * 0.52))
            archPath.addCurve(
                to: CGPoint(x: centerX + w * 0.1, y: h * 0.52),
                control1: CGPoint(x: centerX - w * 0.1, y: h * 0.35),
                control2: CGPoint(x: centerX + w * 0.1, y: h * 0.35)
            )
            var strokeConfig = StrokeStyle()
            strokeConfig.lineWidth = 3
            ctx.stroke(archPath, with: .color(colorAccentOrange.opacity(0.4)), style: strokeConfig)
        }
    }
}

// MARK: - SplashBackgroundDecorations
struct SplashBackgroundDecorations: View {
    var rotation: Double

    var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let h = size.height

            // Scattered circles
            ctx.fill(Path(ellipseIn: CGRect(x: w * 0.08 - 90, y: h * 0.35 - 90, width: 180, height: 180)), with: .color(colorWhite.opacity(0.04)))
            ctx.fill(Path(ellipseIn: CGRect(x: w * 0.92 - 130, y: h * 0.65 - 130, width: 260, height: 260)), with: .color(colorWhite.opacity(0.03)))
            ctx.fill(Path(ellipseIn: CGRect(x: w * 0.5 - 60, y: h * 0.06 - 60, width: 120, height: 120)), with: .color(colorWhite.opacity(0.04)))
            ctx.fill(Path(ellipseIn: CGRect(x: w * 0.7 - 45, y: h * 0.92 - 45, width: 90, height: 90)), with: .color(colorWhite.opacity(0.03)))

            // Helper to draw Islamic stars
            func drawIslamicStar(in context: inout GraphicsContext, center: CGPoint, radius: CGFloat, color: Color) {
                let points = 8
                var path = Path()
                for i in 0..<(points * 2) {
                    let r = (i % 2 == 0) ? radius : radius * 0.5
                    let angle = (Double(i) * 360.0 / Double(points * 2) - 90.0) * .pi / 180.0
                    let x = center.x + CGFloat(cos(angle)) * r
                    let y = center.y + CGFloat(sin(angle)) * r
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                path.closeSubpath()
                context.fill(path, with: .color(color))
                
                var strokeConfig = StrokeStyle()
                strokeConfig.lineWidth = 2
                context.stroke(path, with: .color(color.opacity(0.5)), style: strokeConfig)
            }

            // Top-right star (rotating)
            var trContext = ctx
            let trCenter = CGPoint(x: w * 0.85, y: h * 0.1)
            trContext.translateBy(x: trCenter.x, y: trCenter.y)
            trContext.rotate(by: .degrees(rotation * 0.05))
            trContext.translateBy(x: -trCenter.x, y: -trCenter.y)
            drawIslamicStar(in: &trContext, center: trCenter, radius: 70, color: colorWhite.opacity(0.06))

            // Bottom-left star (rotating opposite)
            var blContext = ctx
            let blCenter = CGPoint(x: w * 0.12, y: h * 0.88)
            blContext.translateBy(x: blCenter.x, y: blCenter.y)
            blContext.rotate(by: .degrees(-rotation * 0.04))
            blContext.translateBy(x: -blCenter.x, y: -blCenter.y)
            drawIslamicStar(in: &blContext, center: blCenter, radius: 55, color: colorWhite.opacity(0.05))
        }
    }
}

