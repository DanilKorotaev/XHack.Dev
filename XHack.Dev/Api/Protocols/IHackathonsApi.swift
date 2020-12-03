//
//  IHackathonsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

protocol IHackathonsApi {
    func getHackatons(by filter: HackathonsFilterDto) -> Single<ApiResult<[ShortHackathonDto]>>
    func getHackathonDetails(by id: Int) -> Single<ApiResult<HackathonDto>>
}
