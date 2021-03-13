//
//  TableViewLoadingTarget.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 13.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TableViewLoadingTarget: PageLoadingTarget {

    private let tableView: UITableView
    private var _isLoading: Bool = false
    private let loadView: UIView
    private let loadIndicator: UIActivityIndicatorView
    
    var scrollView: UIScrollView {
        tableView
    }
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                loadIndicator.startAnimating()
                tableView.tableFooterView = loadView
            } else {
                tableView.tableFooterView = nil
                loadIndicator.stopAnimating()
            }
        }
    }
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
        loadView = UIView()
        loadView.frame = CGRect(x: 0,y: 0,width: tableView.frame.width, height: 50)
        loadIndicator = UIActivityIndicatorView(style: .gray)
        initLoader()
    }
    
    private func initLoader() {
        loadView.addSubview(loadIndicator)
        loadIndicator.centerYAnchor.constraint(equalTo: loadView.centerYAnchor).isActive = true
        loadIndicator.centerXAnchor.constraint(equalTo: loadView.centerXAnchor).isActive = true
    }
}
