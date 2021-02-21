//
//  EditProfileCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 21.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

enum EditProfileResult {
    case rejected
    case successfull
}

class EditProfileCoordinator: BaseCoordinator<EditProfileResult> {
    private let result = PublishSubject<EditProfileResult>()
    private let viewModel: EditProfileViewModel
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<EditProfileResult> {
        let viewController = EditProfileViewController.instantiate()
        viewController.dataContext = viewModel
        navigationController.pushViewController(viewController, animated: true)
        return result
    }
}
