//
//  IRequestsApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 16.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

protocol IRequestsApi {
    func acceptRequestToUser(requestId: Int) -> Single<LiteApiResult>
    func declineRequestToUser(requestId: Int) -> Single<LiteApiResult>
    func withDrawRequestToUser(requestId: Int) -> Single<LiteApiResult>
    func getActiveIncomingRequests() -> Single<ApiResult<ActiveIncomingRequestsDto>>
}
