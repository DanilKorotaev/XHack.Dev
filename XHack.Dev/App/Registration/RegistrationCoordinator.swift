import Foundation
import RxSwift

class RegistrationCoordinator: BaseCoordinator<Void> {
    let viewModel: RegistrationViewModel
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = RegistrationViewController.instantiate()
        viewController.dataContext = viewModel
        applyBindings()
        navigationController.pushViewController(viewController, animated: true)
        return Observable.empty()
    }
    
    private func applyBindings() {
        viewModel.back.subscribe(onNext: {  _ in
            self.navigationController.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}
