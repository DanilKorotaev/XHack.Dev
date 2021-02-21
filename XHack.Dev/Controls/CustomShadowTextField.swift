//
//  CustomShadowTextField.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 21.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

class CustomShadowTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    private func setUpView() {
        borderStyle = .none
        backgroundColor = .white
        layer.cornerRadius = frame.size.height / 2
        clipsToBounds = false
        layer.masksToBounds = false
        layer.borderWidth = 0.25
        layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
        
        layer.shadowOpacity = 1
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.height))
        leftView = paddingView
        leftViewMode = UITextField.ViewMode.always
    }
}
