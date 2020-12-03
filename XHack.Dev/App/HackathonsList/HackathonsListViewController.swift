//
//  HackathonsListViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit

class HackathonsListViewController: UIViewController, Storyboarded {
    static var storyboard =  AppStoryboard.hackathonsList
    

    var viewModel: HackathonsListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
