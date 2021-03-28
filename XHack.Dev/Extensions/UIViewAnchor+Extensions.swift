//
//  UIViewAnchor+Extensions.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

enum AnchorType {
    case equal
    case greaterThan
    case lessThan
}

extension UIView {
    
    func joinAnchors<TAnchor: NSObject>(selfAnchor: NSLayoutAnchor<TAnchor>, targetAnchor: NSLayoutAnchor<TAnchor>, constant: CGFloat = 0, type: AnchorType = .equal) {
        self.prepareView()
        let constraint: NSLayoutConstraint
        switch type {
        case .equal:
            constraint = selfAnchor.constraint(equalTo: targetAnchor, constant: constant)
        case .greaterThan:
            constraint = selfAnchor.constraint(greaterThanOrEqualTo: targetAnchor, constant: constant)
        case .lessThan:
            constraint = selfAnchor.constraint(lessThanOrEqualTo: targetAnchor, constant: constant)
        }
        constraint.isActive = true
    }
    
    func joinAnchors(selfAnchor: NSLayoutDimension, targetAnchor: NSLayoutDimension, multiplier: CGFloat = 0, constant: CGFloat = 0, type: AnchorType = .equal) {
        self.prepareView()
        let constraint: NSLayoutConstraint
        switch type {
        case .equal:
            if multiplier != 0 && constant != 0 {
                constraint = selfAnchor.constraint(equalTo: targetAnchor, multiplier: multiplier, constant: constant)
            } else if multiplier != 0  {
                constraint = selfAnchor.constraint(equalTo: targetAnchor, multiplier: multiplier)
            } else {
                constraint = selfAnchor.constraint(equalTo: targetAnchor)
            }
        case .greaterThan:
            if multiplier != 0 && constant != 0 {
                constraint = selfAnchor.constraint(greaterThanOrEqualTo: targetAnchor, multiplier: multiplier, constant: constant)
            } else if multiplier != 0  {
                constraint = selfAnchor.constraint(greaterThanOrEqualTo: targetAnchor, multiplier: multiplier)
            } else {
                constraint = selfAnchor.constraint(greaterThanOrEqualTo: targetAnchor)
            }
        case .lessThan:
            if multiplier != 0 && constant != 0 {
                constraint = selfAnchor.constraint(lessThanOrEqualTo: targetAnchor, multiplier: multiplier, constant: constant)
            } else if multiplier != 0  {
                constraint = selfAnchor.constraint(lessThanOrEqualTo: targetAnchor, multiplier: multiplier)
            } else {
                constraint = selfAnchor.constraint(lessThanOrEqualTo: targetAnchor)
            }
        }
        constraint.isActive = true
    }
    
    
    func joinAnchors(selfAnchor: NSLayoutDimension, constant: CGFloat = 0, type: AnchorType = .equal) {
        self.prepareView()
        let constraint: NSLayoutConstraint
        switch type {
        case .equal:
            constraint = selfAnchor.constraint(equalToConstant: constant)
        case .greaterThan:
            constraint = selfAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThan:
            constraint = selfAnchor.constraint(lessThanOrEqualToConstant: constant)
        }
        constraint.isActive = true
    }
    
    
    func joinLeft(of targetView: UIView, contant: CGFloat = 0, type: AnchorType = .equal) {
        if self.superview == targetView {
            self.joinAnchors(selfAnchor: self.leftAnchor, targetAnchor: targetView.leftAnchor, constant: contant, type: type)
        } else {
            self.joinAnchors(selfAnchor: self.rightAnchor, targetAnchor: targetView.leftAnchor, constant: -contant, type: type)
        }
    }
    
    func joinRight(of targetView: UIView, contant: CGFloat = 0, type: AnchorType = .equal) {
        if self.superview == targetView {
            self.joinAnchors(selfAnchor: self.rightAnchor, targetAnchor: targetView.rightAnchor, constant: -contant, type: type)
        } else {
            self.joinAnchors(selfAnchor: self.leftAnchor, targetAnchor: targetView.rightAnchor, constant: contant, type: type)
        }
    }
    
