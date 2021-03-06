//
//  ChatCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class ChatCoordinator: BaseCoordinator<Void> {
    let viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<Void> {
        let viewController = ChatViewController.instantiate()
        viewController.dataContext = viewModel
        navigationController.pushViewController(viewController, animated: true)
        applyBindings()
        
        return Observable.empty()
    }
    
    private func applyBindings() {
        
    }
}
