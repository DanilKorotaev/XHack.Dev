import Foundation
import RxSwift

class TaskDetailCoordinator: BaseCoordinator<Void> {
    
    var taskDetailViewModel: TaskDetailViewModel
    
    init(taskDetailViewModel: TaskDetailViewModel) {
        self.taskDetailViewModel = taskDetailViewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = TaskDetailViewController.instantiate()
        viewController.viewModel = taskDetailViewModel
        navigationController.pushViewController(viewController, animated: true)
        return Observable.empty()
    }
}
