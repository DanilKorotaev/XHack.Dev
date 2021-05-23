//
//  ChatProcessor.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 10.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import SocketIO
import RxSwift

class ChatProcessor: ChatProccessable {

    let apiTokensHolder: IApiTokensHolder
    let manager : SocketManager
    let socket: SocketIOClient
    var isConnected: Bool = false
    let newMessageRecived = PublishSubject<NewMessageData>()
    let readChatRecived = PublishSubject<ReadChatData>()
    let chatLeaved = PublishSubject<ChatLeavedData>()
    let chatRemoved = PublishSubject<ChatRemovedData>()
    
    init(endpoints: ApiEndpoints, apiTokensHolder: IApiTokensHolder, messager: IMessager) {
        self.apiTokensHolder = apiTokensHolder
        manager = SocketManager(socketURL: URL(string: endpoints.chatSocketIoUrl)!, config: [.log(true), .compress, .extraHeaders(["Authorization": self.apiTokensHolder.accessToken])])
         socket = manager.defaultSocket
        _ = messager.subscribe(SignOutMessage.self, completion: MessangerSubcribeComplition { [weak self] message in
            self?.disconnect()
        })
    }
    
    func connect() {
        if !isConnected {
            socket.connect()
            subscribeEvents()
        }        
    }
    
    func disconnect() {
        if isConnected {
            return
        }
        socket.disconnect()
        socket.removeAllHandlers()
    }
    
    func subscribeEvents() {
        socket.removeAllHandlers()
        socket.on(clientEvent: .connect) { (_, _) in
            self.socket.emit(ClientEvents.authorize, ["token" : self.apiTokensHolder.accessToken])
        }
        socket.on(clientEvent: .disconnect) { (_, _) in
            self.isConnected = false
        }
        socket.on(ServerEvents.newMessage) { (data, _) in
            if let jsonData = (data[0]) as? [String: Any], let message = jsonData.convert(NewMessageData.self){
                self.newMessageRecived.onNext(message)
            }
        }
        socket.on(ServerEvents.readChat) { (data, _) in
            if let jsonData = (data[0]) as? [String: Any], let readChat = jsonData.convert(ReadChatData.self){
                self.readChatRecived.onNext(readChat)
            }
        }
        socket.on(ServerEvents.chatLeaved) { (data, _) in
            if let jsonData = (data[0]) as? [String: Any], let leavedChat = jsonData.convert(ChatLeavedData.self){
                self.chatLeaved.onNext(leavedChat)
            }
        }
        socket.on(ServerEvents.chatRemoved) { (data, _) in
            if let jsonData = (data[0]) as? [String: Any], let removedChat = jsonData.convert(ChatRemovedData.self){
                self.chatRemoved.onNext(removedChat)
            }
        }
    }
    
    func sendMessage(chatId: Int? = .none, message: String, guid: UUID, teamId: Int? = .none, secondUserId: Int? = .none) {
        socket.emit(ClientEvents.sendMessage, SendMessageData(chatId: chatId, message: message, teamId: teamId, secondUserId: secondUserId, guid: guid))
    }
    
    func readMessage(chatId: Int, messageId: Int) {
        socket.emit(ClientEvents.readMessage, ReadMessageData(chatId: chatId, messageId: messageId))
    }
}
