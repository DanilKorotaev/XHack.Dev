import Foundation
import RxSwift

class RegistrationViewModel {
    private let sessionService: SessionService
    private let disposeBag = DisposeBag()
    
    let email = BehaviorSubject<String>(value: "")
    let firstName = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    let canContinue = BehaviorSubject<Bool>(value: false)
    let isLoading = BehaviorSubject<Bool>(value: false)
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
        setUpBindings()
    }
    
    func signUp() {
        isLoading.onNext(true)
        
        Observable
            .combineLatest(email, password, firstName, canContinue)
            .take(1)
            .filter { _, _, _, active in active }
            .map { email, password, firstName, _ in SignUpRequest(email: email, password: password, name: firstName) }
            .flatMapLatest { [weak self] in self?.sessionService.signUp(request: $0) ?? Completable.empty() }
            .subscribe { [weak self] _ in self?.isLoading.onNext(false) }
            .disposed(by: disposeBag)
    }
    
    private func setUpBindings() {
        Observable
            .combineLatest(email, password)
            .map { $0.hasNonEmptyValue() && $1.hasNonEmptyValue() }
            .bind(to: canContinue)
            .disposed(by: disposeBag)
    }
}
