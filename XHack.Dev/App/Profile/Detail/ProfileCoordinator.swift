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
        
        viewModel.teamSelected.bind { [weak self] team in
            self?.toTeamProfile(for: team.id)
        }.disposed(by: disposeBag)
        
        viewModel.edit
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.editProfile()
            })
            .disposed(by: disposeBag)
    }
    
    func editProfile() {
        guard let userProfile = viewModel.profile.value else { return }
        let coordinator = Container.resolve(EditProfileCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.parameter = EditProfileParameter(userProfile: userProfile)
        start(coordinator: coordinator)
    }
}
