//
//  HackathonDetailViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackathonDetailViewModel: BaseViewModel {
    
    let hackathonsApi: IHackathonsApi
    var hackathonId: Int = 0
    
    let hackathon = BehaviorSubject<HackathonDetail?>(value: .none)
    let didWillGoChanged = PublishSubject<Bool>()
    let join = PublishSubject<Void>()
    let bookmark = PublishSubject<Void>()
    let back = PublishSubject<Void>()
    let memberSelected = PublishSubject<ShortUser>()
    let teamSelected = PublishSubject<ShortTeam>()
    let memberSearch = PublishSubject<Void>()
    let teamSearch = PublishSubject<Void>()
    
    init(hackathonsApi: IHackathonsApi) {
        self.hackathonsApi = hackathonsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        isLoading.onNext(true)
        hackathonsApi.getHackathonDetails(by: hackathonId)
            .done { [weak self] result in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                if self.checkAndProcessApiResult(response: result, "загрузить детальную информацию") {
                    return
                }
                guard let content = result.content else { self.showMessage(title: "Ошибка", message: "Не удалось загрузить детальную информацию"); return}
                self.hackathon.onNext(HackathonDetail(content))
            }
    }
    
    override func applyBinding() {
        didWillGoChanged.subscribe(onNext: { userWillGo in
            let changedStatus = userWillGo ? self.hackathonsApi.willGoHackathon(id: self.hackathonId) : self.hackathonsApi.willNotGoHackathon(id: self.hackathonId)
            changedStatus.done { (result) in
                if self.checkAndProcessApiResult(response: result, "") {
                    return
                }
            }
        }).disposed(by: disposeBag)
        
        join.subscribe(onNext: { [weak self] in
            self?.joinToHack()
        }).disposed(by: disposeBag)
        
        bookmark.subscribe(onNext: { [weak self] in
            self?.bookmarkHack()
        }).disposed(by: disposeBag)
    }
    
    
    private func joinToHack() {
        
    }
    
    private func bookmarkHack() {
        
    }
}
