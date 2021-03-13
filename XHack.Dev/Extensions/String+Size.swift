//
//  String+Size.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func getRequiredTextSize(_ font: UIFont, _ width: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        let size =  NSString(string: self)
                            .boundingRect(
                                with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                attributes: [.font: font],
                                context: nil
                        ).size;
        return size
    }
}
