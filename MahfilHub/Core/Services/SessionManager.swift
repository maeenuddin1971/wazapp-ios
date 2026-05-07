import Foundation
import Observation

/// Simple session manager backed by UserDefaults.
/// Stores login state, token, role and basic user info.
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
        static let authToken  = "mahfilhub_auth_token"
        static let userRole   = "mahfilhub_user_role"
    }
    
    private init() {
        _isLoggedIn = defaults.bool(forKey: Keys.isLoggedIn)
        _userName = defaults.string(forKey: Keys.userName) ?? "Guest"
        _userEmail = defaults.string(forKey: Keys.userEmail) ?? ""
        _authToken = defaults.string(forKey: Keys.authToken)
        _userRole = defaults.string(forKey: Keys.userRole) ?? ""
    }
    
    // MARK: - Observable State
    
    private(set) var isLoggedIn: Bool = false
    private(set) var userName: String = "Guest"
    private(set) var userEmail: String = ""
    private(set) var authToken: String?
    private(set) var userRole: String = ""
    
    /// Save login session with token and role from API response.
    func login(
        name: String = "Guest User",
        email: String = "user@mahfilhub.com",
        token: String? = nil,
        role: String = ""
    ) {
        defaults.set(true, forKey: Keys.isLoggedIn)
        defaults.set(name, forKey: Keys.userName)
        defaults.set(email, forKey: Keys.userEmail)
        defaults.set(token, forKey: Keys.authToken)
        defaults.set(role, forKey: Keys.userRole)
        isLoggedIn = true
        userName = name
        userEmail = email
        authToken = token
        userRole = role
    }
    
    func logout() {
        defaults.set(false, forKey: Keys.isLoggedIn)
        defaults.removeObject(forKey: Keys.userName)
        defaults.removeObject(forKey: Keys.userEmail)
        defaults.removeObject(forKey: Keys.authToken)
        defaults.removeObject(forKey: Keys.userRole)
        isLoggedIn = false
        userName = "Guest"
        userEmail = ""
        authToken = nil
        userRole = ""
    }
}
