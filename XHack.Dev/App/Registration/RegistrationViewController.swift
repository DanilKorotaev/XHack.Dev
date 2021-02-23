
import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: BaseViewController<RegistrationViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.registration

    @IBOutlet weak var firstNameTextField: CustomShadowTextField!
    @IBOutlet weak var emailTextField: CustomShadowTextField!
    @IBOutlet weak var passwordTextField: CustomShadowTextField!
    @IBOutlet weak var signUpButton: PrimaryButton!
    @IBOutlet weak var backButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func completeUi() {
        configureDismissKeyboard()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        Observable.of(firstNameTextField, passwordTextField, emailTextField)
            .flatMap { $0.rx.controlEvent(.editingDidEndOnExit) }
            .withLatestFrom(dataContext.canContinue)
            .filter { $0 }
            .bind { [weak self] _ in self?.dataContext?.signUp() }
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: dataContext.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: dataContext.password)
            .disposed(by: disposeBag)
        
        firstNameTextField.rx.text.orEmpty
            .bind(to: dataContext.firstName)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind { [weak self] in self?.dataContext?.signUp() }
            .disposed(by: disposeBag)
        
        dataContext.canContinue
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        dataContext.isLoading
            .observeOn(MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                self.firstNameTextField.isEnabled = !$0
                self.passwordTextField.isEnabled = !$0
                self.emailTextField.isEnabled = !$0
//                self.signUpButton.isInProgress = $0
            }
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: dataContext.back)
            .disposed(by: disposeBag)
    }
}
