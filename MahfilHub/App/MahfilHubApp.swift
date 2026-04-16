//
//  MahfilHubApp.swift
//  MahfilHub
//

import SwiftUI

// MARK: - Splash teal colour (Asset Catalog backed)
let kSplashTeal = UIColor.appSplashTeal
let kSplashTealSUI = Color.appSplashTeal

// MARK: - AppDelegate
@MainActor
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

    // MARK: - ViewModels (single source of truth)
    @State private var eventsViewModel = EventsViewModel()
    @State private var maulanaViewModel = MaulanaViewModel()
    @State private var notificationsViewModel = NotificationsViewModel()
    @State private var savedEventsViewModel = SavedEventsViewModel()
    @State private var followingViewModel = FollowingViewModel()
    @State private var myRemindersViewModel = MyRemindersViewModel()

    var body: some Scene {
        WindowGroup {
            AppRootView(currentScreen: $currentScreen)
                .environment(eventsViewModel)
                .environment(maulanaViewModel)
                .environment(notificationsViewModel)
                .environment(savedEventsViewModel)
                .environment(followingViewModel)
                .environment(myRemindersViewModel)
        }
    }
}

// Separate root view so @State binding works reliably
struct AppRootView: View {
    @Binding var currentScreen: AppScreen

    var body: some View {
        ZStack {
            kSplashTealSUI
                .ignoresSafeArea()

            // Main (Home) — lowest visual layer
            if currentScreen == .main {
                HomeView()
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .identity))
                    .zIndex(1)
            }

            // Register
            if currentScreen == .register {
                RegisterView(currentScreen: $currentScreen)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                    .zIndex(2)
            }

            // Login
            if currentScreen == .login {
                LoginView(currentScreen: $currentScreen)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .zIndex(3)
            }

            // Onboarding
            if currentScreen == .onboarding {
                OnboardingView(onFinished: {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        currentScreen = .login
                    }
                })
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .zIndex(4)
            }

            // Splash — highest visual layer
            if currentScreen == .splash {
                SplashView {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        if SessionManager.shared.isLoggedIn {
                            currentScreen = .main
                        } else {
                            currentScreen = .onboarding
                        }
                    }
                }
                .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading)))
                .zIndex(5)
            }
        }
    }
}
