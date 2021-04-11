import RxSwift

class SignInViewModel: BaseViewModel {
	private let sessionService: SessionService
    private let authApi: AuthApi
    private let messanger: IMessager
    
    let email = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    let isSignInActive = BehaviorSubject<Bool>(value: false)
    let signUp = PublishSubject<Void>()
    

    init(sessionService: SessionService, authApi:  AuthApi, messanger: IMessager) {
        self.sessionService = sessionService
        self.authApi = authApi
        self.messanger = messanger
    }
    
    func signIn() {
        let email = self.email.value
        let password = self.password.value
        
        if !email.hasNonEmptyValue()
            && !password.hasNonEmptyValue() {
            self.showMessage(title: "Ошибка", message: "Заполните поля")
            return
        }
        
        if !email.isValidEmail() {
            self.showMessage(title: "Ошибка", message: "Введите корректный email")
            return
        }
        
        if !password.hasNonEmptyValue() {
            self.showMessage(title: "Ошибка", message: "Введите пароль")
            return
        }
        
        isLoading.onNext(true)
        let signIn = authApi.singIn(creadential: SignInRequest(email: email, password: password))
        signIn.done{ [weak self] result in
            guard let self = self else { return }
            if self.checkAndProcessApiResult(response: result, "войти в систему") {
                return
            }
            guard let content = result.content, result.status == .successful else { return }
            self.sessionService.token = Tokens(accessToken: content.token ?? "")
            try self.sessionService.setSession(email: email)
            self.messanger.publish(message: LoginMessage())
            self.sessionService.signInSubject.onNext(Void())
        }
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
