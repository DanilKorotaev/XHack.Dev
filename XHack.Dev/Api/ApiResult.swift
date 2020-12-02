//
//  ApiResult.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

class LiteApiResult: IApiResult {
    let status: ApiActionResult
    let errorResult: IErrorResult?
    
    init(status: ApiActionResult, errorResult: IErrorResult? = nil) {
        self.status = status
        self.errorResult = errorResult
    }
}


class ApiResult<TContent>: Response<ApiActionResult,TContent>, IApiResult {
    var errorResult: IErrorResult?
        
    init(status: ApiActionResult, content: TContent? = nil, errorResult: IErrorResult? = nil) {
        super.init(status: status, content: content)
        self.errorResult = errorResult
    }
}
