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
        autoregister(HackathonsListViewModel.self, initializer: HackathonsListViewModel.init)
        autoregister(HackathonDetailViewModel.self, initializer: HackathonDetailViewModel.init)
    }
}
