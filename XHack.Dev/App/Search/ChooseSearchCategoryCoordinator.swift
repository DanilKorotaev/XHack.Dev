
import Foundation
import RxSwift

class ChooseSearchCategoryCoordinator: BaseCoordinator<Void> {
    let viewModel: ChooseSearchCategoryViewModel
    var viewController: ChooseSearchCategoryViewController!
    
    init(viewModel: ChooseSearchCategoryViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        
        viewController = ChooseSearchCategoryViewController.instantiate()
        viewController.dataContext = viewModel
        
        return Observable.empty()
    }
}
