//
//  ITagsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 15.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

protocol ITagsApi {
    func addTags(_ tagIds:[Int]) -> Single<LiteApiResult>
}
