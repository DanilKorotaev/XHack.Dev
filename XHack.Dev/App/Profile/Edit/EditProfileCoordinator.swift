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
    private var viewController: EditProfileViewController!
    
    var parameter: EditProfileParameter?
    
    private lazy var imagePicker = {
        ImagePicker(presentationController: self.viewController, delegate: self)
    }()
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<EditProfileResult> {
        viewController = EditProfileViewController.instantiate()
        viewController.dataContext = viewModel
        viewModel.parameter = parameter
        applyBindings()
        navigationController.pushViewController(viewController, animated: true)
        return result
    }
    
    func applyBindings() {
        viewModel.chooseAvatar.bind { [weak self] _ in
            guard let self = self else { return }
            self.imagePicker.present(from: self.viewController.chooseAvatarButton)
        }.disposed(by: disposeBag)
        
        viewModel.back.bind { [weak self] _ in
            self?.navigationController.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}

extension EditProfileCoordinator: ImagePickerDelegate {
    
    func didSelect(file: File?) {
        guard let file = file else { return }
        viewModel.avatarSelected.onNext(file)
    }
}
