
import Foundation
import RxSwift
import Swinject

class ChooseSearchCategoryCoordinator: BaseCoordinator<Void> {
    let viewModel: ChooseSearchCategoryViewModel
    var viewController: ChooseSearchCategoryViewController!
    
    init(viewModel: ChooseSearchCategoryViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        
        viewController = ChooseSearchCategoryViewController.instantiate()
        viewController.dataContext = viewModel
        
        applyBinding()
        
        if let window = UIApplication.shared.windows.first {
            viewController.view.alpha = 0
            window.addSubview(viewController.view)
            UIView.animate(withDuration: 0.2) {
                self.viewController.view.alpha = 1
            }
        }
        
        return Observable.empty()
    }
    
    func applyBinding() {
        viewModel.didTeamSearchRequested.subscribe(onNext: { [weak self] in
            self?.dismiss {
                self?.toTeamSearch()
            }
        })
        .disposed(by: disposeBag)
        
        viewModel.dismissRequested.subscribe(onNext: { [weak self] in
            self?.dismiss()
        })
        .disposed(by: disposeBag)
        
        viewModel.didTeammateSearchRequested.subscribe(onNext: { [weak self] in
            self?.dismiss{
                self?.toTeammateSearch()
            }
        })
        .disposed(by: disposeBag)
    }
        
    func toTeamSearch() {
        let coordinator = Container.resolve(TeamSearchCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
    }
        
    func toTeammateSearch() {
        let coordinator = Container.resolve(TeammateSearchCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func dismiss(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2) {
            self.viewController.view.alpha = 0
        } completion: { _ in
            self.viewController.view.removeFromSuperview()
            completion?()
        }
    }
}