    func joinTop(of targetView: UIView, contant: CGFloat = 0, type: AnchorType = .equal) {
        if self.superview == targetView {
            self.joinAnchors(selfAnchor: self.topAnchor, targetAnchor: targetView.topAnchor, constant: contant, type: type)
        } else {
            self.joinAnchors(selfAnchor: self.bottomAnchor, targetAnchor: targetView.topAnchor, constant: -contant, type: type)
        }
    }
    
    func joinBottom(of targetView: UIView, contant: CGFloat = 0, type: AnchorType = .equal) {
        if self.superview == targetView {
            self.joinAnchors(selfAnchor: self.bottomAnchor, targetAnchor: targetView.bottomAnchor, constant: contant, type: type)
        } else {
            self.joinAnchors(selfAnchor: self.topAnchor, targetAnchor: targetView.bottomAnchor, constant: -contant, type: type)
        }
    }
    
    func joinCenterX(of targetView: UIView, contant: CGFloat = 0, type: AnchorType = .equal) {
        self.joinAnchors(selfAnchor: self.centerXAnchor, targetAnchor: targetView.centerXAnchor, constant: contant, type: type)
    }
    
    func joinCenterY(of targetView: UIView, contant: CGFloat = 0, type: AnchorType = .equal) {
        self.joinAnchors(selfAnchor: self.centerYAnchor, targetAnchor: targetView.centerYAnchor, constant: contant, type: type)
    }
    
    func joinWidth(of targetView: UIView, multiplier: CGFloat = 0, contant: CGFloat = 0, type: AnchorType = .equal) {
        self.joinAnchors(selfAnchor: self.widthAnchor, targetAnchor: targetView.widthAnchor, multiplier: multiplier, constant: contant, type: type)
    }
    
    func joinWidthToHeight(of targetView: UIView, multiplier: CGFloat = 0, contant: CGFloat = 0, type: AnchorType = .equal) {
        self.joinAnchors(selfAnchor: self.widthAnchor, targetAnchor: targetView.heightAnchor, multiplier: multiplier, constant: contant, type: type)
    }
    
    func joinWidth(contant: CGFloat = 0, type: AnchorType = .equal) {
        self.joinAnchors(selfAnchor: self.widthAnchor, constant: contant, type: type)
    }
    
    func joinHeight(constant: CGFloat = 0, type: AnchorType = .equal) {
        self.joinAnchors(selfAnchor: self.heightAnchor, constant: constant, type: type)
    }
    
    func join(size: CGSize, type: AnchorType = .equal) {
        self.joinWidth(contant: size.width, type: type)
        self.joinHeight(constant: size.height, type: type)
    }
    
    func joinToSuperView(left: CGFloat?, top: CGFloat?, right: CGFloat?, bottom: CGFloat?) {
        guard let superView = self.superview else {
            fatalError("superView is nil")
        }
        
        if let left = left {
            self.joinLeft(of: superView, contant: left)
        }
        
        if let top = top {
            self.joinTop(of: superView, contant: top)
        }
        
        if let right = right {
            self.joinRight(of: superView, contant: right)
        }
        
        if let bottom = bottom {
            self.joinBottom(of: superView, contant: bottom)
        }
    }
    
    func joinToSuperView() {
        self.joinToSuperView(left: 0, top: 0, right: 0, bottom: 0)
    }
    
    func getConstraints(with firstAttribute: NSLayoutConstraint.Attribute, and secondAttribute: NSLayoutConstraint.Attribute = .notAnAttribute) -> [NSLayoutConstraint] {
        return self.constraints.filter { $0.firstAttribute == firstAttribute && $0.secondAttribute == secondAttribute }
    }
    
    private func prepareView() {
        self.translatesAutoresizingMaskIntoConstraints = false;
    }
}
