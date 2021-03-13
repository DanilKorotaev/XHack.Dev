//
//  UITableView+RxExtension.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 12.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension UITableView {
    public func rx_autoUpdater(source: Observable<ArrayChangeEvent>) -> Disposable {
        return source
            .scan((0, nil)) { (a: (Int, ArrayChangeEvent?), ev) in
                return (a.0 + ev.insertedIndices.count - ev.deletedIndices.count, ev)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { sourceCount, event in
                guard let event = event else { return }
                
                let tableCount = self.numberOfRows(inSection: 0)
                guard tableCount + event.insertedIndices.count - event.deletedIndices.count == sourceCount else {
                    self.reloadData()
                    return
                }
                
                func toIndexSet(array: [Int]) -> [IndexPath] {
                    return array.map { IndexPath(row: $0, section: 0) }
                }
                
                self.beginUpdates()
                self.insertRows(at: toIndexSet(array: event.insertedIndices), with: .automatic)
                self.deleteRows(at: toIndexSet(array: event.deletedIndices), with: .automatic)
                self.reloadRows(at: toIndexSet(array: event.updatedIndices), with: .automatic)
                self.endUpdates()
            })
    }
}
