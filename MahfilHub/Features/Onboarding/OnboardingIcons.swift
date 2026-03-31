import SwiftUI

// MARK: - Onboarding Icons
// Replicates the Canvas drawings from Android's OnboardingScreen.kt

struct OnboardingMosqueIcon: View {
    var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let h = size.height
            let centerX = w / 2
            let white = Color.white
            let orange = colorAccentOrange

            // Main dome
            var domePath = Path()
            domePath.move(to: CGPoint(x: centerX - w * 0.25, y: h * 0.5))
            domePath.addCurve(
                to: CGPoint(x: centerX + w * 0.25, y: h * 0.5),
                control1: CGPoint(x: centerX - w * 0.25, y: h * 0.2),
                control2: CGPoint(x: centerX + w * 0.25, y: h * 0.2)
            )
            domePath.closeSubpath()
            ctx.fill(domePath, with: .color(white.opacity(0.9)))

            // Left minaret
            ctx.fill(Path(CGRect(x: centerX - w * 0.38, y: h * 0.25, width: w * 0.06, height: h * 0.45)), with: .color(white.opacity(0.85)))
            
            // Right minaret
            ctx.fill(Path(CGRect(x: centerX + w * 0.32, y: h * 0.25, width: w * 0.06, height: h * 0.45)), with: .color(white.opacity(0.85)))

            // Base
            ctx.fill(Path(CGRect(x: centerX - w * 0.42, y: h * 0.68, width: w * 0.84, height: h * 0.07)), with: .color(white.opacity(0.9)))

            // Crescent on dome
            let crescentR = w * 0.04
            ctx.fill(Path(ellipseIn: CGRect(x: centerX - crescentR, y: h * 0.16 - crescentR, width: crescentR * 2, height: crescentR * 2)), with: .color(orange))

            // Minaret tops
            let topR = w * 0.03
            ctx.fill(Path(ellipseIn: CGRect(x: centerX - w * 0.35 - topR, y: h * 0.22 - topR, width: topR * 2, height: topR * 2)), with: .color(orange))
            ctx.fill(Path(ellipseIn: CGRect(x: centerX + w * 0.35 - topR, y: h * 0.22 - topR, width: topR * 2, height: topR * 2)), with: .color(orange))

            // Decorative arch in dome
            var archPath = Path()
            archPath.move(to: CGPoint(x: centerX - w * 0.08, y: h * 0.5))
            archPath.addCurve(
                to: CGPoint(x: centerX + w * 0.08, y: h * 0.5),
                control1: CGPoint(x: centerX - w * 0.08, y: h * 0.35),
                control2: CGPoint(x: centerX + w * 0.08, y: h * 0.35)
            )
            var style = StrokeStyle(lineWidth: 3)
            ctx.stroke(archPath, with: .color(orange.opacity(0.4)), style: style)
        }
    }
}

struct OnboardingCommunityIcon: View {
    var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let h = size.height
            let centerX = w / 2
            let white = Color.white
            let orange = colorAccentOrange

            // Center person (larger)
            let cr = w * 0.08
            ctx.fill(Path(ellipseIn: CGRect(x: centerX - cr, y: h * 0.3 - cr, width: cr * 2, height: cr * 2)), with: .color(white.opacity(0.9)))
            ctx.fill(Path(roundedRect: CGRect(x: centerX - w * 0.1, y: h * 0.42, width: w * 0.2, height: h * 0.2), cornerRadius: w * 0.05), with: .color(white.opacity(0.85)))

            // Left person
            let lr = w * 0.06
            ctx.fill(Path(ellipseIn: CGRect(x: (centerX - w * 0.25) - lr, y: h * 0.36 - lr, width: lr * 2, height: lr * 2)), with: .color(white.opacity(0.7)))
            ctx.fill(Path(roundedRect: CGRect(x: centerX - w * 0.33, y: h * 0.46, width: w * 0.16, height: h * 0.16), cornerRadius: w * 0.04), with: .color(white.opacity(0.65)))

            // Right person
            let rr = w * 0.06
            ctx.fill(Path(ellipseIn: CGRect(x: (centerX + w * 0.25) - rr, y: h * 0.36 - rr, width: rr * 2, height: rr * 2)), with: .color(white.opacity(0.7)))
            ctx.fill(Path(roundedRect: CGRect(x: centerX + w * 0.17, y: h * 0.46, width: w * 0.16, height: h * 0.16), cornerRadius: w * 0.04), with: .color(white.opacity(0.65)))

            // Connection lines
            var lineStyle = StrokeStyle(lineWidth: 3)
            var leftPath = Path()
            leftPath.move(to: CGPoint(x: centerX - w * 0.12, y: h * 0.4))
            leftPath.addLine(to: CGPoint(x: centerX - w * 0.18, y: h * 0.4))
            ctx.stroke(leftPath, with: .color(orange.opacity(0.5)), style: lineStyle)
            
            var rightPath = Path()
            rightPath.move(to: CGPoint(x: centerX + w * 0.12, y: h * 0.4))
            rightPath.addLine(to: CGPoint(x: centerX + w * 0.18, y: h * 0.4))
            ctx.stroke(rightPath, with: .color(orange.opacity(0.5)), style: lineStyle)

            // Heart / connection symbol
            let sr = w * 0.04
            ctx.fill(Path(ellipseIn: CGRect(x: centerX - sr, y: h * 0.68 - sr, width: sr * 2, height: sr * 2)), with: .color(orange.opacity(0.6)))
            
