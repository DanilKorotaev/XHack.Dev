import UIKit
import Swinject
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MainScreeenProvider {
    
    var navigationController: UINavigationController {
        let rootViewController = UIApplication.shared.windows[0].rootViewController
        if let navController = rootViewController as? UINavigationController {
            return navController
        }
        
        return rootViewController!.navigationController!
    }
    
    var window: UIWindow?
    
    private var appCoordinator: StartUpScreenCoordinator!
    private lazy var messanger: IMessager = {
        Container.resolve(IMessager.self)
    }()
    
    private lazy var pushProcessor: PushProcessable = {
        Container.resolve(PushProcessable.self)
    }()
    
    
    static let container = Container()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Container.loggingFunction = nil
        AppDelegate.container.registerDependencies()
        AppDelegate.container.register(MainScreeenProvider.self, factory: { (_) in self })
        
        subscribeToEvents()
        
        appCoordinator = Container.resolve(StartUpScreenCoordinator.self)
        appCoordinator.start()
        
        if launchOptions != nil {
            if let remoteNotification = launchOptions![.remoteNotification] as? [AnyHashable : Any],
              let pushData = pushProcessor.process(data: remoteNotification, completionHandler: nil) {
                appCoordinator.navigateToProperScreen(by: pushData)
            }
        }
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .active {
            return
        }
        guard let pushData = pushProcessor.process(data: userInfo, completionHandler: completionHandler) else {
            return;
        }
        appCoordinator.navigateToProperScreen(by: pushData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        let message = PushSubscribingResultMessage(pushToken: deviceTokenString, error: nil)
        messanger.publish(message: message)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let message = PushSubscribingResultMessage(pushToken: nil, error: error.localizedDescription)
        messanger.publish(message: message)
    }
    
    func subscribeToEvents() {
        _ = messanger.subscribe(AlertDialogMessage.self, completion: MessangerSubcribeComplition (comletion: { message in
            Container.resolve(IAlertDispatcher.self).dispatch(message: message)
        }))
        
        _ = messanger.subscribe(SignOutMessage.self, completion: MessangerSubcribeComplition (comletion: { (message) in
            Container.resolve(IPushSubscriptionManager.self)
                .unsubscribeFromPushNotifications()
        }))
        
        _ = messanger.subscribe(LoginMessage.self, completion: MessangerSubcribeComplition(comletion: { (message) in
            Container.resolve(IPushSubscriptionManager.self)
                .subscribeOnPushNotifications()
        }) )
    }
}
