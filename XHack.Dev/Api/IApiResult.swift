//
//  IApiResult.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

protocol IApiResult {
    var status: ApiActionResult { get }
    var errorResult: IErrorResult? { get }
}
