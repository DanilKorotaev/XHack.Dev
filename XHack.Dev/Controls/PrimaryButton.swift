//
//  PrimaryButton.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 21.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
    private let gradientView = UIView()

    private var gradient: CAGradientLayer?
    
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
        gradientView.frame = self.bounds
        gradient?.frame = self.bounds
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    private func setUpView() {
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = frame.height / 2
        clipsToBounds = false
        layer.masksToBounds = false
        gradientView.clipsToBounds = true
        gradientView.frame = self.bounds
        gradientView.layer.cornerRadius = layer.cornerRadius
        insertSubview(gradientView, at: 0)
        gradient = gradientView.applyGradient(colours: [UIColor(hex: "#FF005C"), UIColor(hex: "#F55800")])
        gradientView.isUserInteractionEnabled = false
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor(hex: "#FF005C").withAlphaComponent(0.4).cgColor
    }
}
