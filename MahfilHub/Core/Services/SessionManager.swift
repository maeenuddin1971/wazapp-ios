import Foundation
import Observation

/// Simple session manager backed by UserDefaults.
/// Stores login state and basic user info.
/// Replace static values with real API data later.
@MainActor
@Observable
final class SessionManager {
    
    static let shared = SessionManager()
    
    private let defaults = UserDefaults.standard
    
    // Keys
    private enum Keys {
        static let isLoggedIn = "mahfilhub_is_logged_in"
        static let userName   = "mahfilhub_user_name"
        static let userEmail  = "mahfilhub_user_email"
    }
    
    private init() {
        _isLoggedIn = defaults.bool(forKey: Keys.isLoggedIn)
        _userName = defaults.string(forKey: Keys.userName) ?? "Guest"
        _userEmail = defaults.string(forKey: Keys.userEmail) ?? ""
    }
    
    // MARK: - Observable State
    
    private(set) var isLoggedIn: Bool = false
    private(set) var userName: String = "Guest"
    private(set) var userEmail: String = ""
    
    /// Save login session. Uses static placeholder values for now.
    /// Replace with real API response data later.
    func login(name: String = "Guest User", email: String = "user@mahfilhub.com") {
        defaults.set(true, forKey: Keys.isLoggedIn)
        defaults.set(name, forKey: Keys.userName)
        defaults.set(email, forKey: Keys.userEmail)
        isLoggedIn = true
        userName = name
        userEmail = email
    }
    
    func logout() {
        defaults.set(false, forKey: Keys.isLoggedIn)
        defaults.removeObject(forKey: Keys.userName)
        defaults.removeObject(forKey: Keys.userEmail)
        isLoggedIn = false
        userName = "Guest"
        userEmail = ""
    }
}
