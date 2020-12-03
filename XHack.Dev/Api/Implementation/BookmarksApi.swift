//
//  BookmarksApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class BookmarksApi: IBookmarksApi {
    
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints, apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    
    func getBookmarkedHackathons() -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/get-bookmarked-hackathons"
        return ApiHelpers.executeReliablyEmptyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func getBookmarkedTeams() -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/get-bookmarked-teams"
        return ApiHelpers.executeReliablyEmptyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func getBookmarkedUsers() -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/get-bookmarked-users"
        return ApiHelpers.executeReliablyEmptyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func getBookmarkedChats() -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/get-bookmarked-chats"
        return ApiHelpers.executeReliablyEmptyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func getBookmarkedMessages() -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api​/bookmarks​/get-bookmarked-messages"
        return ApiHelpers.executeReliablyEmptyGetRequest(apiTokenHolder: apiTokenHolder, url: url)
    }
    
    func bookmark(hackathon: BookmarkHackathonDTO) -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/bookmark-hackathon"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: hackathon)
    }
    
    func bookmark(user: BookmarkUserDTO) -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/bookmark-user"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: user)
    }
    
    func bookmark(team: BookmarkTeamDTO) -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/bookmark-team"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: team)
    }
    
    func bookmark(chat: BookmarkChatDTO) -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/bookmark-chat"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: chat)
    }
    
    func bookmark(message: BookmarkMessageDTO) -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/bookmark-message"
        return ApiHelpers.executeReliablyLitePostRequest(apiTokenHolder: apiTokenHolder, url: url, content: message)
    }
    
    func removeBookmark(hackathon: BookmarkHackathonDTO) -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/remove-hackathon-bookmark"
        return ApiHelpers.executeReliablyLiteDeleteRequest(apiTokenHolder: apiTokenHolder, url: url, content: hackathon)
    }
    
    func removeBookmark(user: BookmarkUserDTO) -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/remove-hackathon-user"
        return ApiHelpers.executeReliablyLiteDeleteRequest(apiTokenHolder: apiTokenHolder, url: url, content: user)
    }
    
    func removeBookmark(team: BookmarkTeamDTO) -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/remove-hackathon-team"
        return ApiHelpers.executeReliablyLiteDeleteRequest(apiTokenHolder: apiTokenHolder, url: url, content: team)
    }
    
    func removeBookmark(message: BookmarkMessageDTO) -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/remove-hackathon-message"
        return ApiHelpers.executeReliablyLiteDeleteRequest(apiTokenHolder: apiTokenHolder, url: url, content: message)
    }
    
    func removeBookmark(chat: BookmarkChatDTO) -> Single<LiteApiResult> {
        let url = endpointsProvider.gatewayUrl + "/api/bookmarks/remove-hackathon-chat"
        return ApiHelpers.executeReliablyLiteDeleteRequest(apiTokenHolder: apiTokenHolder, url: url, content: chat)
    }
}
