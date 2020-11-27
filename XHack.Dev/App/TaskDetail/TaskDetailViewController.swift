
import Foundation
import UIKit

class TaskDetailViewController: UIViewController, Storyboarded {
    static var storyboard: AppStoryboard = .taskDetail
    
    var viewModel: TaskDetailViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDismissKeyboard()
        setUpBindings()
    }
    
    private func setUpBindings() {
        
    }
}
