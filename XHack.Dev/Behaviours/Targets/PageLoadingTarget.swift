//
//  PageLoadingTarget.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

protocol PageLoadingTarget {
    var isLoading: Bool { get set }
    var scrollView: UIScrollView { get }
}
