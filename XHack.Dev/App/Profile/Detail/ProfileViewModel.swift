
import Foundation
import RxSwift

class ProfileViewModel: BaseViewModel {
    let sessionService: SessionService
    let userApi: IUserApi
    let context: IAppContext
    let profile = BehaviorSubject<UserProfile?>(value: nil)
    let signOut = PublishSubject<Void>()
    let edit = PublishSubject<Void>()
    let bookmarks =  PublishSubject<Void>()
    let teamSelected = PublishSubject<ShortTeam>()
    
    init(sessionService: SessionService, userApi: IUserApi, messager: IMessager, context: IAppContext) {
        self.sessionService = sessionService
        self.userApi = userApi
        self.context = context
        super.init()
        _ = messager.subscribe(UpdatedProfileMessage.self, completion: MessangerSubcribeComplition { [weak self] _ in
            self?.forceContentRefreshingAsync()
        })
    }
    
    override func initialize() {
        super.initialize()
        profile.onNext(context.currentUser)
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
