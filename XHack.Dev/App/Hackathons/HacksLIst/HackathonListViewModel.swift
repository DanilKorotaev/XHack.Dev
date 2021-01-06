//
//  HackathonsListViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HackathonListViewModel: BaseViewModel, RefreshableContentHost {
    let refresh = PublishSubject<Void>()
    let isRefreshing = PublishSubject<Bool>()
    
    let hackathonsApi: IHackathonsApi
    let hackathons = BehaviorSubject(value: [ShortHackathon]())
    let didSelectHack = PublishSubject<ShortHackathon>()
    let seachRequsted = PublishSubject<Void>()
    
    init(hackathonsApi: IHackathonsApi) {
        self.hackathonsApi = hackathonsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        if operationArgs.isManuallyTriggered {
            isRefreshing.onNext(true)
        } else {
            isLoading.onNext(true)
        }
        
        hackathonsApi.getHackatons(by: HackathonsFilterDto())
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                self.isRefreshing.onNext(false)
                if self.checkAndProcessApiResult(response: result, "загрузить список хакатонов") {
                    return
                }
                guard let content = result.content else { self.showMessage(title: "Ошибка", message: "Не удалось загрузить список хакатонов"); return}
                self.hackathons.onNext(content.map({ShortHackathon($0)}))
            })
            .disposed(by: disposeBag)
    }
    
    override func applyBinding() {
        refresh.bind { _ in
            self.forceContentRefreshingAsync(operationArgs: OperationStateControl.ManuallyTriggered)
        }.disposed(by: disposeBag)
    }
}
