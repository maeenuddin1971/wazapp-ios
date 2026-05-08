import Foundation
import Observation

@MainActor
@Observable
final class LoginViewModel {
    private let authService: AuthService

    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?

    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }

    func login() async -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        errorMessage = nil

        guard !trimmedEmail.isEmpty else {
            errorMessage = "Please enter your email"
            return false
        }

        guard trimmedEmail.contains("@") && trimmedEmail.contains(".") else {
            errorMessage = "Please enter a valid email"
            return false
        }

        guard !password.isEmpty else {
            errorMessage = "Please enter your password"
            return false
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return false
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await authService.login(email: trimmedEmail, password: password)
            SessionManager.shared.login(email: trimmedEmail, token: response.token, role: response.role)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
