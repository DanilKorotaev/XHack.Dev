//
//  IUserApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

protocol IUserApi {
    func getProfile() -> Promise<ApiResult<UserProfileDto>>
    func updateProfile(_ data: UpdateProfileDtoRequest) -> Promise<LiteApiResult>
}
