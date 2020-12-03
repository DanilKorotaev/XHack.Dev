//
//  ITeamsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

protocol ITeamsApi {
    func getTeams() -> Single<ApiResult<[TeamDto]>>
    func create(team: CreateTeamDto) -> Single<LiteApiResult>
    func sendRequest(to team: CreateRequestToTeamDto) -> Single<LiteApiResult>
    func sendRequest(to user: CreateRequestToUserDto) -> Single<LiteApiResult>
}
