//
//  BookmarksCoordinator.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class BookmarksCoordinator: BaseCoordinator<Void> {
    
    let bookmarksViewModel: BookmarksViewModel
    let bookmarkedHacksViewModel: BookmarkedHacksViewModel
    let bookmarkedTeamsViewModel: BookmarkedTeamsViewModel
    let bookmarkedUsersViewModel: BookmarkedUsersViewModel
    
    init(bookmarksViewModel: BookmarksViewModel,
         bookmarkedHacksViewModel: BookmarkedHacksViewModel,
         bookmarkedTeamsViewModel: BookmarkedTeamsViewModel,
         bookmarkedUsersViewModel: BookmarkedUsersViewModel
    ) {
        self.bookmarksViewModel = bookmarksViewModel
        self.bookmarkedHacksViewModel = bookmarkedHacksViewModel
        self.bookmarkedTeamsViewModel = bookmarkedTeamsViewModel
        self.bookmarkedUsersViewModel = bookmarkedUsersViewModel
    }
    
    
    override func start() -> Observable<Void> {
        let viewController = BookmarksViewController.instantiate()
        viewController.dataContext = bookmarksViewModel
        
        let hackController = BookmarkedHacksViewController.instantiate()
        hackController.dataContext = bookmarkedHacksViewModel
        let hackPage = InnerPage(title: "Хакатоны", viewModel: bookmarkedHacksViewModel, view: hackController)
        
        let teamsController = BookmarkedTeamsViewController.instantiate()
        teamsController.dataContext = bookmarkedTeamsViewModel
        let teamPage = InnerPage(title: "Команды", viewModel: bookmarkedTeamsViewModel, view: teamsController)
        
        let usersController = BookmarkedUsersViewController.instantiate()
        usersController.dataContext = bookmarkedUsersViewModel
        let userPage = InnerPage(title: "Пользователи", viewModel: bookmarkedUsersViewModel, view: usersController)
        
        viewController.pages = [hackPage, teamPage, userPage]
        
        applyBindings()
        navigationController.pushViewController(viewController, animated: true)
        return Observable.empty()
    }
    
    
    private func applyBindings() {
        bookmarksViewModel.back.bind { [weak self] _ in
            self?.navigationController.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        bookmarkedHacksViewModel.hackSelect
            .subscribe(onNext: { [weak self] hack in
                self?.navigateToHackDetails(for: hack.id)
            }).disposed(by: disposeBag)
        
        bookmarkedTeamsViewModel.teamSelected.subscribe(onNext: {  [weak self] team in
            self?.toTeamProfile(for: team.id)
        }).disposed(by: disposeBag)
        
        bookmarkedUsersViewModel.memberSelected.bind { member in
            self.toUserDetails(for: member.id)
        }.disposed(by: disposeBag)
    }
}

