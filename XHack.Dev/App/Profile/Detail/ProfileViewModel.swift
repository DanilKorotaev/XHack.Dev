
import Foundation
import RxSwift

class ProfileViewModel: BaseViewModel {
    let sessionService: SessionService
    let userApi: IUserApi
    let profile = BehaviorSubject<UserProfile?>(value: nil)
    let signOut = PublishSubject<Void>()
    let edit = PublishSubject<Void>()
    let teamSelected = PublishSubject<ShortTeam>()
    
    init(sessionService: SessionService, userApi: IUserApi, messager: IMessager) {
        self.sessionService = sessionService
        self.userApi = userApi
        super.init()
        _ = messager.subscribe(UpdatedProfileMessage.self, completion: MessangerSubcribeComplition { [weak self] _ in
            self?.forceContentRefreshingAsync()
        })
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
