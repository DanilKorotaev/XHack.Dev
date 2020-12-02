import Foundation

struct Session: Codable, Equatable {
    private(set) var token: Tokens
    private(set) var email: String    
}
