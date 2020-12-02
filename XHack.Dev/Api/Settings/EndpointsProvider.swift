//
//  EndpointsProvider.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation

class EndpointsProvider: ApiEndpoints {
    
    var gatewayUrl: String {
        endpoints.gatewayUrl
    }
    
    private let endpoints: ApiEndpoints
    
    init() {
        endpoints = TestEndpoints()
    }
}
