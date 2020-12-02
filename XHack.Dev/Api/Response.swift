//
//  Response.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

class Response<TStatus, TContent>  {
    let status: TStatus
    let content: TContent?
    
    init(status: TStatus, content: TContent? = nil) {
        self.status = status
        self.content = content
    }
}
