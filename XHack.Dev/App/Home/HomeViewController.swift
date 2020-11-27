
import UIKit

class HomeViewController: UIViewController, Storyboarded {
    static var storyboard = AppStoryboard.home
    
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
