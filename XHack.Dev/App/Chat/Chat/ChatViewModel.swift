//
//  ChatViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class ChatViewModel: BaseViewModel {
    
    private let pageSize = 20
    private var allMessageLoaded = false
    
    let chatsApi: IChatsApi
    let context: IAppContext
    let chatProcessor: ChatProccessable
    
    let loadNext = PublishSubject<Void>()
    let isPageLoading =  BehaviorSubject<Bool>(value: false)
    
    let back = PublishSubject<Void>()
    var shortChat: ShortChat? = .none
    
    let information = PublishSubject<Void>()
    var messages = ObservableArray<ChatMessage>([])
    let sendMessage = PublishSubject<Void>()
    let messageText = BehaviorSubject<String>(value: "")
    
    init(chatsApi: IChatsApi, context: IAppContext, chatProcessor: ChatProccessable) {
        self.chatsApi = chatsApi
        self.context = context
        self.chatProcessor = chatProcessor
    }
    
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        chatProcessor.connect()
        guard let chatId = shortChat?.id, !isPageLoading.value, !isLoading.value  else {
            return
        }
        var messageId: Int? = .none
        if (operationArgs.isPaging) {
            if allMessageLoaded {
                return
            }
            messageId = messages[messages.endIndex - 1].id
            isPageLoading.onNext(true)
        } else {
            isLoading.onNext(true)
        }
        chatsApi.getHistorySince(chatId: chatId, messageId: messageId, take: pageSize).done { [weak self] (result) in
            guard let self = self else { return }
            self.isPageLoading.onNext(false)
            self.isLoading.onNext(false)
            if self.checkAndProcessApiResult(response: result, "список сообщений") {
                return
            }
            guard let messages = result.content else {
                return
            }
            self.allMessageLoaded = messages.count < self.pageSize
            let currentUserId = self.context.currentUser?.id ?? 0
            self.messages.append(contentsOf: messages.map { ChatMessage($0, isIncoming: $0.from.id != currentUserId ) })
        }
    }
    
    override func applyBinding() {
        sendMessage.bind { _ in
            guard self.messageText.value.hasNonEmptyValue() else { return }
            let message = self.messageText.value
            self.chatProcessor.sendMessage(chatId: self.shortChat!.id, message: message)
            self.messages.insert(ChatMessage(text: message, user: self.context.getShortUser()), at: 0)
            self.messageText.onNext("")
        }.disposed(by: disposeBag)
        
        chatProcessor.newMessageRecived.subscribe(onNext: { message in
            let currentUserId = self.context.currentUser?.id ?? 0
            let isIncoming = currentUserId != message.sender.id
            self.messages.insert(ChatMessage(message, isIncoming: isIncoming), at: 0)
        }).disposed(by: disposeBag)
        
        loadNext.subscribe(onNext: { _ in
            self.forceContentRefreshingAsync(operationArgs: OperationStateControl.Paging)
        }).disposed(by: disposeBag)
    }
}
