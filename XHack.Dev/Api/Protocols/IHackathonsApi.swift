//
//  IHackathonsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

protocol IHackathonsApi {
    func getHackatons(by filter: HackathonsFilterDto) -> Promise<ApiResult<[ShortHackathonDto]>>
    func getHackathonDetails(by id: Int) -> Promise<ApiResult<HackathonDto>>
    func willGoHackathon(id: Int) -> Promise<LiteApiResult>
    func willNotGoHackathon(id: Int) -> Promise<LiteApiResult>
    func getUsersForHackathon(by filter: HackMemberListFilterDto, for hackID: Int) -> Promise<ApiResult<[ShortUserDto]>>
    func getTeamsForHackathon(by filter: HackTeamListFilterDto, for hackID: Int) -> Promise<ApiResult<[TeamDto]>>
    func leaveTeam(for hackId: Int) -> Promise<LiteApiResult>
    func unsingTeamFromHack(hackId: Int) -> Promise<LiteApiResult>
}
