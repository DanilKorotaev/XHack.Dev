//
//  UITableViewCell+Extensions.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 22.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
