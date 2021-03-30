//
//  SelectedTagViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class SelectedTagViewCell: UITableViewCell {

    private var disposeBag: DisposeBag!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func set(_ model: SelectedTag) {
        disposeBag = DisposeBag()
        nameLabel.text = model.name
        (selectSwitch.rx.isOn <-> model.isSelected)
            .disposed(by: disposeBag)
    }
}
