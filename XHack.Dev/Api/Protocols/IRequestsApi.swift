//
//  IRequestsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 16.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

protocol IRequestsApi {
    func acceptRequestUserToTeam(requestId: Int) -> Promise<LiteApiResult>
    func declineRequestToUser(requestId: Int) -> Promise<LiteApiResult>
    func withDrawRequestToUser(userId: Int) -> Promise<LiteApiResult>
    func getActiveIncomingRequests() -> Promise<ApiResult<ActiveIncomingRequestsDto>>
    func acceptRequestFromTeam(teamId: Int) -> Promise<LiteApiResult>
    func withDrawRequestToTeam(teamId: Int) -> Promise<LiteApiResult>
    func sendRequest(to team: CreateRequestToTeamDto) -> Promise<LiteApiResult>
    func sendRequest(to user: CreateRequestToUserDto) -> Promise<LiteApiResult>
    func withdrawRequest(requestId: Int) -> Promise<LiteApiResult>
    func declineRequestUserToTeam(requestId: Int) -> Promise<LiteApiResult>
}
