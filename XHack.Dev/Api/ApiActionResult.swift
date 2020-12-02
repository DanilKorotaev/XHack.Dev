//
//  ApiActionResult.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

enum ApiActionResult {
    case successful
    case insufficientAccessRights
    case rejected
    case unauthorized
    case attentionRequired
    case localError
    case connectionError
    case serverError
    case cancelled
}


extension HTTPStatusCode {
    func toApiActionResult(_ `default`: ApiActionResult = .localError) -> ApiActionResult {
        switch self {
        case .ok, .accepted, .created,.noContent:
            return .successful
        case .requestTimeout, .serviceUnavailable, .proxyAuthenticationRequired:
            return .connectionError
        case .forbidden:
            return .insufficientAccessRights
        case .badRequest, .unsupportedMediaType, .notFound:
            return .rejected
        case .unauthorized:
            return .unauthorized
        case .notAcceptable, .conflict:
            return .attentionRequired
        case .internalServerError, .badGateway:
            return .serverError
        default:
            return `default`
        }
    }
}
