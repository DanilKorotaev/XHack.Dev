//
//  SentRequestViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 27.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class SentRequestViewController: BaseViewController<SentRequestViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.sentRequest
    
    lazy var refreshHandler: RefreshHandler = {
        RefreshHandler(view: tableView)
    }()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noRequestsLabel: UILabel!
    
    var dataSource:  RxTableViewSectionedReloadDataSource<RequestSection> = {
        let dataSource = RxTableViewSectionedReloadDataSource<RequestSection>(configureCell: { (_, tableView, indexPath, target) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomingRequestViewCell.reuseIdentifier, for: indexPath) as! IncomingRequestViewCell
            cell.set(target)
            return cell
        })
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].title
        }
        
        return dataSource
    }()
    
    
    override func completeUi() {
        tableView.register(IncomingRequestViewCell.self)
        tableView.delegate = self
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        (dataContext.back <- backButton.rx.tap)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ParticipantRequestable.self)
            .bind(to: dataContext.requestSelected)
            .disposed(by: disposeBag)
        
        dataContext.requestSections.rx_elements().bind { [weak self] sections in
            self?.noRequestsLabel.isHidden = !sections.isEmpty
        }.disposed(by: disposeBag)
        
        dataContext.requestSections.rx_elements().bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        dataContext.isRefreshing
            .bind(to: refreshHandler.isRefreshing)
            .disposed(by: disposeBag)
        
        refreshHandler.refresh
            .bind(to: dataContext.refresh)
            .disposed(by: disposeBag)
    }
}


extension SentRequestViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 42)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .white
        let labelXoffset = CGFloat(15)
        let labelWidth = frame.width - labelXoffset
        let sectionLabel = UILabel(frame: CGRect(x: 15, y: 0, width: labelWidth , height: frame.height))
        sectionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        sectionLabel.text = dataSource[section].title
        
        sectionLabel.textColor = .black
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
