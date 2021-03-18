
import Foundation
import RxSwift

class ChatListViewModel: BaseViewModel, RefreshableContentHost {
    
    let chatsApi: IChatsApi
    let chatProcessor: ChatProccessable
    let context: IAppContext
    
    let refresh =  PublishSubject<Void>()
    let isRefreshing = BehaviorSubject<Bool>(value: false)
    let loadNextPage =  PublishSubject<Void>()
    let isPageLoading = BehaviorSubject<Bool>(value: false)
    
    var chats = ObservableArray<ShortChat>([])
    let chatSelect = PublishSubject<ShortChat>()
    
    init(chatsApi: IChatsApi, chatProcessor: ChatProccessable, context: IAppContext) {
        self.chatsApi = chatsApi
        self.chatProcessor = chatProcessor
        self.context = context
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        chatProcessor.connect()
        if operationArgs.isManuallyTriggered {
            isRefreshing.onNext(true)
        } else if operationArgs.isPaging {
            isPageLoading.onNext(true)
        }
        else {
            isLoading.onNext(true)
        }
        
        chatsApi.getChats().done { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading.onNext(false)
            self.isPageLoading.onNext(false)
            self.isRefreshing.onNext(false)
            if self.checkAndProcessApiResult(response: result, "загрузить список чатов") {
                return
            }
            if !operationArgs.isPaging {
                self.chats.removeAll()
            }
            guard let chatsDto = result.content else { return }
            let chats = chatsDto.map { ShortChat($0) }
            self.chats.append(contentsOf: chats)
        }
    }
    
    override func applyBinding() {
        refresh.bind { [weak self] in
            self?.forceContentRefreshingAsync(operationArgs: OperationStateControl.ManuallyTriggered)
        }.disposed(by: disposeBag)
        
        chatProcessor.newMessageRecived.subscribe(onNext: { message in
            guard let chat = self.chats.first(where: { $0.id == message.chatId}), let currentUserId = self.context.currentUser?.id else { return }
            chat.update(ShortChatMessage(message), isCurrentUser: currentUserId == message.sender.id)
            self.chats.sort()
        }).disposed(by: disposeBag)
        
        chatProcessor.readChatRecived.subscribe(onNext: { readChat in
            guard let chat =  self.chats.first(where: { $0.id == readChat.chatId}) else { return }
            chat.update(readChat)
        }).disposed(by: disposeBag)
        
        loadNextPage.bind {[weak self] in
            self?.forceContentRefreshingAsync(operationArgs: OperationStateControl.Paging)
        }.disposed(by: disposeBag)
    }    
}
