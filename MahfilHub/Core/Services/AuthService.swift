import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let role: String
    let token: String
}

enum AuthServiceError: LocalizedError {
    case emptyResponse
    case loginFailed(String)

    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "Empty response body"
        case .loginFailed(let message):
            return message
        }
    }
}

final class AuthService {
    private let baseURL = URL(string: "https://wazappbackend-1.onrender.com/")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func login(email: String, password: String) async throws -> LoginResponse {
        let url = baseURL.appending(path: "auth/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(LoginRequest(email: email, password: password))

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthServiceError.emptyResponse
        }

        if (200..<300).contains(httpResponse.statusCode) {
            return try JSONDecoder().decode(LoginResponse.self, from: data)
        }

        throw AuthServiceError.loginFailed(parseErrorMessage(from: data, statusCode: httpResponse.statusCode))
    }

    private func parseErrorMessage(from data: Data, statusCode: Int) -> String {
        guard !data.isEmpty else { return "Login failed (\(statusCode))" }
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let message = json?["message"] as? String
        return message?.isEmpty == false ? message! : "Login failed (\(statusCode))"
    }
}
