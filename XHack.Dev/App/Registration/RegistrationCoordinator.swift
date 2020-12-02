import Foundation
import RxSwift

class RegistrationCoordinator: BaseCoordinator<Void> {
    let regViewModel: RegistrationViewModel
    
    init(regVM: RegistrationViewModel) {
        regViewModel = regVM
    }
    
    override func start() -> Observable<Void> {
        let viewController = RegistrationViewController.instantiate()
        viewController.viewModel = regViewModel
        navigationController.pushViewController(viewController, animated: true)
        return Observable.empty()
    }
}
