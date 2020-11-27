
import Foundation

struct PushSubscribingResult {
    var oldPushToken: String
    var currentPushToken: String?
    var tokenDidChanged: Bool { get { return  currentPushToken != oldPushToken}}
    func __conversion() -> Bool { return currentPushToken?.hasNonEmptyValue() ?? false }
}
