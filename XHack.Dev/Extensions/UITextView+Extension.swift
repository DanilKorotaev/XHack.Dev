//
//  UITextView+Extension.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 09.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func getRequiredTextSize() -> CGSize {
        let textToMeasure = self.text ?? ""
        let horizontalInsets = self.textContainerInset.left + self.textContainerInset.right
        let verticalInsets = self.textContainerInset.top + self.textContainerInset.bottom
        var size =  NSString(string: textToMeasure)
                            .boundingRect(
                                with: CGSize(width: self.frame.width - horizontalInsets, height: CGFloat.greatestFiniteMagnitude),
                                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                attributes: [.font: self.font],
                                context: nil
                        ).size;
        size.width += horizontalInsets
        size.height += verticalInsets
        return size
    }
}
