import Foundation
import RxSwift

class DashboardViewModel {
    private let sessionService: SessionService
    private let disposeBag = DisposeBag()
    private let restClient: RestClient
    
    let title = "Dashboard".localized
    let isLoading = BehaviorSubject(value: true)
    var tasks = BehaviorSubject(value: [String]())
    var didSelectTask = PublishSubject<String>()
    
    init(sessionService: SessionService, restClient: RestClient) {
        self.sessionService = sessionService
        self.restClient = restClient
        
//        sessionService.refreshProfile()
//            .subscribe()
//            .disposed(by: disposeBag)
        setUpBinding()
        fetchTasks()
    }
    
    private func setUpBinding() {
        
    }
        
    private func fetchTasks() {
        isLoading.onNext(true)
        restClient.request(TasksEndpoints.FetchTasks())
            .asDriver(onErrorJustReturn: [String]())
            .do(onNext: { [weak self] _ in self?.isLoading.onNext(false) })
            .drive(tasks)
            .disposed(by: disposeBag)
    }
}
