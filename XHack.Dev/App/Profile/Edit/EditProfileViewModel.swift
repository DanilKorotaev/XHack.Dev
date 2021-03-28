//
//  EditProfileViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 21.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

struct EditProfileParameter {
    let userProfile: UserProfile
}

class EditProfileViewModel: BaseViewModel {
    
    let userApi: IUserApi
    let filesApi: IFilesApi
    let messager: IMessager
    
    var parameter: EditProfileParameter?
    
    let chooseAvatar = PublishSubject<Void>()
    let avatarUrl = BehaviorSubject<String>(value: "")
    let name = BehaviorSubject<String>(value: "")
    let description = BehaviorSubject<String>(value: "")
    let specialization = BehaviorSubject<String>(value: "")
    var networks = ObservableArray<BehaviorSubject<String>>([])
    let addNetwork = PublishSubject<Void>()
    let email = BehaviorSubject<String>(value: "")
    var tags = ObservableArray<Tag>([])
    let searchableState = BehaviorSubject<Bool>(value: false)
    
    let avatarSelected = PublishSubject<File>()
    let save = PublishSubject<Void>()
    let back = PublishSubject<Void>()

    init(userApi: IUserApi, filesApi: IFilesApi, messager: IMessager) {
        self.userApi = userApi
        self.filesApi = filesApi
        self.messager = messager
    }
    
    override func initialize() {
        guard let user = parameter?.userProfile else {
            fatalError("parameter should be initialize")
        }
        email.onNext(user.email.value)
        name.onNext(user.name.value)
        avatarUrl.onNext(user.avatarUrl)
        description.onNext(user.description.value)
        specialization.onNext(user.specialization.value)
        networks.append(contentsOf: user.networks.map { BehaviorSubject(value: $0) })
        tags.append(contentsOf: user.tags)
        searchableState.onNext(user.isAvailableForSearching.value)
        super.initialize()
    }
    
    override func applyBinding() {
        avatarSelected.bind { [weak self] file in
            self?.uploadAvatar(file: file)
        }.disposed(by: disposeBag)
        
        save.bind { [weak self]  file in
            self?.updateProfile()
        }.disposed(by: disposeBag)
        
        searchableState
            .skip(2)
            .bind { [weak self] active in
            self?.userApi.setSearchingStatus(active).done { [weak self] (result) in
                self?.checkAndProcessApiResult(response: result, "обновить статус")
            }
        }.disposed(by: disposeBag)
        
        addNetwork.bind { [weak self] _ in
            self?.networks.append(BehaviorSubject<String>(value: ""))
        }.disposed(by: disposeBag)
    }
    
    private func uploadAvatar(file: File) {
        self.isLoading.onNext(true)
        self.filesApi.uploadFile(file: file).done { (result) in
            self.isLoading.onNext(false)
            if self.checkAndProcessApiResult(response: result, "загрузить аватарку") {
                return
            }
            guard let fileContentUrl = result.content  else { return }
            self.avatarUrl.onNext(fileContentUrl.image_url)
        }
    }
    
    private func updateProfile() {
        let networks = self.networks.elements.map { $0.value }.filter { $0.hasNonEmptyValue()}
        let updateDate = UpdateProfileDtoRequest(name: name.value, specialization: specialization.value, avatarUrl: avatarUrl.value, description: description.value, email: email.value, networks: networks)
        userApi.updateProfile(updateDate).done { [weak self] (result) in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "обновить данные профиля") {
                return
            }
            self.messager.publish(message: UpdatedProfileMessage())
            self.back.onNext(())
        }
    }
}

