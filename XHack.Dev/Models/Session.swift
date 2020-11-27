import Foundation

struct Session: Codable, Equatable {
    private(set) var token: Token
    private(set) var email: String    
}
