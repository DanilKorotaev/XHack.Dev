import Foundation

struct SignUpRequest: Encodable {
    let email: String
    let password: String
    let name: String
}
