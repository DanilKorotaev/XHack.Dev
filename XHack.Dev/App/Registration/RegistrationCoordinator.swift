import Foundation

class RegistrationCoordinator: BaseCoordinator {
    let regViewModel: RegistrationViewModel
    
    init(regVM: RegistrationViewModel) {
        regViewModel = regVM
    }
    
    override func start() {
        let viewController = RegistrationViewController.instantiate()
        viewController.viewModel = regViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
