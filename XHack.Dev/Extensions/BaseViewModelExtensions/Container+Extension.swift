//
//  Container+Extension.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import Swinject

extension Container {
    
    var instance: Container {
        AppDelegate.container
    }
    
    static func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = AppDelegate.container.resolve(serviceType) else {
            fatalError("Can't resolve \(serviceType)")
        }
        return service
    }
}
