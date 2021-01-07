//
//  TeamSearchViewModel.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 07.01.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation

class TeamSearchViewModel: BaseViewModel {
    var teamsApi: ITeamsApi
    
    init(teamsApi: ITeamsApi) {
        self.teamsApi = teamsApi
    }
}
