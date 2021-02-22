import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController, Storyboarded {
    static var storyboard = AppStoryboard.signIn

    @IBOutlet weak var usernameTextField: CustomShadowTextField!
    @IBOutlet weak var passwordTextField: CustomShadowTextField!
    @IBOutlet weak var signInButton: PrimaryButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: SignInViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDismissKeyboard()
        setUpBindings()
    }
    
    private func setUpBindings() {
        guard let viewModel = viewModel else { return }
        
        Observable.of(usernameTextField, passwordTextField)
            .flatMap { $0.rx.controlEvent(.editingDidEndOnExit) }
            .withLatestFrom(viewModel.isSignInActive)
            .filter { $0 }
            .bind { [weak self] _ in self?.viewModel?.signIn() }
            .disposed(by: disposeBag)
        
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .throttle(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.viewModel?.signIn()
            }.disposed(by: disposeBag)
        
        viewModel.isLoading
            .observeOn(MainScheduler.instance)            
            .bind { [weak self] in
                guard let self = self else { return }
                self.usernameTextField.isEnabled = !$0
                self.passwordTextField.isEnabled = !$0
            }
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: viewModel.signUp)
            .disposed(by: disposeBag)
    }
}
