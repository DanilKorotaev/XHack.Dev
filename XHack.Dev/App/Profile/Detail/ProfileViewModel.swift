
import Foundation
import RxSwift

class ProfileViewModel: BaseViewModel {
    let sessionService: SessionService
    let userApi: IUserApi
    let profile = BehaviorSubject<UserProfile?>(value: nil)
    let signOut = PublishSubject<Void>()
    let edit = PublishSubject<Void>()
    
    init(sessionService: SessionService, userApi: IUserApi) {
        self.sessionService = sessionService
        self.userApi = userApi
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        userApi.getProfile()
            .done { result in
                if self.checkAndProcessApiResult(response: result, "загрузить информацию по пользователю") {
                    return
                }
                guard let content = result.content else { return }
                self.profile.onNext(UserProfile(content))
        }
    }
}
