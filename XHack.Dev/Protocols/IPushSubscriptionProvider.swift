
import Foundation

protocol IPushSubscriptionProvider {
    var pushToken: String { get }
    
    func subscribeOnRecievePushNotifications(completion: @escaping (PushSubscribingResult)->())
    
    func unSubscribeFromRecievePushNotifications()
}
