//
//  UICollectionView+Extension.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 25.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        self.register(type.nib, forCellWithReuseIdentifier: type.reuseIdentifier)
    }
}
