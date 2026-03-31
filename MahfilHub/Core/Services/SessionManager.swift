import Foundation

/// Simple session manager backed by UserDefaults.
/// Stores login state and basic user info.
/// Replace static values with real API data later.
@MainActor
final class SessionManager {
    
    static let shared = SessionManager()
    
    private let defaults = UserDefaults.standard
    
    // Keys
    private enum Keys {
        static let isLoggedIn = "mahfilhub_is_logged_in"
        static let userName   = "mahfilhub_user_name"
        static let userEmail  = "mahfilhub_user_email"
    }
    
    private init() {}
    
    // MARK: - Login State
    
    var isLoggedIn: Bool {
        defaults.bool(forKey: Keys.isLoggedIn)
    }
    
    /// Save login session. Uses static placeholder values for now.
    /// Replace with real API response data later.
    func login(name: String = "Guest User", email: String = "user@mahfilhub.com") {
        defaults.set(true, forKey: Keys.isLoggedIn)
        defaults.set(name, forKey: Keys.userName)
        defaults.set(email, forKey: Keys.userEmail)
    }
    
    func logout() {
        defaults.set(false, forKey: Keys.isLoggedIn)
        defaults.removeObject(forKey: Keys.userName)
        defaults.removeObject(forKey: Keys.userEmail)
    }
    
    // MARK: - User Info
    
    var userName: String {
        defaults.string(forKey: Keys.userName) ?? "Guest"
    }
    
    var userEmail: String {
        defaults.string(forKey: Keys.userEmail) ?? ""
    }
}
