//
//  IErrorResult.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

protocol IErrorResult {
    var httpStatusCode: HTTPStatusCode {get}
    var errorCodes: [Int] { get }
    func getErrorDescriptions() -> [String]
}
