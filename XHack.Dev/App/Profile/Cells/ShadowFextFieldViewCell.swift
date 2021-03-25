//
//  SecondaryFextFieldViewCell.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 23.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class ShadowFextFieldViewCell: UITableViewCell {

    private var disposeBag: DisposeBag!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func set(_ model: BehaviorSubject<String>) {
        disposeBag = DisposeBag()
        (textField.rx.text.orEmpty <-> model)
            .disposed(by: disposeBag)
    }
}
