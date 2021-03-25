//
//  ApiHelpers.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 29.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class ApiHelpers {
    
    static func executeReliablyEmptyGetRequest(apiTokenHolder: IApiTokensHolder, url: String) -> Promise<LiteApiResult> {
        return HttpClientHelper.shared.get(url: url, accessToken: apiTokenHolder.accessToken).map(toLiteApiResult)
    }
    
    
    static func executeReliablyGetRequest<TContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String) -> Promise<ApiResult<TContent>> {
        return HttpClientHelper.shared.get(url: url, accessToken: apiTokenHolder.accessToken).map(toApiResult)
    }
    
    
    static func executeReliablyLitePostRequest<TRequestContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String, content: TRequestContent?) -> Promise<LiteApiResult> {
        return HttpClientHelper.shared.post(url: url, postData: content?.toJson(), accessToken: apiTokenHolder.accessToken).map(toLiteApiResult)
    }
    
    static func executeReliablyLitePostRequest(apiTokenHolder: IApiTokensHolder, url: String) -> Promise<LiteApiResult> {
        return HttpClientHelper.shared.post(url: url, accessToken: apiTokenHolder.accessToken).map(toLiteApiResult)
    }
    
    static func executeReliablyPostRequest<TRequestContent: Codable, TResponseContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String, content: TRequestContent) -> Promise<ApiResult<TResponseContent>> {
        let json = content.toJson()
        return HttpClientHelper.shared.post(url: url, postData: json, accessToken: apiTokenHolder.accessToken).map(toApiResult)
    }
    
    
    static func executeReliablyPatchRequest<TRequestContent: Codable, TResponseContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String, content: TRequestContent) -> Promise<ApiResult<TResponseContent>> {
        let json = content.toJson()!
        return HttpClientHelper.shared.patch(url: url, patchData: json, accessToken: apiTokenHolder.accessToken).map(toApiResult)
    }
        
    
    static func executeReliablyLitePatchRequest<TRequestContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String, content: TRequestContent) -> Promise<LiteApiResult> {
        return HttpClientHelper.shared.patch(url: url, patchData: content.toJson()!, accessToken: apiTokenHolder.accessToken).map(toLiteApiResult)
    }
    
    
    static func executeReliablyLiteDeleteRequest<TRequestContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String, content: TRequestContent) -> Promise<LiteApiResult> {
        return HttpClientHelper.shared.delete(url: url, deleteData: content.toJson()!, accessToken: apiTokenHolder.accessToken).map(toLiteApiResult)
    }
    
    
    static func executeReliablyDeleteRequest<TRequestContent: Codable, TResponseContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String, content: TRequestContent) -> Promise<ApiResult<TResponseContent>> {
        return HttpClientHelper.shared.delete(url: url, deleteData: content.toJson()!, accessToken: apiTokenHolder.accessToken).map(toApiResult)
    }
    
    static func executeReliablySendFileRequest<TResponseContent: Codable>(apiTokenHolder: IApiTokensHolder, url: String, file: File) -> Promise<ApiResult<TResponseContent>> {
        return HttpClientHelper.shared.sendFile(urlPath: url, fileName: file.name, data: file.data).map(toApiResult)
    }
    
    
    static func toLiteApiResult(_ response: Response<HTTPStatusCode, Data>) -> LiteApiResult {
        if response.status.isSuccessful {
            return LiteApiResult(status: .successful)
        }
        else {
            return LiteApiResult(status: response.status.toApiActionResult())
        }
    }
    
    
    static func toApiResult<TContent:Codable>(_ response: Response<HTTPStatusCode, Data>) -> ApiResult<TContent> {
        if response.status.isSuccessful {
            if response.content?.isEmpty ?? true {
                return ApiResult(status: .rejected)
            }
            let responseContent = Decode(TContent.self, json: response.content!)
            return ApiResult(status: .successful, content: responseContent)
        }
        //TODO: add error codes
        return ApiResult(status: response.status.toApiActionResult())
    }
    
    static func Decode<T: Codable>(_ type: T.Type, json: Data) -> T? {
        //        if type == String.self && json.starts(with: "\"") {
        //            return json as Any as? T
        //        }
        
        return json.toObject(type)
    }
}
