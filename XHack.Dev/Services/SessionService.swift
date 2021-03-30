import Foundation
import RxSwift

class SessionService {
    enum SessionError: Error {
        case invalidToken
    }
    
    // MARK: - Private fields
    
    private let dataManager: DataManager
    private let accountSecureStorage: IAccountSecureStorage
    private let messager: IMessager
    private let signOutSubject = PublishSubject<Void>()
    private let signInSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let authApi: AuthApi
    private let apiTokensHolder: IApiTokensHolder
    private var token: Tokens?
    
    // MARK: - Public properties
    
    private(set) var sessionState: Session?
    
    var didSignOut: Observable<Void> {
        return signOutSubject.asObservable()
    }
    var didSignIn: Observable<Void> {
        return signInSubject.asObservable()
    }
    
    // MARK: - Public Methods
    
    init(authApi: AuthApi, dataManager: DataManager, messanger: IMessager, accountSecureStorage: IAccountSecureStorage, apiTokensHolder: IApiTokensHolder) {
        self.dataManager = dataManager
        self.messager = messanger
        self.authApi = authApi
        self.accountSecureStorage = accountSecureStorage
        self.apiTokensHolder = apiTokensHolder
        loadSession()
    }
    
    func signIn(credentials: Credentials) -> Completable {
        let signIn = self.authApi.singIn(creadential: SignInRequest(email: credentials.email, password: credentials.password))
        signIn.done{ [weak self] result in
            guard let content = result.content, result.status == .successful else { return }
            try self?.setToken(response: content)
            try self?.setSession(email: credentials.email)
            self?.messager.publish(message: LoginMessage())
            self?.signInSubject.onNext(Void())
        }
        return Completable.empty()
    }
    
    func signOut() -> Completable {
        return Single.create { (single) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                single(.success(()))
            }
            return Disposables.create()
        }.do(onSuccess: { [weak self] in
            self?.removeSession()
            self?.messager.publish(message: SignOutMessage())
        }).asCompletable()
    }
    
    func signUp(request: SignUpRequest) -> Completable {
        let signIn = self.authApi.signUp(request)
        return Single<Any>.create { (single) -> Disposable in
            signIn.done{ [weak self] result in
                single(.success(()))
                guard let content = result.content, result.status == .successful else { return }
                self?.token = Tokens(accessToken: content.token)
                try self?.setSession(email: request.email)
                self?.signInSubject.onNext(Void())
            }
            return Disposables.create()
        }.asCompletable()
        
    }
    
    //    func refreshProfile() -> Single<MeResponse> {
    //        let fetchMe = restClient.request(SessionEndpoints.FetchMe())
    //
    //        return fetchMe
    //            .do(onSuccess: { [weak self] in self?.updateProfile(data: $0) })
    //    }
    
    // MARK: - Session Management
    
    private func setToken(response: SignInResponse) throws {
        guard let accessToken = response.token else {
            throw SessionError.invalidToken
        }
        
        token = Tokens(accessToken: accessToken)
    }
    
    private func setSession(email: String) throws {
        guard let token = token else {
            throw SessionError.invalidToken
        }
        
        sessionState = Session(
            token: token,
            email: email.lowercased())
        
        dataManager.set(key: SettingKey.session, value: sessionState)
        accountSecureStorage.saveLogin(login: email)
        accountSecureStorage.saveTokens(token: token)
        apiTokensHolder.restoreTokensFromCashe()
        signInSubject.onNext(Void())
    }
    
    private func loadSession() {
        sessionState = dataManager.get(key: SettingKey.session, type: Session.self)
    }
    
    private func removeSession() {
        accountSecureStorage.clearStorage()
        dataManager.clear()
        apiTokensHolder.clearToken()
        token = nil
        sessionState = nil
        signOutSubject.onNext(Void())
    }
    
    private func updateProfile(data: MeResponse) {
        //        sessionState?.updateDetails(data)
        dataManager.set(key: SettingKey.session, value: sessionState)
    }
}
