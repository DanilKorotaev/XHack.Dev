import UIKit
import RxSwift
import RxCocoa

class SignInViewController: BaseViewController<SignInViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.signIn

    @IBOutlet weak var usernameTextField: CustomShadowTextField!
    @IBOutlet weak var passwordTextField: CustomShadowTextField!
    @IBOutlet weak var signInButton: PrimaryButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDismissKeyboard()
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        Observable.of(usernameTextField, passwordTextField)
            .flatMap { $0.rx.controlEvent(.editingDidEndOnExit) }
            .withLatestFrom(dataContext.isSignInActive)
            .filter { $0 }
            .bind { [weak self] _ in self?.dataContext?.signIn() }
            .disposed(by: disposeBag)
        
        usernameTextField.rx.text.orEmpty
            .bind(to: dataContext.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: dataContext.password)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .throttle(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.dataContext?.signIn()
            }.disposed(by: disposeBag)
        
        dataContext.isLoading
            .observeOn(MainScheduler.instance)            
            .bind { [weak self] in
                guard let self = self else { return }
                self.usernameTextField.isEnabled = !$0
                self.passwordTextField.isEnabled = !$0
            }
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: dataContext.signUp)
            .disposed(by: disposeBag)
    }
    
    override func keyboardHideHandler(_ keyboardBounds: CGRect) {
        scrollView.contentInset = .zero
    }
    
    override func keyboardShownHandler(_ keyboardBounds: CGRect) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardBounds.height, right: 0)
    }
}
