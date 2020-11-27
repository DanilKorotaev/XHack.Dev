import Foundation

class ProfileCoordinator: BaseCoordinator {
    let viewModel: ProfileViewModel
    let sessionService: SessionService
    
    init(viewModel: ProfileViewModel, sessionService: SessionService) {
        self.viewModel = viewModel
        self.sessionService = sessionService
    }
    
    override func start() {
        let viewController = ProfileViewController.instantiate()
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [viewController]
        viewController.viewModel = viewModel
        setUpBinding()
    }
    
    func setUpBinding() {
        viewModel.signOut
            .subscribe(onNext: { [weak self] in
                _ = self?.sessionService.signOut()
            })
            .disposed(by: disposeBag)
    }
}
