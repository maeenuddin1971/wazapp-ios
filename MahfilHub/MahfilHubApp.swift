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

// MARK: - App
@main
struct MahfilHubApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                // ── Layer 0: absolute bottom  ─────────────────────────────────
                // This is the VERY FIRST pixel SwiftUI commits to the screen.
                // It fills the entire window (incl. safe areas) with teal so
                // there is literally zero opportunity for white to appear,
                // even if UIWindow.appearance() is ignored on this OS version.
                kSplashTealSUI
                    .ignoresSafeArea()

                // ── Layer 1: real content (hidden while splash is up) ─────────
                ContentView()
                    .opacity(showSplash ? 0 : 1)

                // ── Layer 2: splash screen ────────────────────────────────────
                if showSplash {
                    SplashView {
                        withAnimation(.easeIn(duration: 0.15)) {
                            showSplash = false
                        }
                    }
                    .zIndex(1)
                }
            }
        }
    }
}
