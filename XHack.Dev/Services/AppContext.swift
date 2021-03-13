//
//  AppContext.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 02.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit

class AppContext: IAppContext {
    
    private let userApi: IUserApi
    private let messanger: IMessager
    
    var currentUser: UserProfile?
    
    init(userApi: IUserApi, messanger: IMessager) {
        self.messanger = messanger
        self.userApi = userApi
        _ = self.messanger.subscribe(SignOutMessage.self, completion: MessangerSubcribeComplition(comletion: { [weak self] _ in
            self?.clearContext()
        }))
        _ = self.messanger.subscribe(LoginMessage.self, completion: MessangerSubcribeComplition(comletion: { [weak self]  _ in
            self?.updateUserData().done({ _ in })
        }))
    }
    
    func updateUserData() -> Promise<Bool> {
        return Promise() { [weak self] promise in
            userApi.getProfile().done { [weak self] (result) in
                let isSuccesfull = result.status == .successful && result.content != nil
                if let profile = result.content {
                    self?.currentUser = UserProfile(profile)
                }
                promise.fulfill(isSuccesfull)
            }
        }
    }
    
    func getShortUser() -> ShortUser {
        ShortUser(id: currentUser!.id, name: currentUser!.name.value, avatarUrl: currentUser!.avatarUrl)
    }
    
    func clearContext() {
        currentUser = nil
    }
}
