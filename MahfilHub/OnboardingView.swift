import SwiftUI

struct OnboardingPageModel {
    let title: String
    let description: String
    let iconContent: AnyView
}

struct OnboardingView: View {
    var onFinished: () -> Void

    @State private var isEnglish = true
    @State private var currentPage = 0

    // Animation state
    @State private var floatAnim: CGFloat = 0.0
    @State private var bgRotation: Double = 0.0

    private var pages: [OnboardingPageModel] {
        if isEnglish {
            return [
                OnboardingPageModel(title: "Discover Islamic Events", description: "Find and attend Mahfil events happening near you", iconContent: AnyView(OnboardingMosqueIcon())),
                OnboardingPageModel(title: "Connect with Community", description: "Join the community and enrich your spiritual journey", iconContent: AnyView(OnboardingCommunityIcon())),
                OnboardingPageModel(title: "Never Miss an Event", description: "Set reminders and stay updated with upcoming events", iconContent: AnyView(OnboardingReminderIcon()))
            ]
        } else {
            return [
                OnboardingPageModel(title: "ইসলামিক ইভেন্ট আবিষ্কার করুন", description: "আপনার কাছাকাছি মাহফিল ইভেন্ট খুঁজুন এবং অংশগ্রহণ করুন", iconContent: AnyView(OnboardingMosqueIcon())),
                OnboardingPageModel(title: "সম্প্রদায়ের সাথে সংযুক্ত হন", description: "সম্প্রদায়ে যোগ দিন এবং আপনার আধ্যাত্মিক যাত্রা সমৃদ্ধ করুন", iconContent: AnyView(OnboardingCommunityIcon())),
                OnboardingPageModel(title: "কোন ইভেন্ট মিস করবেন না", description: "রিমাইন্ডার সেট করুন এবং আসন্ন ইভেন্টগুলির সাথে আপডেট থাকুন", iconContent: AnyView(OnboardingReminderIcon()))
            ]
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [colorPrimaryTeal, colorPrimaryTealDark, colorDeepTeal],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            OnboardingBackgroundDecorations(rotation: bgRotation)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    if currentPage < pages.count - 1 {
                        Button(action: onFinished) {
                            Text(isEnglish ? "Skip" : "এড়িয়ে যান")
                                .font(.callout.weight(.semibold))
                                .foregroundColor(colorWhite.opacity(0.8))
                        }
                    } else {
                        Spacer().frame(width: 40)
                    }
                    Spacer()
                    LanguageToggle(isEnglish: $isEnglish)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageContent(page: pages[index], floatAnim: floatAnim)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)

                VStack(spacing: 32) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 5)
                                .fill(index == currentPage ? colorAccentOrange : colorWhite.opacity(0.4))
                                .frame(width: index == currentPage ? 32 : 10, height: 10)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentPage)
                        }
                    }

                    if currentPage == pages.count - 1 {
                        Button(action: { onFinished() }) {
                            Text(isEnglish ? "Get Started" : "শুরু করুন")
                                .font(.headline)
                                .foregroundColor(colorWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(colorAccentOrange)
                                .cornerRadius(28)
                                .shadow(color: colorAccentOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .transition(.opacity)
                    } else {
                        Button(action: {
                            withAnimation { currentPage += 1 }
                        }) {
                            Text(isEnglish ? "Next" : "পরবর্তী")
                                .font(.headline)
                                .foregroundColor(colorWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(colorWhite.opacity(0.2))
                                .cornerRadius(28)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(colorWhite.opacity(0.4), lineWidth: 1)
                                )
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                floatAnim = 1.0
            }
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                bgRotation = 360.0
            }
        }
    }
}

// MARK: - OnboardingPageContent
struct OnboardingPageContent: View {
    let page: OnboardingPageModel
    let floatAnim: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Icon with Glow
            ZStack {
                // Glow Circle
                Circle()
                    .fill(RadialGradient(
                        colors: [colorWhite.opacity(0.15), colorWhite.opacity(0.05), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    ))
                    .frame(width: 200, height: 200)

                // Dynamic Icon
                page.iconContent
                    .frame(width: 140, height: 140)
            }
            // Continuous floating effect: Maps 0..1 to -6..+6
            .offset(y: floatAnim * 12 - 6)

            Spacer()
                .frame(height: 60)

            // Title
            Text(page.title)
                .font(.title2.bold())
                .foregroundColor(colorWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()
                .frame(height: 16)

            // Description
            Text(page.description)
                .font(.callout)
                .foregroundColor(colorWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 32)

            Spacer()
        }
    }
}

// MARK: - OnboardingBackgroundDecorations
struct OnboardingBackgroundDecorations: View {
    var rotation: Double

    var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let h = size.height

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
            let trCenter = CGPoint(x: w * 0.85, y: h * 0.12)
            trContext.translateBy(x: trCenter.x, y: trCenter.y)
            trContext.rotate(by: .degrees(rotation * 0.1))
            trContext.translateBy(x: -trCenter.x, y: -trCenter.y)
            drawIslamicStar(in: &trContext, center: trCenter, radius: 60, color: colorWhite.opacity(0.06))

            // Bottom-left star (rotating opposite)
            var blContext = ctx
            let blCenter = CGPoint(x: w * 0.15, y: h * 0.85)
            blContext.translateBy(x: blCenter.x, y: blCenter.y)
            blContext.rotate(by: .degrees(-rotation * 0.08))
            blContext.translateBy(x: -blCenter.x, y: -blCenter.y)
            drawIslamicStar(in: &blContext, center: blCenter, radius: 45, color: colorWhite.opacity(0.05))

            // Scattered circles
            ctx.fill(Path(ellipseIn: CGRect(x: w * 0.1 - 80, y: h * 0.3 - 80, width: 160, height: 160)), with: .color(colorWhite.opacity(0.04)))
            ctx.fill(Path(ellipseIn: CGRect(x: w * 0.9 - 120, y: h * 0.6 - 120, width: 240, height: 240)), with: .color(colorWhite.opacity(0.03)))
            ctx.fill(Path(ellipseIn: CGRect(x: w * 0.5 - 50, y: h * 0.08 - 50, width: 100, height: 100)), with: .color(colorWhite.opacity(0.04)))
        }
    }
}

// MARK: - Language Toggle Layer
struct LanguageToggle: View {
    @Binding var isEnglish: Bool

    var body: some View {
        HStack(spacing: 0) {
            // English Option
            Text("English")
                .font(.subheadline)
                .fontWeight(isEnglish ? .bold : .regular)
                .foregroundColor(isEnglish ? colorWhite : colorWhite.opacity(0.6))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isEnglish ? colorAccentOrange : Color.clear)
                .cornerRadius(16)
                .onTapGesture {
                    withAnimation { isEnglish = true }
                }

            // Bangla Option
            Text("বাংলা")
                .font(.subheadline)
                .fontWeight(!isEnglish ? .bold : .regular)
                .foregroundColor(!isEnglish ? colorWhite : colorWhite.opacity(0.6))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(!isEnglish ? colorAccentOrange : Color.clear)
                .cornerRadius(16)
                .onTapGesture {
                    withAnimation { isEnglish = false }
                }
        }
        .padding(4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(colorWhite.opacity(0.4), lineWidth: 1.5)
        )
    }
}
