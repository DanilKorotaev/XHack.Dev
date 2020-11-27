
import Foundation
import UIKit

class PushSubscriptionProvider: IPushSubscriptionProvider {
    let tokenSettingKey = "PushDeviceToken"
    var pushToken: String {get {UserDefaults.standard.string(forKey: tokenSettingKey) ?? ""}}
    private var messager: IMessager
    private var resultHandlers: [(PushSubscribingResult) -> Void] = []
    private var unsubscriptionCallback: UnsubscribeMessagerHandler?
    
    init(messager: IMessager) {
        self.messager = messager
        subscribeMessager()
    }
    
    func subscribeOnRecievePushNotifications(completion: @escaping (PushSubscribingResult) -> ()) {
        resultHandlers.append(completion)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                DispatchQueue.main.sync {
                    UIApplication.shared.registerForRemoteNotifications()
                }                
            }
        }
    }
    
    
    func unSubscribeFromRecievePushNotifications() {
        UserDefaults.standard.removeObject(forKey: tokenSettingKey)
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    private func subscribeMessager() {
        unsubscriptionCallback =  self.messager.subscribe(PushSubscribingResultMessage.self, completion: MessangerSubcribeComplition<PushSubscribingResultMessage> {[weak self] (message) in
            guard let self = self else {return}
            let currentToken =  message.error?.hasNonEmptyValue() ?? true ? message.pushToken : nil;
            let result = PushSubscribingResult(oldPushToken: self.pushToken, currentPushToken: currentToken)
            self.resultHandlers.forEach({ $0(result)} )
        })
    }
        
    deinit {
        unsubscriptionCallback?()
    }
}
