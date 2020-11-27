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
    
    private var token: Token?
    
    // MARK: - Public properties
    
    private(set) var sessionState: Session?
    
    var didSignOut: Observable<Void> {
        return signOutSubject.asObservable()
    }
    var didSignIn: Observable<Void> {
        return signInSubject.asObservable()
    }
    
    // MARK: - Public Methods
    
    init(dataManager: DataManager, restClient: RestClient, translationsService: TranslationsService, messanger: IMessager) {
        self.dataManager = dataManager
        self.restClient = restClient
        self.translationsService = translationsService
        self.messager = messanger
        loadSession()
    }
    
    func signIn(credentials: Credentials) -> Completable {
        let signIn = restClient.request(SessionEndpoints.SignIn(credentials: credentials))
        
        return signIn
            .do(onSuccess: { [weak self] in
                try self?.setToken(response: $0)
                try self?.setSession(email: credentials.email)
                self?.messager.publish(message: LoginMessage())
                self?.signInSubject.onNext(Void())
            })
            .asCompletable()
    }
    
    func signOut() -> Completable {
        let signOut = restClient.request(SessionEndpoints.SignOut())
        
        return signOut
            .do(onSuccess: { [weak self] _ in
                self?.removeSession()
                self?.messager.publish(message: SignOutMessage())
            })
            .asCompletable()
    }
    
    func signUp(request: SignUpRequest) -> Completable {
        let signUp = restClient.request(SessionEndpoints.SignUp(content: request))
        
        return signUp
            .do(onSuccess: { [weak self] _ in
                self?.token = Token(token: "", tokenType: "Bearer")
                self?.signInSubject.onNext(Void())
            })
            .asCompletable()
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
        
        token = Token(token: accessToken, tokenType: "Bearer")
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
