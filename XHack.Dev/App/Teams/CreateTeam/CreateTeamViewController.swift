//
//  CreateTeamViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 11.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateTeamViewController: BaseViewController<CreateTeamViewModel>, Storyboarded {
    static var storyboard =  AppStoryboard.createTeam
    
    @IBOutlet weak var teamNameTextField: CustomShadowTextField!
    @IBOutlet weak var teamDescriptionTextFiled: CustomShadowTextField!
    @IBOutlet weak var createTeamButton: PrimaryButton!
    @IBOutlet weak var backButton: UIButton!

    
    override func completeUi() {
        configureDismissKeyboard()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        teamNameTextField.rx.text.orEmpty
            .bind(to: dataContext.teamName)
            .disposed(by: disposeBag)
        
        teamDescriptionTextFiled.rx.text.orEmpty
            .bind(to: dataContext.teamDescription)
            .disposed(by: disposeBag)
        
        createTeamButton.rx.tap
            .bind {
                dataContext.createTeam()
            }.disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
    }
}
