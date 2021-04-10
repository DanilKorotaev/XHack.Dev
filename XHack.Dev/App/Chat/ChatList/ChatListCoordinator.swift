import Foundation
import RxSwift
import Swinject

class ChatListCoordinator: BaseCoordinator<Void> {
    let viewModel: ChatListViewModel
    var mainNavigationController: UINavigationController!
    
    init(viewModel: ChatListViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let vc = ChatListViewController.instantiate()
        vc.dataContext = viewModel
        navigationController.viewControllers = [vc]
        navigationController.navigationBar.isHidden = true
        navigationController.tabBarItem = UITabBarItem(title: "Чаты", image: #imageLiteral(resourceName: "Messanger"), selectedImage: #imageLiteral(resourceName: "Messanger_tap").withRenderingMode(.alwaysOriginal))
        applyBindings()
        return Observable.empty()
    }
    
    func applyBindings() {
        viewModel.chatSelect.bind { [weak self] chat in
            self?.toChat(chat)
        }.disposed(by: disposeBag)
    }
    
    func toChat(_ chat: ShortChat) {
        let coordinator = Container.resolve(ChatCoordinator.self)
        coordinator.navigationController = mainNavigationController
        coordinator.shortChat = chat
        coordinator.start()
    }
}
