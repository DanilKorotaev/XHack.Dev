//
//  BaseViewModel+Files.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit
import Swinject

extension BaseViewModel {
    func uploadFile(_ file: File) -> Promise<String?> {
        self.isLoading.onNext(true)
        return Promise() { promise in
            let filesApi = Container.resolve(IFilesApi.self)
            filesApi.uploadFile(file: file).done { (result) in
                self.isLoading.onNext(false)
                if self.checkAndProcessApiResult(response: result, "загрузить аватарку") {
                    promise.fulfill(nil)
                    return
                }
                guard let fileContentUrl = result.content  else { return }
                promise.fulfill(fileContentUrl.image_url)
            }
        }
    }
}
