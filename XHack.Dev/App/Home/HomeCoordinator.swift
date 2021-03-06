import Foundation
import RxSwift
import Swinject

class HomeCoordinator: BaseCoordinator<Void> {
    
    let homeViewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        homeViewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = HomeViewController.instantiate()
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [viewController]
        navigationController.tabBarItem = UITabBarItem(title: "home", image: #imageLiteral(resourceName: "Burger"), selectedImage: #imageLiteral(resourceName: "Burger_tap").withRenderingMode(.alwaysOriginal))
        viewController.dataContext = homeViewModel
        applyBindings()
        return Observable.empty()
    }
    
    func applyBindings() {
        homeViewModel.requestSelected.bind { [weak self] (request) in
            guard let self = self else { return}
            switch (request.type) {
            case .teamToUser:
                self.toTeamProfile(request.team.id)
            case .userToTeam:
                self.toUserProfile(request.user.id)
            default:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    func toTeamProfile(_ id: Int) {
        let coordinator = Container.resolve(HackTeamDetailsCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.teamId = id
        self.start(coordinator: coordinator)
    }
    
    func toUserProfile(_ id: Int) {
        let coordinator = Container.resolve(UserDetailsCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.userId = id
        self.start(coordinator: coordinator)
    }
}
