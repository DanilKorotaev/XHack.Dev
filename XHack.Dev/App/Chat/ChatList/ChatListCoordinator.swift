import Foundation
import RxSwift

class ChatListCoordinator: BaseCoordinator<Void> {
    let viewModel: ChatListViewModel
    
    init(viewModel: ChatListViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let vc = ChatListViewController.instantiate()
        vc.dataContext = viewModel
        navigationController.viewControllers = [vc]
        return Observable.empty()
    }
}
