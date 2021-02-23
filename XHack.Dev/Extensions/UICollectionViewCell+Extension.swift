//
//  UICollectionViewCell+Extension.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
