//
//  ApiHelpers.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class ApiHelpers {
    
    static func executeReliablyEmptyGetRequest(apiTokenHolder: IApiTokensHolder, url: String) -> Observable<LiteApiResult> {
        return HttpClientHelper.shared.get(url: url).map {  (response) -> LiteApiResult in
            if response.status == .ok {
                return LiteApiResult(status: .successful)
            }
            else {
                return LiteApiResult(status: response.status.toApiActionResult())
            }
        }
    }
    
    
    static func executeReliablyGetRequest<TContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String) -> Observable<ApiResult<TContent>> {
        return HttpClientHelper.shared.get(url: url).map { (response) -> ApiResult<TContent> in
            if response.status == .ok {
                if response.content?.isEmpty ?? true {
                    return ApiResult(status: .rejected)
                }
                let responseContent = Decode(TContent.self, json: response.content!)
                return ApiResult(status: .successful, content: responseContent)
            }
            //TODO: add error codes
            return ApiResult(status: response.status.toApiActionResult())
        }
    }
    
    
    static func executeReliablyLitePostRequest<TRequestContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String, content: TRequestContent) -> Observable<LiteApiResult> {
        return HttpClientHelper.shared.post(url: url, postData: content.toJson()!).map { (response) -> LiteApiResult in
            if response.status == .ok {
                return LiteApiResult(status: .successful)
            }
            else {
                return LiteApiResult(status: response.status.toApiActionResult())
            }
        }
    }
    
    
    static func executeReliablyPostRequest<TRequestContent: Codable, TResponseContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String, content: TRequestContent) -> Observable<ApiResult<TResponseContent>> {
        let json = content.toJson()!
        return HttpClientHelper.shared.post(url: url, postData: json).map { (response) -> ApiResult<TResponseContent> in
            if response.status == .ok || response.status == .created {
                if response.content?.isEmpty ?? true {
                    return ApiResult(status: .rejected)
                }
                let responseContent = Decode(TResponseContent.self, json: response.content!)
                return ApiResult(status: .successful, content: responseContent)
            }
            //TODO: add error codes
            return ApiResult(status: response.status.toApiActionResult())
        }
    }
    
    
    static func Decode<T: Codable>(_ type: T.Type, json: Data) -> T? {
//        if type == String.self && json.starts(with: "\"") {
//            return json as Any as? T
//        }
        
        return json.toObject(type)
    }
}
