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
    
    init(endpoints: ApiEndpoints, apiTokensHolder: IApiTokensHolder) {
        self.apiTokensHolder = apiTokensHolder
        manager = SocketManager(socketURL: URL(string: endpoints.chatSocketIoUrl)!, config: [.log(true), .compress, .extraHeaders(["Authorization": self.apiTokensHolder.accessToken])])
         socket = manager.defaultSocket
    }
    
    func connect() {
        if !isConnected {
            socket.connect()
            subscribeEvents()
        }        
    }
    
    func subscribeEvents() {
        socket.removeAllHandlers()
        socket.on(clientEvent: .connect) { (_, _) in
            self.socket.emit(ClientEvents.authorize.rawValue, ["token" : self.apiTokensHolder.accessToken])
        }
        socket.on(clientEvent: .disconnect) { (_, _) in
            self.isConnected = false
        }
        socket.on(ServerEvents.newMessage.rawValue) { (data, _) in
            if let jsonData = (data[0]) as? [String: Any], let message = jsonData.convert(NewMessageData.self){
                self.newMessageRecived.onNext(message)
            }
        }
        socket.on(ServerEvents.readChat.rawValue) { (data, _) in
            if let jsonData = (data[0]) as? [String: Any], let readChat = jsonData.convert(ReadChatData.self){
                self.readChatRecived.onNext(readChat)
            }
        }
    }
    
    func sendMessage(chatId: Int? = .none, message: String, guid: UUID, teamId: Int? = .none, secondUserId: Int? = .none) {
        socket.emit(ClientEvents.sendMessage.rawValue, SendMessageData(chatId: chatId, message: message, teamId: teamId, secondUserId: secondUserId, guid: guid))
    }
    
    func readMessage(chatId: Int, messageId: Int) {
        socket.emit(ClientEvents.readMessage.rawValue, ReadMessageData(chatId: chatId, messageId: messageId))
    }
}
