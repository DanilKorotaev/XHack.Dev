import Foundation
import UIKit
import RxSwift

class SettingsCoordinator: BaseCoordinator<Void> {
    private let settingsViewModel: SettingsViewModel
    
    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = SettingsViewController.instantiate()
        viewController.viewModel = settingsViewModel
        
        navigationController.viewControllers = [viewController]
        return Observable.empty()
    }
}
