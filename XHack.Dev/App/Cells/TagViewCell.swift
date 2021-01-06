//
//  TagViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit

class TagViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rootView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var shapes = UIView()
        shapes.frame = rootView.frame
        shapes.clipsToBounds = true
        rootView.addSubview(shapes)
        shapes.layer.zPosition = 0
        let layer1 = CAGradientLayer()
        layer1.colors = [
          UIColor(red: 0.129, green: 1, blue: 0.791, alpha: 1).cgColor,
          UIColor(red: 0.033, green: 0.887, blue: 0.734, alpha: 1).cgColor
        ]
        layer1.locations = [0, 1]
        layer1.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer1.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer1.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.15, b: 1.83, c: -1.83, d: 0.85, tx: 1.24, ty: -0.55))
        layer1.bounds = shapes.bounds.insetBy(dx: -0.5*shapes.bounds.size.width, dy: -0.5*shapes.bounds.size.height)
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)
        shapes.layer.cornerRadius = 38
    }

    func set(for model: Tag) {
        nameLabel.text = model.name
    }
}
