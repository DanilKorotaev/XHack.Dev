//
//  BaseCoordinator+Navigation.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 08.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import Swinject

extension BaseCoordinator {
    func toTeamProfile(for id: Int) {
        let coordinator = Container.resolve(HackTeamDetailsCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.teamId = id
        self.start(coordinator: coordinator)
    }
    
    func toUserDetails(for id: Int) {
        let coordinator = Container.resolve(UserDetailsCoordinator.self)
        coordinator.navigationController = self.navigationController
        coordinator.userId = id
        self.start(coordinator: coordinator)
    }
    
    func navigateToBookmarks() {
        let coordinator = Container.resolve(BookmarksCoordinator.self)
        coordinator.navigationController = self.navigationController
        self.start(coordinator: coordinator)
    }
    
    func navigateToEditProfile() {
        let context = Container.resolve(IAppContext.self)
        guard let userProfile = context.currentUser else { return }
        let coordinator = Container.resolve(EditProfileCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.parameter = EditProfileParameter(userProfile: userProfile)
        start(coordinator: coordinator)
    }
    
    func navigateToHackDetails(for hackId: Int) {
        let coordinator = Container.resolve(HackathonDetailCoordinator.self)
        coordinator.navigationController = navigationController
        coordinator.hackId = hackId
        start(coordinator: coordinator)
    }
}
