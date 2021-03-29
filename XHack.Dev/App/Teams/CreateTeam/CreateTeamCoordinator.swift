//
//  CreateTeamCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

enum CreateTeamCoordinatorResult {
    case rejected
    case teamCreated
    case teamEdited
}

struct CreateTeamParameter {
    let hackId: Int?
    let profile: TeamDetails?
    
    private init(hackId: Int?, profile: TeamDetails?) {
        self.hackId = hackId
        self.profile = profile
    }
    
    static func createForHack(id: Int) -> CreateTeamParameter {
        CreateTeamParameter(hackId: id, profile: nil)
    }
    
    static func edit(profile: TeamDetails?) -> CreateTeamParameter {
        CreateTeamParameter(hackId: nil, profile: profile)
    }
}

class CreateTeamCoordinator : BaseCoordinator<CreateTeamCoordinatorResult> {
    private let viewModel: CreateTeamViewModel
    private let result = PublishSubject<CreateTeamCoordinatorResult>()
    var hackId: Int?
    
    private var viewController: CreateTeamViewController!
    
    var parameter: CreateTeamParameter?
    
    private lazy var imagePicker = {
        ImagePicker(presentationController: self.viewController, delegate: self)
    }()
    
    
    init(viewModel: CreateTeamViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() -> Observable<CreateTeamCoordinatorResult> {
        viewController = CreateTeamViewController.instantiate()
        viewController.dataContext = viewModel
        viewModel.parameter = parameter
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(viewController, animated: true)
        setUpBinding()
        return result
    }
    
    
    func setUpBinding() {
        viewModel.teamCreated
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController.popViewController(animated: true)
                self?.result.onNext(.teamCreated)
            })
            .disposed(by: disposeBag)
        
        viewModel.teamEdited
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController.popViewController(animated: true)
                self?.result.onNext(.teamEdited)
            })
            .disposed(by: disposeBag)
        
        viewModel.chooseAvatar.bind { [weak self] _ in
            guard let self = self else { return }
            self.imagePicker.present(from: self.viewController.chooseAvatarButton)
        }.disposed(by: disposeBag)
        
        viewModel.back.subscribe(onNext: { [weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.result.onNext(.rejected)
        }).disposed(by: disposeBag)
    }
}

extension CreateTeamCoordinator: ImagePickerDelegate {
    
    func didSelect(file: File?) {
        guard let file = file else { return }
        viewModel.avatarSelected.onNext(file)
    }
}
