//
//  TagViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit

class TagViewCell: UICollectionViewCell {

    static var defaultHeight:CGFloat = 20
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rootView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layer2 = CAGradientLayer()
        layer2.colors = [
          UIColor(red: 1, green: 0, blue: 0.36, alpha: 1).cgColor,
          UIColor(red: 0.962, green: 0.346, blue: 0, alpha: 1).cgColor
        ]
        layer2.locations = [0, 1]
        layer2.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer2.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer2.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.92, b: 1.28, c: -1.28, d: -19.9, tx: 1.6, ty: 9.86))
        layer2.bounds = rootView.bounds
        layer2.position = rootView.center
        rootView.layer.insertSublayer(layer2, at: 0)
    }

    func set(for model: Tag) {
        nameLabel.text = model.name
    }
    
    static func getRequiredSize(for model: Tag) -> CGSize {
        var size = model.name.getRequiredTextSize(UIFont.systemFont(ofSize: 17))
        size.width += 25
        size.height = defaultHeight
        return size
    }
}
