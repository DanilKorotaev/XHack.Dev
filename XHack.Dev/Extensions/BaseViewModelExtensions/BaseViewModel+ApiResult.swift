//
//  BaseViewModel+ApiResult.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

extension BaseViewModel {
    func checkAndProcessApiResult(response: IApiResult, _ actionName: String = "") -> Bool {
        switch response.status {
        case .insufficientAccessRights:
            let messageAccesRightPrefix: String = actionName.hasNonEmptyValue() ? createFailedActionMessage(actionName: actionName, suffix: " ") : "";
            showAccessRightsRestrictedMessage(prefixMessage: messageAccesRightPrefix)
            return true
        case .unauthorized:
            if actionName.hasNonEmptyValue() {
                requestAuthorization(prefixMessage: createFailedActionMessage(actionName: actionName, suffix: " "))
            } else {
                requestAuthorization()
            }
            return true
        case .attentionRequired:
            
            return true
        case .localError, .rejected:
            let messagePrefix: String = actionName.hasNonEmptyValue() ? createFailedActionMessage(actionName: actionName, suffix: " ") : "";
            showRejectedMessage(prefixMessage: messagePrefix)
            return true
        case .connectionError:
            if actionName.hasNonEmptyValue() {
                showConnectionErrorMessage(failedActionMessage: createFailedActionMessage(actionName: actionName, suffix: " "))
            } else {
                showConnectionErrorMessage()
            }
            return true
        case .serverError:
            if actionName.hasNonEmptyValue() {
                showServerErrorMessage(messagePrefix: createFailedActionMessage(actionName: actionName, suffix: " "))
            } else {
                showServerErrorMessage()
            }
            return true
        default:
            return false
        }
    }
}
