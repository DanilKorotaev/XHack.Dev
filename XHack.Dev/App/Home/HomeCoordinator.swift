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
        navigationController.tabBarItem = UITabBarItem(title: "Запросы", image: #imageLiteral(resourceName: "Burger"), selectedImage: #imageLiteral(resourceName: "Burger_tap").withRenderingMode(.alwaysOriginal))
        viewController.dataContext = homeViewModel
        applyBindings()
        return Observable.empty()
    }
    
    func applyBindings() {
        homeViewModel.requestSelected.bind { [weak self] (request) in
            guard let self = self else { return}
            switch (request.type) {
            case .teamToUser:
                self.toTeamProfile(for: request.team.id)
            case .userToTeam:
                self.toUserDetails(for: request.user.id)
            default:
                break
            }
        }.disposed(by: disposeBag)
        
        homeViewModel.SentRequest.bind { [weak self] in
            self?.navigateToSentRequest()
        }.disposed(by: disposeBag)
    }
    
    func navigateToSentRequest() {
        let coordinator = Container.resolve(SentRequestCoordinator.self)
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
}
