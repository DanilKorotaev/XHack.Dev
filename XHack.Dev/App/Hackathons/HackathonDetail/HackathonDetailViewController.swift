//
//  HackathonDetailViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class HackathonDetailViewController: BaseViewController<HackathonDetailViewModel>, Storyboarded {
    
    private let allDescriptionCollapsedLines = 3
    private let allDescriptionExpandedLines = 999
    static var storyboard = AppStoryboard.hackathonDetail
    
    private var isAllDescriptionShown = false
    
    @IBOutlet weak var hackNameLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var joinButton: SecondaryButton!
    @IBOutlet weak var showAllDescriptionButton: SecondaryButton!
    @IBOutlet weak var hackLinkButton: UIHackLinkButton!
    @IBOutlet weak var hackAvatarImageView: UIImageView!
    @IBOutlet weak var searchMemberButton: UIButton!
    @IBOutlet weak var searchTeamButton: UIButton!
    @IBOutlet weak var searchMemberContainerView: UIView!
    @IBOutlet weak var searchTeamContainerView: UIView!
    @IBOutlet weak var searchMemberCollectionView: UICollectionView!
    @IBOutlet weak var seachTeamCollectionView: UICollectionView!
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hackDescriptionTextView: UITextView!
    @IBOutlet weak var hackDescriptionContainerView: UIView!
    
    override func completeUi() {
        hackDescriptionTextView.textContainer.maximumNumberOfLines = allDescriptionCollapsedLines
        
        setTeamCollectionView()
        setMemberCollectionView()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        dataContext.hackathon
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](hackDetail) in
                guard let self = self, let hackDetail = hackDetail else { return }
                self.hackNameLabel.text = hackDetail.name.value
                self.hackDescriptionTextView.text = hackDetail.description.value
                self.hackDescriptionContainerView.isHidden = hackDetail.description.value.isEmpty
                self.dateLabel.text = hackDetail.dateText
                self.hackLinkButton.setTitle(hackDetail.siteUrl, for: .normal)
                self.searchTeamContainerView.isHidden = hackDetail.teams.value.isEmpty
                self.searchMemberContainerView.isHidden = hackDetail.members.value.isEmpty

                hackDetail.members
                    .bind(to: self.searchMemberCollectionView.rx.items(cellIdentifier: ShortUserViewCell.reuseIdentifier)) { row, model, cell in
                        guard let cell = cell as? ShortUserViewCell else { return }
                        cell.set(for: model)
                    }
                    .disposed(by: self.disposeBag)
                
                hackDetail.teams
                    .bind(to: self.seachTeamCollectionView.rx.items(cellIdentifier: ShortTeamViewCell.reuseIdentifier)) { row, model, cell in
                        guard let cell = cell as? ShortTeamViewCell else { return }
                        cell.set(for: model)
                    }
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        joinButton.rx.tap
            .bind(to: dataContext.join)
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .bind(to: dataContext.bookmark)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
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
    
    
    private func setTeamCollectionView() {
        seachTeamCollectionView.register(ShortTeamViewCell.nib, forCellWithReuseIdentifier: ShortTeamViewCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 55, height: 90)
        seachTeamCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setMemberCollectionView() {
        searchMemberCollectionView.register(ShortUserViewCell.nib, forCellWithReuseIdentifier: ShortUserViewCell.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 55, height: 90)
        searchMemberCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}
