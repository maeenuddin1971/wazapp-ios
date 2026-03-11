//
//  MahfilHubApp.swift
//  MahfilHub
//

import SwiftUI
import UIKit

// MARK: - Splash teal colour (shared constant)
// #00897B — same as Android's splash_background
let kSplashTeal = UIColor(red: 0, green: 137 / 255.0, blue: 123 / 255.0, alpha: 1)
let kSplashTealSUI = Color(red: 0, green: 137 / 255.0, blue: 123 / 255.0)

// MARK: - AppDelegate
// Sets UIWindow background colour as early as possible (before SwiftUI
// paints its first frame) so iOS never gets a chance to show white.
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UIWindow.appearance().backgroundColor = kSplashTeal
        return true
    }
}

enum AppScreen {
    case splash
    case onboarding
    case main
}

// MARK: - App
@main
struct MahfilHubApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var currentScreen: AppScreen = .splash

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Layer 0: absolute bottom
                kSplashTealSUI
                    .ignoresSafeArea()

                // Layer 1: Navigation
                if currentScreen == .splash {
                    SplashView {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            currentScreen = .onboarding
                        }
                    }
                    // Splash only gets removed (slides out to the left)
                    .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading)))
                    .zIndex(2)
                }

                if currentScreen == .onboarding {
                    OnboardingView(onFinished: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            currentScreen = .main
                        }
                    })
                    // Onboarding enters from right, exits to left
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .zIndex(1)
                }

                if currentScreen == .main {
                    HomeView()
                        // Main enters from right
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .identity))
                        .zIndex(0)
                }
            }
        }
    }
}
