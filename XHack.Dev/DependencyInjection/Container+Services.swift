import Swinject
import SwinjectAutoregistration

extension Container {
    func registerServices() {
        autoregister(DataManager.self, initializer: UserDataManager.init).inObjectScope(.container)
        autoregister(IAlertDispatcher.self, initializer: AlertDispatcher.init).inObjectScope(.container)
        autoregister(SessionService.self, initializer: SessionService.init).inObjectScope(.container)
        autoregister(TranslationsService.self, initializer: TranslationsService.init).inObjectScope(.container)
        autoregister(HttpClient.self, initializer: HttpRequestExecutor.init).inObjectScope(.container)
        autoregister(IMessager.self, initializer: Messager.init).inObjectScope(.container)
        autoregister(IPushSubscriptionProvider.self, initializer: PushSubscriptionProvider.init).inObjectScope(.container)
        autoregister(NotificationCenter.self, initializer: {() in return NotificationCenter.default}).inObjectScope(.container)
        autoregister(IAccountSecureStorage.self, initializer: AccountSecureStorage.init).inObjectScope(.container)
    }
}
