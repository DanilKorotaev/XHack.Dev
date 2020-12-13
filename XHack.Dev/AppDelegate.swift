import UIKit
import Swinject
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private var messanger: IMessager!
    
    static let container = Container()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Container.loggingFunction = nil
        AppDelegate.container.registerDependencies()
        
        setUpSideMenu()
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
        
        appCoordinator = AppDelegate.container.resolve(AppCoordinator.self)!
        appCoordinator.start()

        return true
    }
    
    private func setUpSideMenu() {
        // Define the menus
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: DrawerMenuViewController.instantiate())
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        leftMenuNavigationController.navigationBar.isHidden = true

        let style = SideMenuPresentationStyle.menuSlideIn
        style.backgroundColor = .black
        style.presentingEndAlpha = 0.32
        style.onTopShadowColor = .black
        style.onTopShadowRadius = 4.0
        style.onTopShadowOpacity = 0.2
        style.onTopShadowOffset = CGSize(width: 2.0, height: 0.0)

        var settings = SideMenuSettings()
        settings.presentationStyle = style
        settings.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.75), 240)
        settings.statusBarEndAlpha = 0.0

        leftMenuNavigationController.settings = settings
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
