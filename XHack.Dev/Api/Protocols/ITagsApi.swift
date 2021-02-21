//
//  ITagsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 15.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

protocol ITagsApi {
    func addTags(_ tagIds:[Int]) -> Promise<LiteApiResult>
}
