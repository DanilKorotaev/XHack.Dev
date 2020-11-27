
import Foundation

class PushSubscribingResultMessage : Message {
    let pushToken: String?
    let error: String?
    
    init(pushToken: String? = nil, error: String? = nil) {
        self.pushToken = pushToken
        self.error = error
    }
}
