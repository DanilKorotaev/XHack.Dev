//
//  UITableView+Extensions.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 24.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        self.register(type.nib, forCellReuseIdentifier: type.reuseIdentifier)
    }
}
