
import UIKit
import RxSwift

class ProfileViewController: UIViewController, Storyboarded {
    static var storyboard = AppStoryboard.profile
    
    @IBOutlet weak var signOutButton: LocalizedButton!
    var viewModel: ProfileViewModel!
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    private func setUpBindings() {
        signOutButton.rx.tap
            .bind(to: viewModel.signOut)
            .disposed(by: disposeBag)
    }
}
