import Foundation
import RxSwift

class SessionService {
    enum SessionError: Error {
        case invalidToken
    }
    
    // MARK: - Private fields
    
    private let dataManager: DataManager
    private let restClient: RestClient
    private let translationsService: TranslationsService
    private let messager: IMessager
    private let signOutSubject = PublishSubject<Void>()
    private let signInSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let authApi: AuthApi
    
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
    
    init(authApi: AuthApi, dataManager: DataManager, restClient: RestClient, translationsService: TranslationsService, messanger: IMessager) {
        self.dataManager = dataManager
        self.restClient = restClient
        self.translationsService = translationsService
        self.messager = messanger
        self.authApi = authApi
        loadSession()
    }
    
    func signIn(credentials: Credentials) -> Completable {
        return Single<Void>.create { (single) -> Disposable in
            let signIn = self.authApi.singIn(creadential: SignInRequest(email: credentials.email, password: credentials.password))
            return signIn.do(onNext:{ [weak self] result in
                    single(.success(()))
                    guard let content = result.content, result.status == .successful else { return }
                    try self?.setToken(response: content)
                    try self?.setSession(email: credentials.email)
                    self?.messager.publish(message: LoginMessage())
                    self?.signInSubject.onNext(Void())
            }).subscribe()
        }.do().asCompletable()
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
        return Single<Void>.create { (single) -> Disposable in
            let signIn = self.authApi.signUp(request)
            return signIn.do(onNext:{ [weak self] result in
                single(.success(()))
                guard let content = result.content, result.status == .successful else { return }
                self?.token = Tokens(accessToken: content.token)
                try self?.setSession(email: request.email)
                self?.signInSubject.onNext(Void())
            }).subscribe()
        }.do().asCompletable()
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
        
        signInSubject.onNext(Void())
    }
    
    private func loadSession() {
        sessionState = dataManager.get(key: SettingKey.session, type: Session.self)
    }
    
    private func removeSession() {
        dataManager.clear()
        token = nil
        sessionState = nil
        signOutSubject.onNext(Void())
    }
    
    private func updateProfile(data: MeResponse) {
        //        sessionState?.updateDetails(data)
        dataManager.set(key: SettingKey.session, value: sessionState)
    }
}
