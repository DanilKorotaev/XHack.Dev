//
//  RequestSection.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 01.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxDataSources

class RequestSection: SectionModelType {
    var items: [IncomingRequest]
    
    required init(original: RequestSection, items: [IncomingRequest]) {
//        self = original
        self.items = items
        self.title = original.title
        self.data = items
    }
    
    typealias Item = IncomingRequest
    
    let title: String
    let data: [IncomingRequest]
    var isCollapsed: Bool = true
    
    init(_ title: String, _ data: [IncomingRequest]) {
        self.title = title
        self.data = data
        self.items = data
    }
}
