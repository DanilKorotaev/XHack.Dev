
import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController, Storyboarded {
    static var storyboard = AppStoryboard.registration

    @IBOutlet weak var firstNameTextField: LocalizedTextField!
    @IBOutlet weak var emailTextField: LocalizedTextField!
    @IBOutlet weak var passwordTextField: LocalizedTextField!
    @IBOutlet weak var signUpButton: ButtonWithProgress!

    private let disposeBag = DisposeBag()
    var viewModel: RegistrationViewModel?
    
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
        
        Observable.of(firstNameTextField, passwordTextField, emailTextField)
            .flatMap { $0.rx.controlEvent(.editingDidEndOnExit) }
            .withLatestFrom(viewModel.canContinue)
            .filter { $0 }
            .bind { [weak self] _ in self?.viewModel?.signUp() }
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        firstNameTextField.rx.text.orEmpty
            .bind(to: viewModel.firstName)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind { [weak self] in self?.viewModel?.signUp() }
            .disposed(by: disposeBag)
        
        viewModel.canContinue
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observeOn(MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                self.firstNameTextField.isEnabled = !$0
                self.passwordTextField.isEnabled = !$0
                self.emailTextField.isEnabled = !$0
                self.signUpButton.isInProgress = $0
            }
            .disposed(by: disposeBag)
    }
}
