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
    var hackathonId: Int?
    
    let hackathon = BehaviorSubject<HackathonDetail?>(value: .none)
    
    init(hackathonsApi: IHackathonsApi) {
        self.hackathonsApi = hackathonsApi
    }
    
    override func refreshContent() {
        guard let hackathonId = hackathonId else {
            return
        }
        isLoading.onNext(true)
        hackathonsApi.getHackathonDetails(by: hackathonId)
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                if self.checkAndProcessApiResult(response: result, "загрузить детальную информацию") {
                    return
                }
                guard let content = result.content else { self.showMessage(title: "Ошибка", message: "Не удалось загрузить детальную информацию"); return}
                self.hackathon.onNext(HackathonDetail(content))
            })
            .disposed(by: disposeBag)
    }
}
