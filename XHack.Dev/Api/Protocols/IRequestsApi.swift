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
    func acceptRequestToUser(requestId: Int) -> Promise<LiteApiResult>
    func declineRequestToUser(requestId: Int) -> Promise<LiteApiResult>
    func withDrawRequestToUser(requestId: Int) -> Promise<LiteApiResult>
    func getActiveIncomingRequests() -> Promise<ApiResult<ActiveIncomingRequestsDto>>
}
