//
//  BaseViewModel+Dialogs.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import Swinject

fileprivate let DefaultClosingActionName = "ОК"
fileprivate let DefaultErrorTitle = "Ошибка"
fileprivate let SomeErrorMessage = "Произошла ошибка. Попробуйте снова или обратитесь в службу поддержки."
fileprivate let DefaultInsufficientAccessRightsTitle = "Нет прав";
fileprivate let AccessRightsRestrictedMessage = "Действие недоступно. Ваши права ограничены.";
fileprivate let DefaultNotAuthorizedTitle = "Не авторизован";
fileprivate let AuthorizationRequiredMessage = "Авторизационные данные устарели. Необходимо заново выполнить вход.";
fileprivate let DefaultConnectionFailedTitle = "Не удалось установить соединение.";
fileprivate let DefaultWarningTitle = "Внимание";
fileprivate let DefaultNoConnectionTitle = DefaultWarningTitle;
fileprivate let CheckInternetAccessMessage = "Действие не завершено или отсутствует соединение c Интернетом. Выполните операцию повторно.";
fileprivate let ServerErrorMessage = "На сервере произошла ошибка. Обратитесь в службу поддержки.";

extension BaseViewModel {
    
    func showMessage(title: String, message: String? = nil, closingActionName: String = DefaultClosingActionName) {
        
    }
    
    func showRejectedMessage(prefixMessage: String = "") {
        let errorMessage = AlertDialogMessage(title: DefaultErrorTitle, message: "\(prefixMessage) \(SomeErrorMessage)", dialogActions: [DialogActionInfo(title: DefaultClosingActionName)])
        Container.resolve(IMessager.self).publish(message: errorMessage)
    }
    
    func showAccessRightsRestrictedMessage(prefixMessage: String = "") {
        let errorMessage = AlertDialogMessage(title: DefaultInsufficientAccessRightsTitle, message: "\(prefixMessage) \(AccessRightsRestrictedMessage)", dialogActions: [DialogActionInfo(title: DefaultClosingActionName)])
        Container.resolve(IMessager.self).publish(message: errorMessage)
    }
    
    func requestAuthorization(prefixMessage: String = "") {
        let messager = Container.resolve(IMessager.self)
        let gotoAuthAction = {
            messager.publish(message: SignOutMessage())
        }
        let errorMessage = AlertDialogMessage(title: DefaultNotAuthorizedTitle, message: "\(prefixMessage) \(AuthorizationRequiredMessage)", dialogActions: [DialogActionInfo(title: "Войти", action: gotoAuthAction)])
        messager.publish(message: errorMessage)
    }
    
    func showConnectionErrorMessage(failedActionMessage: String? = nil, closeActionName: String? = nil) {
        let failedActionMessage = failedActionMessage ?? DefaultConnectionFailedTitle
        let errorMessage = AlertDialogMessage(title: DefaultNoConnectionTitle, message: "\(failedActionMessage) \(CheckInternetAccessMessage)", dialogActions: [DialogActionInfo(title: closeActionName ?? DefaultClosingActionName)])
        Container.resolve(IMessager.self).publish(message: errorMessage)
    }
    
    func showServerErrorMessage(messagePrefix: String = "") {
        let errorMessage = AlertDialogMessage(title: DefaultErrorTitle, message: "\(messagePrefix) \(ServerErrorMessage)", dialogActions: [DialogActionInfo(title: DefaultClosingActionName)])
        Container.resolve(IMessager.self).publish(message: errorMessage)
    }
    
    func createFailedActionMessage(actionName: String, suffix: String = "") -> String {
        "Не удалось \(actionName.trim()).\(suffix)"
    }
}
