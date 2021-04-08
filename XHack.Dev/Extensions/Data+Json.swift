import Foundation

extension Data {
    func toObject<T:Codable>(_ type: T.Type) -> T? {
        if type == VoidResponse.self {
            return VoidResponse() as? T
        }
        do {
            return try Json.decoder.decode(type, from: self)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
