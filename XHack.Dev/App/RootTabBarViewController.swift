//
//  RootTabBarViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 25.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import SideMenu

class RootTabBarViewController: UITabBarController {
    var menuButton: UIButton!
    var middleButtonTap: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ensureLightThemeEnabled()
        self.tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.clipsToBounds = true
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
//        setupMiddleButton()
        tabBar.items?.forEach({ (item) in
            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for:.selected)
        })
    }
    
    private func setUpSideMenu() {
        // Define the menus
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: DrawerMenuViewController.instantiate())
        SideMenuManager.default.rightMenuNavigationController = leftMenuNavigationController
        leftMenuNavigationController.navigationBar.isHidden = true

        let style = SideMenuPresentationStyle.menuSlideIn
        style.backgroundColor = .black
        style.presentingEndAlpha = 0.32
        style.onTopShadowColor = .black
        style.onTopShadowRadius = 4.0
        style.onTopShadowOpacity = 0.2
        style.onTopShadowOffset = CGSize(width: 2.0, height: 0.0)

        var settings = SideMenuSettings()
        settings.presentationStyle = style
        settings.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.75), 240)
        settings.statusBarEndAlpha = 0.0

        leftMenuNavigationController.settings = settings
    }
    
    func setupMiddleButton() {
        guard menuButton == nil else {
            return
        }
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = self.tabBar.frame.minY - 7
        menuButtonFrame.origin.x = self.view.bounds.width / 2 - menuButtonFrame.size.width / 2
        menuButton.frame = menuButtonFrame
        
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.alpha = 0
        self.view.addSubview(menuButton)
        UIView.animate(withDuration: 1) {
            self.menuButton.alpha = 1
        }

        menuButton.setImage(#imageLiteral(resourceName: "ic_search"), for: .normal)
        
        let shadows = UIView()
        shadows.isUserInteractionEnabled = false
        shadows.frame = menuButton.bounds
        shadows.clipsToBounds = false
        menuButton.insertSubview(shadows, at: 0)
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 37)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 1, green: 0.18, blue: 0, alpha: 0.46).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 6
        layer0.shadowOffset = CGSize(width: 0, height: 4)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)

        let shadowPath1 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 37)
        let layer1 = CALayer()
        layer1.shadowPath = shadowPath1.cgPath
        layer1.shadowColor = UIColor(red: 1, green: 0, blue: 0.3, alpha: 0.25).cgColor
        layer1.shadowOpacity = 1
        layer1.shadowRadius = 20
        layer1.shadowOffset = CGSize(width: 0, height: -4)
        layer1.bounds = shadows.bounds
        layer1.position = shadows.center
        shadows.layer.addSublayer(layer1)
        
        let shapes = UIView()
        shapes.frame = menuButton.bounds
        shapes.clipsToBounds = true
        shapes.layer.cornerRadius = 27
        shapes.isUserInteractionEnabled = false
        menuButton.insertSubview(shapes, at: 0)

        let layer2 = CAGradientLayer()
        layer2.colors = [
          UIColor(red: 1, green: 0, blue: 0.36, alpha: 1).cgColor,
          UIColor(red: 0.962, green: 0.346, blue: 0, alpha: 1).cgColor
        ]
        layer2.locations = [0, 1]
        layer2.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer2.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer2.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.92, b: 1.28, c: -1.28, d: -19.9, tx: 1.6, ty: 9.86))
        layer2.bounds = shapes.bounds.insetBy(dx: -0.5*shapes.bounds.size.width, dy: -0.5*shapes.bounds.size.height)
        layer2.position = shapes.center
        shapes.layer.addSublayer(layer2)
        
        menuButton.bringSubviewToFront(menuButton.imageView!)
        menuButton.addTarget(self, action: #selector(menuButtonDidTap), for: .touchUpInside)
    }

    
    // Menu Button Touch Action
    @objc func menuButtonDidTap(sender: Any) {
        self.selectedIndex = -1
        middleButtonTap?()
   }
}
