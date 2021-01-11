//
//  TeamSearchViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 07.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit

class TeamSearchViewController: BaseViewController<TeamSearchViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.teamSearch    
    @IBOutlet weak var bottomTriggerView: UIView!
    
    let transition = TeamToHackDetailsTransitionCoordinator()
    
    
}

extension TeamSearchViewController: InteractiveTransitionableViewController {
    var interactivePresentTransition: MiniToLargeViewInteractiveAnimator? {
        return transition.interactivePresentTransition
    }
    var interactiveDismissTransition: MiniToLargeViewInteractiveAnimator? {
        return transition.interactiveDismissTransition
    }
}
