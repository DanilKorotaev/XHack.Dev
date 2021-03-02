import Swinject

extension Container {
    func registerDependencies() {
        registerApi()
        registerServices()
        registerCoordinators()
        registerViewModels()
    }
}
