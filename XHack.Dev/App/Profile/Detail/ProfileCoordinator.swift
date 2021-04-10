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
        navigationController.tabBarItem = UITabBarItem(title: "Профиль", image: #imageLiteral(resourceName: "Profile"), selectedImage: #imageLiteral(resourceName: "Profile_tap").withRenderingMode(.alwaysOriginal))
        setUpBinding()
        return Observable.empty()
    }
    
    func setUpBinding() {
        viewModel.signOut .subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            self.sessionService.signOut().subscribe().disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        viewModel.teamSelected.bind { [weak self] team in
            self?.toTeamProfile(for: team.id)
        }.disposed(by: disposeBag)
        
        viewModel.bookmarks.bind { [weak self] _ in
            self?.navigateToBookmarks()
        }.disposed(by: disposeBag)
        
        viewModel.edit.subscribe(onNext: { [weak self] in
            self?.navigateToEditProfile()
        }).disposed(by: disposeBag)
    }
}
