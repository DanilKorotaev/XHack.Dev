
import UIKit
import RxSwift

class ProfileViewController: BaseViewController<ProfileViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.profile
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specializationLabel: UILabel!
    @IBOutlet weak var socialsTextView: UITextView!
    @IBOutlet weak var aboutUserTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        dataContext.profile.subscribe(onNext: { profile in
            self.scrollView.isHidden = profile == nil
            guard let profile = profile else { return }
            profile.description.bind(to: self.aboutUserTextView.rx.text).disposed(by: self.disposeBag)
            profile.name.bind(to: self.nameLabel.rx.text).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        signOutButton.rx.tap
            .bind(to: dataContext.signOut)
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .bind(to: dataContext.edit)
            .disposed(by: disposeBag)
    }
}
