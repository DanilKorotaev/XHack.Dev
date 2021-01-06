import Foundation
import RxSwift

class ProfileCoordinator: BaseCoordinator<Void> {
    let viewModel: ProfileViewModel
    let sessionService: SessionService
    
    init(viewModel: ProfileViewModel, sessionService: SessionService) {
        self.viewModel = viewModel
        self.sessionService = sessionService
    }
    
    override func start() -> Observable<Void> {
        let viewController = ProfileViewController.instantiate()
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [viewController]
        viewController.dataContext = viewModel
        setUpBinding()
        return Observable.empty()
    }
    
    func setUpBinding() {
        viewModel.signOut
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.sessionService.signOut().subscribe().disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
