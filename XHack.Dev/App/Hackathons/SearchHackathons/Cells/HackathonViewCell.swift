
import UIKit
import RxSwift

class HackathonViewCell: UITableViewCell {
    
    @IBOutlet weak var hackImageView: UIImageView!
    @IBOutlet weak var hackNameLabel: UILabel!
    @IBOutlet weak var onlineImageView: UIImageView!
    @IBOutlet weak var globeImageView: UIImageView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func set(for model: ShortHackathon) {
        hackImageView.downloaded(from: model.avatarUrl, contentMode: .scaleToFill)
        
        hackNameLabel.text = model.name
        dateLabel.text = model.dateText
        locationLabel.text = model.isOnline ? "online" : model.location
        onlineImageView.isHidden = !model.isOnline
        globeImageView.isHidden = model.isOnline
        descriptionLabel.text = model.description
    }
}
