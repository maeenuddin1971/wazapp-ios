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
    case login
    case register
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

                // Layer 1: Splash
                if currentScreen == .splash {
                    SplashView {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            currentScreen = .onboarding
                        }
                    }
                    .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading)))
                    .zIndex(4)
                }

                // Layer 2: Onboarding
                if currentScreen == .onboarding {
                    OnboardingView(onFinished: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            currentScreen = .login
                        }
                    })
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .zIndex(3)
                }

                // Layer 3: Login
                if currentScreen == .login {
                    LoginView(
                        onLoginSuccess: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentScreen = .main
                            }
                        },
                        onNavigateToRegister: {
                            print("App Level: Navigate to register triggered")
                            withAnimation(.easeInOut(duration: 0.35)) {
                                currentScreen = .register
                            }
                        },
                        onGuestMode: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentScreen = .main
                            }
                        }
                    )
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .zIndex(2)
                }

                // Layer 4: Register
                if currentScreen == .register {
                    RegisterView(
                        onRegisterSuccess: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentScreen = .main
                            }
                        },
                        onNavigateToLogin: {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                currentScreen = .login
                            }
                        }
                    )
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .zIndex(1)
                }

                // Layer 5: Main (Home)
                if currentScreen == .main {
                    HomeView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .identity))
                        .zIndex(0)
                }
            }
        }
    }
}
