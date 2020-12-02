import Foundation

struct Tokens: Codable, Equatable {
    let accessToken: String
    let refreshToken: String?
    
    init(accessToken: String, refreshToken: String? = nil) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
