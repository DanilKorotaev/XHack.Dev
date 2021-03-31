import RxSwift

class SignInViewModel: BaseViewModel {
	private let sessionService: SessionService
    
    let email = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    let isSignInActive = BehaviorSubject<Bool>(value: false)
    let signUp = PublishSubject<Void>()
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
    
    func signIn() {
        isLoading.onNext(true)
        
        Observable
            .combineLatest(email, password, isSignInActive)
            .take(1)
            .filter { _, _, active in active }
            .map { username, password, _ in Credentials(email: username, password: password) }
            .flatMapLatest { [weak self] in self?.sessionService.signIn(credentials: $0) ?? Completable.empty() }
            .subscribe { [weak self] _ in self?.isLoading.onNext(false) }
            .disposed(by: disposeBag)
    }
    
    override func applyBinding() {
        Observable
            .combineLatest(email, password)
            .map { $0.hasNonEmptyValue()
                && $1.hasNonEmptyValue()
                && $0.isValidEmail()
            }
            .bind(to: isSignInActive)
            .disposed(by: disposeBag)
    }
}
