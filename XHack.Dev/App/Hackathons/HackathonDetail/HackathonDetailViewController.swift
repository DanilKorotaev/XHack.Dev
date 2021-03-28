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
    private var hackDisposeBag = DisposeBag()
    private var isAllDescriptionShown = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hackNameLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changeParticipantStateButton: SecondaryButton!
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
    @IBOutlet weak var changeParticipantStateContainerView: UIView!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var onlineImageView: UIImageView!
    @IBOutlet weak var globeImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: UIResizableCollectionView!
    @IBOutlet weak var tagsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagsContainerView: UIView!
    
    override func completeUi() {
        hackDescriptionTextView.textContainer.maximumNumberOfLines = allDescriptionCollapsedLines
        hackDescriptionTextView.textContainerInset = .zero
        setTeamCollectionView()
        setMemberCollectionView()
        setTagsCollectionView()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        dataContext.hackathon
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](hackDetail) in
                self?.hackDisposeBag = DisposeBag()
                self?.scrollView.isHidden = hackDetail == nil
                guard let self = self, let hackDetail = hackDetail else { return }
                self.hackNameLabel.text = hackDetail.name.value
                self.hackDescriptionTextView.text = hackDetail.description.value
                self.locationLabel.text = hackDetail.isOnline ? "online" : hackDetail.location
                self.onlineImageView.isHidden = !hackDetail.isOnline
                self.globeImageView.isHidden = hackDetail.isOnline
                self.hackDescriptionContainerView.isHidden = hackDetail.description.value.isEmpty
                self.dateLabel.text = hackDetail.dateText
                self.hackLinkButton.setTitle(hackDetail.siteUrl, for: .normal)
                self.hackLinkButton.isHidden = !hackDetail.siteUrl.hasNonEmptyValue()
                self.searchTeamContainerView.isHidden = hackDetail.teams.value.isEmpty
                self.searchMemberContainerView.isHidden = hackDetail.members.value.isEmpty
                self.tagsContainerView.isHidden = hackDetail.tags.isEmpty
                self.hackAvatarImageView.downloaded(from: hackDetail.avatarUrl)
                self.setChangeParticipantStateButtonTitle(participantType: hackDetail.participationType)
                self.updateDescriptionHeight()
                self.updateVisibilityShowAllButton()
                
                hackDetail.isBookmarked.bind(onNext: { [weak self] value in
                    let bookmarkImage = value ? #imageLiteral(resourceName: "Star") : #imageLiteral(resourceName: "unselected_star")
                    self?.bookmarkButton.setImage(bookmarkImage, for: .normal)
                }).disposed(by: self.hackDisposeBag)
                
                hackDetail.tags.rx_elements()
                    .bind(to: self.tagsCollectionView.rx.items(cellIdentifier: TagViewCell.reuseIdentifier)) { row, model, cell in
                        guard let cell = cell as? TagViewCell else { return }
                        cell.set(for: model)
                    }
                    .disposed(by: self.hackDisposeBag)
                
                hackDetail.members
                    .bind(to: self.searchMemberCollectionView.rx.items(cellIdentifier: ShortUserViewCell.reuseIdentifier)) { row, model, cell in
                        guard let cell = cell as? ShortUserViewCell else { return }
                        cell.set(for: model)
                    }
                    .disposed(by: self.hackDisposeBag)
                
                hackDetail.teams
                    .bind(to: self.seachTeamCollectionView.rx.items(cellIdentifier: ShortTeamViewCell.reuseIdentifier)) { row, model, cell in
                        guard let cell = cell as? ShortTeamViewCell else { return }
                        cell.set(for: model)
                    }
                    .disposed(by: self.hackDisposeBag)
            }).disposed(by: disposeBag)
        
        changeParticipantStateButton.rx.tap
            .bind(to: dataContext.changeParticipantState)
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .bind(to: dataContext.bookmark)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
        
        seachTeamCollectionView.rx.modelSelected(ShortTeam.self)
            .bind(to: dataContext.teamSelected)
            .disposed(by: disposeBag)
        
        searchMemberCollectionView.rx.modelSelected(ShortUser.self)
            .bind(to: dataContext.memberSelected)
            .disposed(by: disposeBag)
        
        searchMemberButton.rx.tap
            .bind(to: dataContext.memberSearch)
            .disposed(by: disposeBag)
        
        searchTeamButton.rx.tap
            .bind(to: dataContext.teamSearch)
            .disposed(by: disposeBag)
    }
    
    @IBAction func showAllTaped(_ sender: UIButton) {
        isAllDescriptionShown = !isAllDescriptionShown
        let title = isAllDescriptionShown ? "Collapse" : "Show All"
        showAllDescriptionButton.setTitle(title, for: .normal)
        updateDescriptionHeight()
    }

    private func updateDescriptionHeight() {
        let textSize = hackDescriptionTextView.text.getRequiredTextSize(hackDescriptionTextView.font!, hackDescriptionTextView.frame.width)
        let lineHeight = hackDescriptionTextView.font!.lineHeight
        let maxLines = isAllDescriptionShown ?  allDescriptionExpandedLines : allDescriptionCollapsedLines
        let maxHeight = lineHeight * CGFloat(maxLines)
        let textHeight = (maxHeight > textSize.height ? textSize.height : maxHeight) + lineHeight / 2

        self.hackDescriptionTextView.textContainer.maximumNumberOfLines = maxLines

        UIView.animate(withDuration: 0.3) {
            self.descriptionTextViewHeightConstraint.constant = textHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateVisibilityShowAllButton() {
        let textSize = hackDescriptionTextView.getRequiredTextSize()
        let lineHeight = hackDescriptionTextView.font!.lineHeight
        let maxHeight = lineHeight * CGFloat(allDescriptionCollapsedLines)
        showAllDescriptionButton.isHidden = textSize.height <= maxHeight
    }
    
    private func setTeamCollectionView() {
        seachTeamCollectionView.register(ShortTeamViewCell.self)
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: seachTeamCollectionView.frame.height)
        seachTeamCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setMemberCollectionView() {
        searchMemberCollectionView.register(ShortUserViewCell.self)
        
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 55, height: 90)
        searchMemberCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setTagsCollectionView() {
        tagsCollectionView.register(TagViewCell.self)
        tagsCollectionView.delegate = self
        tagsCollectionView.collectionViewLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left)
        tagsCollectionView.contentSizeChanged.subscribe(onNext: { [weak self] size in
            self?.tagsHeightConstraint.constant = size.height
        }).disposed(by: disposeBag)
    }
    
    
    func setChangeParticipantStateButtonTitle(participantType: HackParticipationType) {
        var text = ""
        switch(participantType) {
            case .none:
                text = "Join"
            case .teamMember:
                text = "Leave team"
            case .single:
                text = "Cancel participation"
            case .teamCaptain:
                text = "Cancel team participation"
            @unknown default:
                text = ""
        }
        changeParticipantStateButton.setTitle(text, for: .normal)
    }
}


extension HackathonDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let tag = dataContext?.hackathon.value?.tags[indexPath.row] else { return .zero}
        
        return TagViewCell.getRequiredSize(for: tag)
    }
}
