
import Foundation

class TaskDetailCoordinator: BaseCoordinator {
    
    var taskDetailViewModel: TaskDetailViewModel
    
    init(taskDetailViewModel: TaskDetailViewModel) {
        self.taskDetailViewModel = taskDetailViewModel
    }
    
    override func start() {
        let viewController = TaskDetailViewController.instantiate()
        viewController.viewModel = taskDetailViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
