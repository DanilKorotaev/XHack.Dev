//
//  IBookmarksApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

protocol IBookmarksApi {
    func getBookmarkedHackathons() -> Promise<ApiResult<[ShortHackathonDto]>>
    func getBookmarkedTeams() -> Promise<ApiResult<[TeamDto]>>
    func getBookmarkedUsers() -> Promise<ApiResult<[ShortUserDto]>>
    func getBookmarkedChats() -> Promise<LiteApiResult>
    func getBookmarkedMessages() -> Promise<LiteApiResult>
    func bookmark(hackathon: BookmarkHackathonDTO) -> Promise<LiteApiResult>
    func bookmark(user: BookmarkUserDTO) -> Promise<LiteApiResult>
    func bookmark(team: BookmarkTeamDTO) -> Promise<LiteApiResult>
    func bookmark(chat: BookmarkChatDTO) -> Promise<LiteApiResult>
    func bookmark(message: BookmarkMessageDTO) -> Promise<LiteApiResult>
    func removeBookmark(hackathon: BookmarkHackathonDTO) -> Promise<LiteApiResult>
    func removeBookmark(user: BookmarkUserDTO) -> Promise<LiteApiResult>
    func removeBookmark(team: BookmarkTeamDTO) -> Promise<LiteApiResult>
    func removeBookmark(message: BookmarkMessageDTO) -> Promise<LiteApiResult>
    func removeBookmark(chat: BookmarkChatDTO) -> Promise<LiteApiResult>
}
