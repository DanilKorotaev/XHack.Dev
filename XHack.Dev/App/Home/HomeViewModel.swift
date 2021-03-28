
import Foundation
import RxSwift

class HomeViewModel: BaseViewModel, RefreshableContentHost {
    
    let requestsApi: IRequestsApi
    let usersApi: IUserApi
    let context: IAppContext
    
    let refresh = PublishSubject<Void>()
    let isRefreshing = BehaviorSubject<Bool>(value: false)
    
    let changeSearchableState = PublishSubject<Bool>()
    let isAvailableForSearching: BehaviorSubject<Bool>
    let requestSelected = PublishSubject<ParticipantRequestable>()
    let requestSections = BehaviorSubject<[RequestSection]>(value: [])
    let SentRequest = PublishSubject<Void>()
    
    init(requestsApi: IRequestsApi, usersApi: IUserApi, context: IAppContext) {
        self.requestsApi = requestsApi
        self.usersApi = usersApi
        self.context = context
        isAvailableForSearching = BehaviorSubject(value: context.currentUser?.isAvailableForSearching.value ?? false)
    }
    
    override func refreshContent(operationArgs: IOperationStateControl) {
        if operationArgs.isManuallyTriggered {
            isRefreshing.onNext(true)
        } else {
            isLoading.onNext(true)
        }
        
        requestsApi.getActiveIncomingRequests().done { [weak self] (result) in
            guard let self = self else { return }
            self.isRefreshing.onNext(false)
            self.isLoading.onNext(false)
            if self.checkAndProcessApiResult(response: result, "загрузить список входящих запросов") {
                return
            }
            guard let requests = result.content else {
                self.showMessage(title: "Ошибка", message: "Не удалось загрузить список входящих запросов")
                return
            }
            let fromTeam = RequestSection("Запросы от команд", requests.fromTeams.map { IncomingRequest($0) }.filter { $0.type != .none})
            let fromUsers = RequestSection("Запросы от пользователей", requests.fromUsers.map { IncomingRequest($0) }.filter { $0.type != .none})
            var requestSections: [RequestSection] = []
            if (!fromTeam.items.isEmpty) {
                requestSections.append(fromTeam)
            }
            if (!fromUsers.items.isEmpty) {
                requestSections.append(fromUsers)
            }
            self.requestSections.onNext(requestSections)
        }
    }
    
    override func applyBinding() {
        refresh.bind { _ in
            self.forceContentRefreshingAsync(operationArgs: OperationStateControl.ManuallyTriggered)
        }.disposed(by: disposeBag)
        
        changeSearchableState.bind { active in
            self.usersApi.setSearchingStatus(active).done { (result) in
                if self.checkAndProcessApiResult(response: result, "обновить статус") {
                    return
                }
            }
        }.disposed(by: disposeBag)
    }
}
