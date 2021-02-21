//
//  SecondaryButton.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 21.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class SecondaryButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    private func setUpView() {
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .white
        layer.cornerRadius = frame.size.height / 2
        clipsToBounds = false
        layer.masksToBounds = false
        
        layer.shadowOpacity = 1
        layer.shadowRadius = frame.size.height / 2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
    }
}
