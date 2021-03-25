
import UIKit
import RxSwift

class ProfileViewController: BaseViewController<ProfileViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.profile
    
    private var profileDisposeBag: DisposeBag!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specializationLabel: UILabel!
    @IBOutlet weak var socialsTextView: UITextView!
    @IBOutlet weak var aboutUserTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var socialView: UIView!
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var teamContainerView: UIView!
    @IBOutlet weak var tagsCollectionView: UIResizableCollectionView!
    @IBOutlet weak var tagsContainerView: UIView!
    
    override func completeUi() {
        teamTableView.register(SelectTeamViewCell.self)
        tagsCollectionView.register(TagViewCell.self)
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        dataContext.profile.subscribe(onNext: { [weak self] profile in
            guard let self = self else { return }
            self.profileDisposeBag = DisposeBag()
            self.scrollView.isHidden = profile == nil
            guard let profile = profile else { return }
            (self.specializationLabel.rx.text <- profile.specialization)
                .disposed(by: self.profileDisposeBag)
            (self.nameLabel.rx.text <- profile.name)
                .disposed(by: self.profileDisposeBag)
            self.setSocials(profile.networks)
            self.avatarImageView.downloaded(from: profile.avatarUrl)
            self.teamContainerView.isHidden = profile.teams.isEmpty
            self.tagsContainerView.isHidden = profile.tags.isEmpty
            
            profile.teams.rx_elements()
                .bind(to: self.teamTableView.rx.items(cellIdentifier: SelectTeamViewCell.reuseIdentifier)) { row, model, cell in
                    guard let cell = cell as? SelectTeamViewCell else { return }
                    cell.set(model)
                }
                .disposed(by: self.profileDisposeBag)
            
            profile.tags.rx_elements()
                .bind(to: self.tagsCollectionView.rx.items(cellIdentifier: TagViewCell.reuseIdentifier)) { row, model, cell in
                    guard let cell = cell as? TagViewCell else { return }
                    cell.set(for: model)
                }
                .disposed(by: self.profileDisposeBag)
            
        }).disposed(by: disposeBag)
        
        (dataContext.edit <- editButton.rx.tap)
            .disposed(by: disposeBag)
        
        (dataContext.signOut <- signOutButton.rx.tap)
            .disposed(by: disposeBag)
        
        (dataContext.teamSelected <- teamTableView.rx.modelSelected(ShortTeam.self))
            .disposed(by: disposeBag)
    }
    
    func setSocials(_ networks: [String]) {
        socialView.isHidden = networks.isEmpty
        self.socialsTextView.text = networks.joined(separator: "\n\n")
        socialsTextView.joinHeight(constant: socialsTextView.getRequiredTextSize().height)
    }
}
