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
    private var messanger: IMessager!
    
    static let container = Container()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Container.loggingFunction = nil
        AppDelegate.container.registerDependencies()
        AppDelegate.container.register(MainScreeenProvider.self, factory: { (_) in self })
        messanger = AppDelegate.container.resolve(IMessager.self)!
        AppDelegate.container.resolve(IPushSubscriptionProvider.self)!.subscribeOnRecievePushNotifications { (result) in
            guard result.__conversion() else { return }
            print(result.currentPushToken!)
        }
        _ = messanger.subscribe(SignOutMessage.self, completion: MessangerSubcribeComplition<SignOutMessage>(comletion: { (message) in
            print("SignOut")
        }))
        
        _ = messanger.subscribe(LoginMessage.self, completion: MessangerSubcribeComplition<LoginMessage>(comletion: { (message) in
            print("Login")
        }) )
        
        subscribeToEvents()
        
        appCoordinator = AppDelegate.container.resolve(StartUpScreenCoordinator.self)!
        appCoordinator.start()

        return true
    }
        
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let message = PushSubscribingResultMessage(pushToken: deviceToken.base64EncodedString(), error: nil)
        messanger.publish(message: message)
    }
        
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let message = PushSubscribingResultMessage(pushToken: nil, error: error.localizedDescription)
        messanger.publish(message: message)
    }
    
    func subscribeToEvents() {
       _ = messanger.subscribe(AlertDialogMessage.self, completion: MessangerSubcribeComplition<AlertDialogMessage>(comletion: { message in
        Container.resolve(IAlertDispatcher.self).dispatch(message: message)
        }))
    }
}
