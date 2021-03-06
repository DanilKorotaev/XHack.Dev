
import Foundation
import RxSwift

class ChatListViewModel: BaseViewModel, RefreshableContentHost {
    
    let chatsApi: IChatsApi
    
    var refresh =  PublishSubject<Void>()
    var isRefreshing = PublishSubject<Bool>()
    
    let chats = BehaviorSubject<[ShortChat]>(value: [])
    let chatSelect = PublishSubject<ShortChat>()
    
    init(chatsApi: IChatsApi) {
        self.chatsApi = chatsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        if operationArgs.isManuallyTriggered {
            isRefreshing.onNext(true)
        } else {
            isLoading.onNext(true)
        }
        
        chatsApi.getChats().done { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading.onNext(false)
            self.isRefreshing.onNext(false)
            if self.checkAndProcessApiResult(response: result, "загрузить список чатов") {
                return
            }
            guard let chats = result.content else { return }
            self.chats.onNext(chats.map { ShortChat($0) })
        }
    }
    
    override func applyBinding() {
        refresh.bind { [weak self] in
            self?.forceContentRefreshingAsync(operationArgs: OperationStateControl.ManuallyTriggered)
        }.disposed(by: disposeBag)
    }
    
    
}
