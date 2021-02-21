import Foundation
import RxSwift
import Swinject

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
        navigationController.tabBarItem = UITabBarItem(title: "profile", image: #imageLiteral(resourceName: "Profile"), selectedImage: #imageLiteral(resourceName: "Profile_tap").withRenderingMode(.alwaysOriginal))
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
        
        viewModel.edit
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.editProfile()
            })
            .disposed(by: disposeBag)
    }
    
    func editProfile() {
        var coordinator = Container.resolve(EditProfileCoordinator.self)
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
}
