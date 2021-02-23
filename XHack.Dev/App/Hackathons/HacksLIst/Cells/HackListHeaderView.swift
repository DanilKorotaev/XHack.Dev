//
//  HackListHeaderView.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class HackListHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var searchButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var dataContext: HackathonListViewModel! {
        didSet {
            applyBindings()
        }
    }
    
    @IBOutlet weak var topHacksCollectionView: UICollectionView!
    @IBOutlet weak var popularHackCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTopCollectionView()
        setupPopularCollectionView()
    }
    
    
    func setupTopCollectionView() {
        topHacksCollectionView.register(TopHackViewCell.nib, forCellWithReuseIdentifier: TopHackViewCell.reuseIdentifier)
        let width = UIApplication.shared.keyWindow?.frame.width ?? frame.width - 30
        let cellSize = CGSize(width: width, height:220)
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = cellSize
            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            layout.minimumLineSpacing = 1.0
            layout.minimumInteritemSpacing = 1.0
        topHacksCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func setupPopularCollectionView() {
        popularHackCollectionView.register(PopularHackViewCell.nib, forCellWithReuseIdentifier: PopularHackViewCell.reuseIdentifier)
    }
    
    func applyBindings() {
        searchButton.rx.tap
            .bind(to: dataContext.seachRequsted)
            .disposed(by: disposeBag)
        
        dataContext.hackathons
            .bind(to: topHacksCollectionView.rx.items(cellIdentifier: "TopHackViewCell")) { row, model, cell in
                guard let cell = cell as? TopHackViewCell else { return }
                cell.set(for: model)
            }
            .disposed(by: disposeBag)

        dataContext.hackathons
            .bind(to: popularHackCollectionView.rx.items(cellIdentifier: "PopularHackViewCell")) { row, model, cell in
                guard let cell = cell as? PopularHackViewCell else { return }
                cell.set(for: model)
            }
            .disposed(by: disposeBag)
        
        popularHackCollectionView.rx.modelSelected(ShortHackathon.self)
            .bind(to: dataContext.didSelectHack)
            .disposed(by: disposeBag)
        
        topHacksCollectionView.rx.modelSelected(ShortHackathon.self)
            .bind(to: dataContext.didSelectHack)
            .disposed(by: disposeBag)
    }
}

