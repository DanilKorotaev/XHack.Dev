//
//  IFilesApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 22.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit

protocol IFilesApi {
    func uploadFile(file: File) -> Promise<ApiResult<FileUrlResponse>>
}
