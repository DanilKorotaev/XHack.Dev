import Foundation
import UIKit
import RxSwift

class DashboardCoordinator: BaseCoordinator<Void> {
    private let dashboardViewModel: DashboardViewModel
    private let dataManager: DataManager
        
    init(dashboardViewModel: DashboardViewModel, dataManager: DataManager) {
        self.dashboardViewModel = dashboardViewModel
        self.dataManager = dataManager
    }
    
    override func start() -> Observable<Void> {
        let viewController = DashboardViewController.instantiate()
        viewController.viewModel = dashboardViewModel
        
        navigationController.viewControllers = [viewController]
        setUpBindings()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showOnBoardingIfNeeded()
        }
        return Observable.empty()
    }
    
    private func setUpBindings() {
        dashboardViewModel.didSelectTask
            .subscribe(onNext: { [weak self] task in self?.didSelect(task: task) })
            .disposed(by: disposeBag)
    }
    
    func showOnBoardingIfNeeded() {
        guard dataManager.get(key: SettingKey.onBoardingData, type: OnBoardingData.self) == nil else { return }
        
        let coordinator = AppDelegate.container.resolve(OnBoardingCoordinator.self)!
        coordinator.navigationController = navigationController
        
        start(coordinator: coordinator).subscribe().disposed(by: disposeBag)
    }
        
    func didSelect(task: String) {
        let coordinator = AppDelegate.container.resolve(TaskDetailCoordinator.self)!
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
}
