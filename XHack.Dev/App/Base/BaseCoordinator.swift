import Foundation
import UIKit
import RxSwift

//protocol Coordinator<CoordinationResult>: AnyObject {
//    associatedtype CoordinationResult
//    var navigationController: UINavigationController { get set }
////    var parentCoordinator: Coordinator? { get set }
//    var identifier : UUID { get }
//    func start()
//    func start<T>(coordinator: Coordinator<T>) ->
//    func didFinish(coordinator: Coordinator)
//    func removeChildCoordinators()
//}

class BaseCoordinator<ResultType>: NSObject {
    public typealias CoordinationResult = ResultType
    
    var navigationController = UINavigationController()
//    var childCoordinators = [Coordinator]()
//    var parentCoordinator: Coordinator?
    private let identifier = UUID()
    let disposeBag = DisposeBag()
    
    private var childCoordinators = [UUID: Any]()
    
    @discardableResult
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
    
    @discardableResult
    func start<T>(coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.release(coordinator: coordinator) })
    }
    
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func release<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    
//    func removeChildCoordinators() {
//        childCoordinators.forEach { $0.removeChildCoordinators() }
//        childCoordinators.removeAll()
//    }
//
//    func didFinish(coordinator: Coordinator) {
//        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
//            childCoordinators.remove(at: index)
//        }
//    }
}