            let hr = w * 0.06
            var hStyle = StrokeStyle(lineWidth: 2)
            ctx.stroke(Path(ellipseIn: CGRect(x: centerX - hr, y: h * 0.68 - hr, width: hr * 2, height: hr * 2)), with: .color(white.opacity(0.4)), style: hStyle)
        }
    }
}

struct OnboardingReminderIcon: View {
    @State private var bellSwing: Double = -8.0

    var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let h = size.height
            let centerX = w / 2
            let white = Color.white
            let orange = colorAccentOrange

            // Context for rotating the bell
            var bellCtx = ctx
            let bellPivot = CGPoint(x: centerX, y: h * 0.2)
            bellCtx.translateBy(x: bellPivot.x, y: bellPivot.y)
            bellCtx.rotate(by: .degrees(bellSwing))
            bellCtx.translateBy(x: -bellPivot.x, y: -bellPivot.y)

            // Bell body
            var bellPath = Path()
            bellPath.move(to: CGPoint(x: centerX - w * 0.2, y: h * 0.55))
            bellPath.addCurve(
                to: CGPoint(x: centerX, y: h * 0.2),
                control1: CGPoint(x: centerX - w * 0.2, y: h * 0.25),
                control2: CGPoint(x: centerX - w * 0.08, y: h * 0.2)
            )
            bellPath.addCurve(
                to: CGPoint(x: centerX + w * 0.2, y: h * 0.55),
                control1: CGPoint(x: centerX + w * 0.08, y: h * 0.2),
                control2: CGPoint(x: centerX + w * 0.2, y: h * 0.25)
            )
            bellPath.addLine(to: CGPoint(x: centerX + w * 0.25, y: h * 0.58))
            bellPath.addLine(to: CGPoint(x: centerX - w * 0.25, y: h * 0.58))
            bellPath.closeSubpath()
            bellCtx.fill(bellPath, with: .color(white.opacity(0.9)))

            // Bell top
            let btr = w * 0.035
            bellCtx.fill(Path(ellipseIn: CGRect(x: centerX - btr, y: h * 0.18 - btr, width: btr * 2, height: btr * 2)), with: .color(orange))

            // Bell clapper
            let bcr = w * 0.04
            bellCtx.fill(Path(ellipseIn: CGRect(x: centerX - bcr, y: h * 0.6 - bcr, width: bcr * 2, height: bcr * 2)), with: .color(orange.opacity(0.8)))

            // Sound waves - left
            let slRect = CGRect(x: centerX - w * 0.42, y: h * 0.28, width: w * 0.18, height: h * 0.24)
            var slPath = Path()
            slPath.addArc(center: CGPoint(x: slRect.midX + w * 0.09, y: slRect.midY), radius: h * 0.12, startAngle: .degrees(-150), endAngle: .degrees(-210), clockwise: true)
            // Simpler arcs
            var wStyle3 = StrokeStyle(lineWidth: 3)
            var wStyle2 = StrokeStyle(lineWidth: 2)
            
            var leftWave1 = Path()
            leftWave1.addArc(center: CGPoint(x: centerX - w * 0.24, y: h * 0.4), radius: w * 0.15, startAngle: .degrees(150), endAngle: .degrees(210), clockwise: false)
            ctx.stroke(leftWave1, with: .color(orange.opacity(0.4)), style: wStyle3)
            
            var leftWave2 = Path()
            leftWave2.addArc(center: CGPoint(x: centerX - w * 0.26, y: h * 0.4), radius: w * 0.22, startAngle: .degrees(150), endAngle: .degrees(210), clockwise: false)
            ctx.stroke(leftWave2, with: .color(orange.opacity(0.25)), style: wStyle2)

            // Sound waves - right
            var rightWave1 = Path()
            rightWave1.addArc(center: CGPoint(x: centerX + w * 0.24, y: h * 0.4), radius: w * 0.15, startAngle: .degrees(30), endAngle: .degrees(-30), clockwise: true)
            ctx.stroke(rightWave1, with: .color(orange.opacity(0.4)), style: wStyle3)
            
            var rightWave2 = Path()
            rightWave2.addArc(center: CGPoint(x: centerX + w * 0.26, y: h * 0.4), radius: w * 0.22, startAngle: .degrees(30), endAngle: .degrees(-30), clockwise: true)
            ctx.stroke(rightWave2, with: .color(orange.opacity(0.25)), style: wStyle2)

            // Calendar icon below bell
            ctx.fill(Path(roundedRect: CGRect(x: centerX - w * 0.12, y: h * 0.7, width: w * 0.24, height: h * 0.2), cornerRadius: w * 0.02), with: .color(white.opacity(0.3)))
            ctx.fill(Path(CGRect(x: centerX - w * 0.12, y: h * 0.7, width: w * 0.24, height: h * 0.05)), with: .color(orange.opacity(0.5)))
            
            // Calendar check mark
            var checkPath = Path()
            checkPath.move(to: CGPoint(x: centerX - w * 0.04, y: h * 0.82))
            checkPath.addLine(to: CGPoint(x: centerX - w * 0.01, y: h * 0.85))
            checkPath.addLine(to: CGPoint(x: centerX + w * 0.06, y: h * 0.78))
            ctx.stroke(checkPath, with: .color(orange.opacity(0.7)), style: wStyle3)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                bellSwing = 8.0
            }
        }
    }
}
