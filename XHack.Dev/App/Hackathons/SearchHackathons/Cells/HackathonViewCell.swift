
import UIKit
import RxSwift

class HackathonViewCell: UITableViewCell {
    @IBOutlet weak var hackImageView: UIImageView!
    @IBOutlet weak var hackNameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var avatarUrl: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(for model: ShortHackathon) {
        if avatarUrl != model.avatarUrl {
            hackImageView.downloaded(from: model.avatarUrl)
            avatarUrl = model.avatarUrl
        }
        
        hackNameLabel.text = model.name
//        locationLabel.text = model.location
        dateLabel.text = model.dateText
        locationImageView.isHidden = !model.isOnline
        descriptionLabel.text = model.description
    }
}
