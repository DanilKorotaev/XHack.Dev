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
    
    private var chatProccessorDisposeBag: DisposeBag?
    
    let chatsApi: IChatsApi
    let context: IAppContext
    let chatProcessor: ChatProccessable
    
    let loadNext = PublishSubject<Void>()
    let isPageLoading =  BehaviorSubject<Bool>(value: false)
    
    let back = PublishSubject<Void>()
    let chatLeaved = PublishSubject<Void>()
    let chatRemoved = PublishSubject<Void>()
    
    var shortChat: ShortChat? = .none
    
    let information = PublishSubject<Void>()
    var messages = ObservableArray<ChatMessage>([])
    let sendMessage = PublishSubject<Void>()
    let messageText = BehaviorSubject<String>(value: "")
    
    private(set) var resultStatus = ChatResult.nothingChanged
    
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
            guard let messagesDto = result.content else {
                return
            }
            let currentUserId = self.context.currentUser?.id ?? 0
            let messages = messagesDto.map { ChatMessage($0, isIncoming: $0.from.id != currentUserId ) }
            self.allMessageLoaded = messages.count < self.pageSize
            self.messages.append(contentsOf: messages)
            if !operationArgs.isPaging, let lastMessageId = messages.first?.id {
                self.readMessage(lastMessageId)
            }
        }
    }
    
    override func applyBinding() {
        sendMessage.bind { _ in
            guard self.messageText.value.hasNonEmptyValue() else { return }
            let message = self.messageText.value
            let messageGuid = UUID()
            self.chatProcessor.sendMessage(chatId: self.shortChat?.id,
                                           message: message,
                                           guid: messageGuid,
                                           teamId: self.shortChat?.team?.id,
                                           secondUserId: self.shortChat?.secondUser?.id)
            self.messages.insert(ChatMessage(text: message, guid: messageGuid, user: self.context.getShortUser()), at: 0)
            self.messageText.onNext("")
        }.disposed(by: disposeBag)
        
        
        loadNext.subscribe(onNext: { _ in
            self.forceContentRefreshingAsync(operationArgs: OperationStateControl.Paging)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear() {
        subscribeToChatProccessor()
    }
    
    override func viewDidDisappear() {
        unsubscribeFromChatProccessor()
    }
    
    private func subscribeToChatProccessor() {
        chatProccessorDisposeBag = DisposeBag()
        chatProcessor.newMessageRecived.subscribe(onNext: { message in
            guard var shortChat = self.shortChat  else { return }
            if shortChat.id == nil && self.messages.contains(where: {$0.guid == message.guid}) {
                shortChat.update(message)
                self.resultStatus = .chatCreated
            }
            guard shortChat.id == message.chatId,
                  !self.messages.contains(where: {$0.guid == message.guid}) else { return }
           
            let currentUserId = self.context.currentUser?.id ?? 0
            let isIncoming = currentUserId != message.sender.id
            self.messages.insert(ChatMessage(message, isIncoming: isIncoming), at: 0)
            self.readMessage(message.id)
        }).disposed(by: chatProccessorDisposeBag!)
        
        chatProcessor.chatLeaved.subscribe(onNext: { [weak self] message in
            guard let self = self, let chatId = self.shortChat?.id, chatId == message.chatId else { return }
            self.showMessage(title: "Внимание", message: "Вас исключили из чата")
            self.chatLeaved.onNext(())
        }).disposed(by: chatProccessorDisposeBag!)
        
        chatProcessor.chatRemoved.subscribe(onNext: { [weak self] message in
            guard let self = self, let chatId = self.shortChat?.id, chatId == message.chatId else { return }
            self.showMessage(title: "Внимание", message: "Чат удален")
            self.chatRemoved.onNext(())
        }).disposed(by: chatProccessorDisposeBag!)
    }
    
    private func unsubscribeFromChatProccessor() {
        chatProccessorDisposeBag = nil
    }
    
    private func readMessage(_ id: Int) {
        guard let chatId =  shortChat?.id else {
            return
        }
        chatProcessor.readMessage(chatId: chatId, messageId: id)
    }
}
