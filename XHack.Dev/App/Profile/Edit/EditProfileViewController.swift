//
//  EditProfileViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 21.02.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class EditProfileViewController: BaseViewController<EditProfileViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.editProfile
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var chooseAvatarButton: UIButton!
    @IBOutlet weak var networksTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addNetworkButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var specializationTextField: UITextField!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    override func completeUi() {
        networksTableView.register(ShadowFextFieldViewCell.self)
        tagsCollectionView.register(TagViewCell.self)
//        tagsCollectionView.delegate = self
        configureDismissKeyboard()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else {
            return
        }
        
        dataContext.networks.rx_elements()
            .bind(to: networksTableView.rx.items(cellIdentifier: ShadowFextFieldViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? ShadowFextFieldViewCell else { return }
                cell.set(model)
            }
            .disposed(by: disposeBag)
        
        dataContext.networks.rx_events()
            .observeOn(MainScheduler.instance)
            .bind(to: networksTableView.rx_autoUpdater)
            .disposed(by: disposeBag)
        
        (avatarImageView.rx.url <- dataContext.avatarUrl)
            .disposed(by: disposeBag)
        
        (dataContext.back <- backButton.rx.tap)
            .disposed(by: disposeBag)
        
        (nameTextField.rx.text.orEmpty <-> dataContext.name)
            .disposed(by: disposeBag)
        
        (specializationTextField.rx.text.orEmpty <-> dataContext.specialization)
            .disposed(by: disposeBag)
        
        (dataContext.save <- saveButton.rx.tap)
            .disposed(by: disposeBag)
        
        (dataContext.addNetwork <- addNetworkButton.rx.tap)
            .disposed(by: disposeBag)
        
        (dataContext.chooseAvatar <- chooseAvatarButton.rx.tap)
            .disposed(by: disposeBag)
        
        dataContext.tags.rx_elements()
            .bind(to: tagsCollectionView.rx.items(cellIdentifier: TagViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? TagViewCell else { return }
                cell.set(for: model)
            }
            .disposed(by: disposeBag)
    }
    
    override func keyboardShownHandler(_ keyboardBounds: CGRect) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardBounds.height, right: 0)
    }
    
    override func keyboardHideHandler(_ keyboardBounds: CGRect) {
        scrollView.contentInset = .zero
    }
}

extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let tag = dataContext?.tags[indexPath.row] else { return .zero}
        
        return TagViewCell.getRequiredSize(for: tag)
    }
}
