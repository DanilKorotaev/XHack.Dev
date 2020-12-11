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

class CreateTeamViewController: UIViewController, Storyboarded {
    static var storyboard =  AppStoryboard.createTeam
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamDescriptionTextFiled: UITextField!
    @IBOutlet weak var createTeamButton: UIButton!
    var viewModel: CreateTeamViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDismissKeyboard()
        setUpBindings()
    }
    
    private func setUpBindings() {
        guard let viewModel = viewModel else { return }
        
        Observable.of(teamNameTextField, teamDescriptionTextFiled)
            .flatMap { $0.rx.controlEvent(.editingDidEndOnExit) }
            .withLatestFrom(viewModel.canCreateTeam)
            .filter { $0 }
            .bind { [weak self] _ in self?.viewModel?.createTeam() }
            .disposed(by: disposeBag)
        
        teamNameTextField.rx.text.orEmpty
            .bind(to: viewModel.teamName)
            .disposed(by: disposeBag)
        
        teamDescriptionTextFiled.rx.text.orEmpty
            .bind(to: viewModel.teamDescription)
            .disposed(by: disposeBag)
        
        createTeamButton.rx.tap
            .bind { [weak self] in self?.viewModel?.createTeam() }
            .disposed(by: disposeBag)
    }
}
