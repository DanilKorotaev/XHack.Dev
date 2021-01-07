import Swinject

extension Container {
    func registerCoordinators() {
        autoregister(AppCoordinator.self, initializer: AppCoordinator.init)
        autoregister(SignInCoordinator.self, initializer: SignInCoordinator.init)
        autoregister(DrawerMenuCoordinator.self, initializer: DrawerMenuCoordinator.init)
        autoregister(DashboardCoordinator.self, initializer: DashboardCoordinator.init)
        autoregister(OnBoardingCoordinator.self, initializer: OnBoardingCoordinator.init)
        autoregister(SettingsCoordinator.self, initializer: SettingsCoordinator.init)
        autoregister(TaskDetailCoordinator.self, initializer: TaskDetailCoordinator.init)
        autoregister(RegistrationCoordinator.self, initializer: RegistrationCoordinator.init)
        autoregister(RootTabBarCoordinator.self, initializer: RootTabBarCoordinator.init)
        autoregister(HomeCoordinator.self, initializer: HomeCoordinator.init)
        autoregister(ProfileCoordinator.self, initializer: ProfileCoordinator.init)
        autoregister(TeamListCoordonator.self, initializer: TeamListCoordonator.init)
        autoregister(CreateTeamCoordinator.self, initializer: CreateTeamCoordinator.init)
        autoregister(SearchHackathonsCoordinator.self, initializer: SearchHackathonsCoordinator.init)
        autoregister(HackathonDetailCoordinator.self, initializer: HackathonDetailCoordinator.init)
        autoregister(ChatListCoordinator.self, initializer: ChatListCoordinator.init)
        autoregister(ChooseSearchCategoryCoordinator.self, initializer: ChooseSearchCategoryCoordinator.init)
        autoregister(HackathonListCoordinator.self, initializer: HackathonListCoordinator.init)
        autoregister(TeamSearchCoordinator.self, initializer: TeamSearchCoordinator.init)
        autoregister(TeammateSearchCoordinator.self, initializer: TeammateSearchCoordinator.init)
    }
}
