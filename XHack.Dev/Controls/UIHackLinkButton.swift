//
//  UIHackLinkButton.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 22.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class UIHackLinkButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    override  func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    
    private func setUpView() {
        self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        setImage(#imageLiteral(resourceName: "link"), for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        setTitleColor(UIColor(hex: "#0CC5FF"), for: .normal)
        
        self.backgroundColor = .white
        layer.cornerRadius = frame.size.height / 2
        clipsToBounds = false
        layer.masksToBounds = false
        
        layer.shadowOpacity = 1
        layer.shadowRadius = frame.size.height / 3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
    }
    
    @objc
    private func tapAction(_ sender: UIButton) {
        if let urlText = self.titleLabel?.text, let url = URL(string: "https://www.\(urlText)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
