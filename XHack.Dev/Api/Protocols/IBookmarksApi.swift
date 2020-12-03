//
//  IBookmarksApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 04.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

protocol IBookmarksApi {
    func getBookmarkedHackathons() -> Single<LiteApiResult>
    func getBookmarkedTeams() -> Single<LiteApiResult>
    func getBookmarkedUsers() -> Single<LiteApiResult>
    func getBookmarkedChats() -> Single<LiteApiResult>
    func getBookmarkedMessages() -> Single<LiteApiResult>
    func bookmark(hackathon: BookmarkHackathonDTO) -> Single<LiteApiResult>
    func bookmark(user: BookmarkUserDTO) -> Single<LiteApiResult>
    func bookmark(team: BookmarkTeamDTO) -> Single<LiteApiResult>
    func bookmark(chat: BookmarkChatDTO) -> Single<LiteApiResult>
    func bookmark(message: BookmarkMessageDTO) -> Single<LiteApiResult>
    func removeBookmark(hackathon: BookmarkHackathonDTO) -> Single<LiteApiResult>
    func removeBookmark(user: BookmarkUserDTO) -> Single<LiteApiResult>
    func removeBookmark(team: BookmarkTeamDTO) -> Single<LiteApiResult>
    func removeBookmark(message: BookmarkMessageDTO) -> Single<LiteApiResult>
    func removeBookmark(chat: BookmarkChatDTO) -> Single<LiteApiResult>
}
