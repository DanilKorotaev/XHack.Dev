//
//  ITeamsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 03.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

protocol ITeamsApi {
    func getTeams() -> Promise<ApiResult<[TeamDto]>>
    func create(team: CreateTeamDto) -> Promise<LiteApiResult>
    func create(for hackId: Int, team: CreateTeamDto) -> Promise<LiteApiResult>
    func getDetail(for teamId: Int) -> Promise<ApiResult<TeamDetailsDto>>
    func leave(teamId: Int) -> Promise<LiteApiResult>
    func update(team: UpdateTeamDto, for teamId: Int) -> Promise<LiteApiResult>
    func removeTeammate(teamId: Int, userId: Int) -> Promise<LiteApiResult>
    func removeTeam(teamId: Int) -> Promise<LiteApiResult>
}
