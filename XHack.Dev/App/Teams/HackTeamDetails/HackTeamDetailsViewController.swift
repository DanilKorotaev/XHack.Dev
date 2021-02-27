//
//  HackTeamDetailsViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 24.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class HackTeamDetailsViewController: BaseViewController<HackTeamDetailsViewModel>, Storyboarded {
    static var storyboard =  AppStoryboard.hackTeamDetails
    
    private let allDescriptionCollapsedLines = 3
    private let allDescriptionExpandedLines = 999
    
    private var teamDisposeBag = DisposeBag()
    private var isAllDescriptionShown = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var changeParticipantStateButton: SecondaryButton!
    @IBOutlet weak var showAllDescriptionButton: SecondaryButton!
    @IBOutlet weak var membersCollectionView: UICollectionView!
    @IBOutlet weak var hackDescriptionTextView: UITextView!
    @IBOutlet weak var hackDescriptionContainerView: UIView!
    @IBOutlet weak var teamAvatarImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var changeParticipantStateContainerView: UIView!
    
    override func completeUi() {
        hackDescriptionTextView.textContainer.maximumNumberOfLines = allDescriptionCollapsedLines
        
        setMembersCollectionView()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        
        dataContext.team
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (teamDetail) in
                self?.teamDisposeBag = DisposeBag()
                self?.scrollView.isHidden = teamDetail == nil
                guard let self = self, let teamDetail = teamDetail else { return }
                self.teamNameLabel.text = teamDetail.name
                self.hackDescriptionTextView.text = teamDetail.description
                self.setChangeParticipantStateButtonTitle(participantType: teamDetail.participantType)
                self.setVisibilityChangeParticipantStateButton(participantType: teamDetail.participantType)
                
                teamDetail.isBookmarked.bind(onNext: { [weak self] value in
                    let bookmarkImage = value ? #imageLiteral(resourceName: "Star") : #imageLiteral(resourceName: "unselected_star")
                    self?.bookmarkButton.setImage(bookmarkImage, for: .normal)
                }).disposed(by: self.teamDisposeBag)
                
                teamDetail.members.bind(to: self.membersCollectionView.rx.items(cellIdentifier: ShortUserViewCell.reuseIdentifier)) { row, model, cell in
                        guard let cell = cell as? ShortUserViewCell else { return }
                        cell.set(for: model)
                    }.disposed(by: self.teamDisposeBag)
                
            }).disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .bind(to: dataContext.bookmark)
            .disposed(by: disposeBag)
        
        membersCollectionView.rx.modelSelected(ShortUser.self)
            .bind(to: dataContext.memberSelected)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
        
        changeParticipantStateButton.rx.tap
            .bind(to: dataContext.changeParticipantState)
            .disposed(by: disposeBag)
    }
    
    @IBAction func showAllTaped(_ sender: UIButton) {
        isAllDescriptionShown = !isAllDescriptionShown
        let title = isAllDescriptionShown ? "Collapse" : "Show All"
        showAllDescriptionButton.setTitle(title, for: .normal)
        if isAllDescriptionShown {
            hackDescriptionTextView.textContainer.maximumNumberOfLines = allDescriptionCollapsedLines
            return
        }
        hackDescriptionTextView.textContainer.maximumNumberOfLines = allDescriptionExpandedLines
    }
    
    
    private func setMembersCollectionView() {
        membersCollectionView.register(ShortUserViewCell.nib, forCellWithReuseIdentifier: ShortUserViewCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: membersCollectionView.frame.height)
        membersCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func setVisibilityChangeParticipantStateButton(participantType: TeamParticipantType) {
        changeParticipantStateContainerView.isHidden = participantType == .captaint
    }
    
    func setChangeParticipantStateButtonTitle(participantType: TeamParticipantType) {
        var text = ""
        switch(participantType) {
            case .none:
                text = "Send request"
            case .member:
                text = "Leave team"
            case .outgoingRequest:
                text = "Withdraw request"
            case .incomingRequest:
                text = "Apply request"
            default:
                text = ""
        }
        changeParticipantStateButton.setTitle(text, for: .normal)
    }
}
