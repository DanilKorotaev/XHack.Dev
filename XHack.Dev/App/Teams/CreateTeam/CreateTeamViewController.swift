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
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var chooseAvatarButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func completeUi() {
        configureDismissKeyboard()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        titleLabel.text = dataContext.mode == .edit ? "Edit team" : "Create team"
        createTeamButton.setTitle(dataContext.mode == .edit ? "Save" : "Create", for: .normal) 
        (teamNameTextField.rx.text.orEmpty <-> dataContext.teamName)
            .disposed(by: disposeBag)
        
        (teamDescriptionTextFiled.rx.text.orEmpty <-> dataContext.teamDescription)
            .disposed(by: disposeBag)
        
        createTeamButton.rx.tap
            .bind {
                dataContext.createTeam()
            }.disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
        
        (avatarImageView.rx.url <- dataContext.avatarUrl)
            .disposed(by: disposeBag)
        
        (dataContext.chooseAvatar <- chooseAvatarButton.rx.tap)
            .disposed(by: disposeBag)
    }
    
    override func keyboardShownHandler(_ keyboardBounds: CGRect) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardBounds.height, right: 0)
    }
    
    override func keyboardHideHandler(_ keyboardBounds: CGRect) {
        scrollView.contentInset = .zero
    }
}
