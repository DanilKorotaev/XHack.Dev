//
//  UserDetailsViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 02.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class UserDetailsViewController: BaseViewController<UserDetailsViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.userDetails
    
    private var userDisposeBag = DisposeBag()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var specializationLabel: UILabel!
    @IBOutlet weak var changeRelationStateButton: SecondaryButton!
    @IBOutlet weak var changeRelationStateView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var tagsCollectionView: UIResizableCollectionView!
    @IBOutlet weak var tagsContainerView: UIView!
    @IBOutlet weak var socialView: UIView!
    @IBOutlet weak var socialsTextView: UITextView!
    
    override func completeUi() {
        tagsCollectionView.register(TagViewCell.self)
        tagsCollectionView.delegate = self
        tagsCollectionView.collectionViewLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left)
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        
        dataContext.user
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (userDetails) in
                self?.userDisposeBag = DisposeBag()
                self?.scrollView.isHidden = userDetails == nil
                guard let self = self, let userDetails = userDetails else { return }
                self.nameLabel.text = userDetails.name.value
                self.descriptionLabel.text = userDetails.description.value
                self.specializationLabel.text = userDetails.specialization.value
                self.avatarImageView.downloaded(from: userDetails.avatarUrl)
                self.setChangeParticipantStateButtonTitle(requests: userDetails.requests)
                self.tagsContainerView.isHidden = userDetails.tags.isEmpty
                self.setSocials(userDetails.networks)
                userDetails.tags.rx_elements()
                    .bind(to: self.tagsCollectionView.rx.items(cellIdentifier: TagViewCell.reuseIdentifier)) { row, model, cell in
                        guard let cell = cell as? TagViewCell else { return }
                        cell.set(for: model)
                    }
                    .disposed(by: self.userDisposeBag)
                
                userDetails.isBookmarked.bind(onNext: { [weak self] value in
                    let bookmarkImage = value ? #imageLiteral(resourceName: "Star") : #imageLiteral(resourceName: "unselected_star")
                    self?.bookmarkButton.setImage(bookmarkImage, for: .normal)
                }).disposed(by: self.userDisposeBag)
            }).disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .bind(to: dataContext.bookmark)
            .disposed(by: disposeBag)
        
        changeRelationStateButton.rx.tap
            .bind(to: dataContext.changeRelatonState)
            .disposed(by: disposeBag)
        
        chatButton.rx.tap
            .bind(to: dataContext.chat)
            .disposed(by: disposeBag)
        
        dataContext.canChat
            .bind(to: chatButton.rx.isHidden.mapObserver({ !$0}))
            .disposed(by: disposeBag)
        
        dataContext.canBookmark
            .bind(to: bookmarkButton.rx.isHidden.mapObserver({ !$0}))
            .disposed(by: disposeBag)
        
        dataContext.isCurrentUser.bind { value in
            self.changeRelationStateView.isHidden = value
        }.disposed(by: disposeBag)
    }
    
    
    func setChangeParticipantStateButtonTitle(requests: [TeamRequest]) {
        var text = ""
        self.changeRelationStateView.isHidden = false
        if requests.isEmpty {
            text = "Send request"
        } else {
            text = "Show requests"
        }
        changeRelationStateButton.setTitle(text, for: .normal)
    }
    
    func setSocials(_ networks: [String]) {
        socialView.isHidden = networks.isEmpty
        self.socialsTextView.text = networks.joined(separator: "\n\n")
        socialsTextView.joinHeight(constant: socialsTextView.getRequiredTextSize().height)
    }
}


extension UserDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let tag = dataContext?.user.value?.tags[indexPath.row] else { return .zero}
        
        return TagViewCell.getRequiredSize(for: tag)
    }
}
