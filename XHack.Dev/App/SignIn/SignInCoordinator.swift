import Foundation
import UIKit
import RxSwift

class SignInCoordinator: BaseCoordinator {
    private let viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() {
        let viewController = SignInViewController.instantiate()
        viewController.viewModel = viewModel
        
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.viewControllers = [viewController]
        setUpBinding()
    }
    
    func toRegistration() {
        let coordinator = AppDelegate.container.resolve(RegistrationCoordinator.self)!
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
    
    func setUpBinding() {
        viewModel.signUp
            .subscribe(onNext: { [weak self] in self?.toRegistration() })
            .disposed(by: disposeBag)
    }
}
