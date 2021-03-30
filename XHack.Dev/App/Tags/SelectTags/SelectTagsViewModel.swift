//
//  SelectTagsViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class SelectTagsViewModel: BaseViewModel {
    
    private static var cashedTags: [Tag] = []
    private var allSelected = false
    let tagsApi: ITagsApi
    
    var tags = ObservableArray<SelectedTag>()
    let back = PublishSubject<Void>()
    let save = PublishSubject<Void>()
    let selectAll = PublishSubject<Void>()
    
    var parameter: SelectTagsParameter?
    
    init(tagsApi: ITagsApi) {
        self.tagsApi = tagsApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        func setSelectedIfNeeded() {
            if let selectedTag = parameter?.selectedTag {
                tags.forEach({ tag in tag.isSelected.onNext(selectedTag.contains(where: {
                    $0.id == tag.id
                }))})
            }
        }
        
        guard SelectTagsViewModel.cashedTags.isEmpty else {
            let tags = SelectTagsViewModel.cashedTags.map { SelectedTag($0) }
            self.tags.append(contentsOf: tags)
            setSelectedIfNeeded()
            return
        }
        
        tagsApi.getTags().done { [weak self] (result) in
            self?.checkAndProcessApiResult(response: result)
            guard let tagsDto = result.content else { return }
            SelectTagsViewModel.cashedTags = tagsDto.map { Tag($0) }
            let tags = tagsDto.map { Tag($0) }
            self?.tags.append(contentsOf: tags.map { SelectedTag($0) })
            setSelectedIfNeeded()
        }
    }
    
    override func applyBinding() {
        selectAll.bind { [weak self] in
            guard let self = self else { return }
            self.allSelected = !self.allSelected
            self.tags.forEach( { $0.isSelected.onNext(self.allSelected) })
        }.disposed(by: disposeBag)
    }
}
