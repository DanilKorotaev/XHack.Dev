import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerViewModels() {
        autoregister(SignInViewModel.self, initializer: SignInViewModel.init)
        autoregister(DrawerMenuViewModel.self, initializer: DrawerMenuViewModel.init)
        autoregister(DashboardViewModel.self, initializer: DashboardViewModel.init)
        autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
        autoregister(RegistrationViewModel.self, initializer: RegistrationViewModel.init)
        autoregister(SetNameViewModel.self, initializer: SetNameViewModel.init)
        autoregister(SetOptionsViewModel.self, initializer: SetOptionsViewModel.init)
        autoregister(TaskDetailViewModel.self, initializer: TaskDetailViewModel.init)
        autoregister(HomeViewModel.self, initializer: HomeViewModel.init)
        autoregister(ProfileViewModel.self, initializer: ProfileViewModel.init)
        autoregister(TeamListViewModel.self, initializer: TeamListViewModel.init)
        autoregister(CreateTeamViewModel.self, initializer: CreateTeamViewModel.init)
        autoregister(SearchHackathonsViewModel.self, initializer: SearchHackathonsViewModel.init)
        autoregister(HackathonDetailViewModel.self, initializer: HackathonDetailViewModel.init)
        autoregister(ChatListViewModel.self, initializer: ChatListViewModel.init)
        autoregister(ChooseSearchCategoryViewModel.self, initializer: ChooseSearchCategoryViewModel.init)
        autoregister(HackathonListViewModel.self, initializer: HackathonListViewModel.init)
        autoregister(TeamSearchViewModel.self, initializer: TeamSearchViewModel.init)
        autoregister(TeammateSearchViewModel.self, initializer: TeammateSearchViewModel.init)
        autoregister(HackFilterDialogViewModel.self, initializer: HackFilterDialogViewModel.init)
        autoregister(EditProfileViewModel.self, initializer: EditProfileViewModel.init)
        autoregister(HackMemberListViewModel.self, initializer: HackMemberListViewModel.init)
        autoregister(HackTeamListViewModel.self, initializer: HackTeamListViewModel.init)
        autoregister(HackTeamDetailsViewModel.self, initializer: HackTeamDetailsViewModel.init)
        autoregister(StartUpScreenViewModel.self, initializer: StartUpScreenViewModel.init)
        autoregister(UserDetailsViewModel.self, initializer: UserDetailsViewModel.init)
        autoregister(ChatViewModel.self, initializer: ChatViewModel.init)
        autoregister(UserRequestsViewModel.self, initializer: UserRequestsViewModel.init)
        autoregister(SelectTeamViewModel.self, initializer: SelectTeamViewModel.init)
        autoregister(SentRequestViewModel.self, initializer: SentRequestViewModel.init)
        autoregister(BookmarksViewModel.self, initializer: BookmarksViewModel.init)
        autoregister(BookmarkedHacksViewModel.self, initializer: BookmarkedHacksViewModel.init)
        autoregister(BookmarkedTeamsViewModel.self, initializer: BookmarkedTeamsViewModel.init)
        autoregister(BookmarkedUsersViewModel.self, initializer: BookmarkedUsersViewModel.init)
        autoregister(SelectTagsViewModel.self, initializer: SelectTagsViewModel.init)
        autoregister(HackFiltersViewModel.self, initializer: HackFiltersViewModel.init)
    }
}
