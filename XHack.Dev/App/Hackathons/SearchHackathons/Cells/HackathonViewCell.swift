
import UIKit
import RxSwift

class HackathonViewCell: UITableViewCell {
    
    private var disposeBag: DisposeBag!
    
    @IBOutlet weak var hackImageView: UIImageView!
    @IBOutlet weak var hackNameLabel: UILabel!
    @IBOutlet weak var onlineImageView: UIImageView!
    @IBOutlet weak var globeImageView: UIImageView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        tagCollectionView.register(TagViewCell.self)
    }

    func set(for model: ShortHackathon) {
        disposeBag = DisposeBag()
        hackImageView.downloaded(from: model.avatarUrl)
        
        hackNameLabel.text = model.name
        dateLabel.text = model.dateText
        locationLabel.text = model.isOnline ? "online" : model.location
        onlineImageView.isHidden = !model.isOnline
        globeImageView.isHidden = model.isOnline
        descriptionLabel.text = model.description
        
        model.tags.rx_elements()
            .bind(to: self.tagsCollectionView.rx.items(cellIdentifier: TagViewCell.reuseIdentifier)) { row, model, cell in
                guard let cell = cell as? TagViewCell else { return }
                cell.set(for: model)
            }
            .disposed(by: disposeBag)
    }
}
