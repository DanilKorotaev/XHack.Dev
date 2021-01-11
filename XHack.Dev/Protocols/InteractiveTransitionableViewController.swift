import Foundation
import UIKit

protocol InteractiveTransitionableViewController {
    var interactivePresentTransition: MiniToLargeViewInteractiveAnimator? { get }
    var interactiveDismissTransition: MiniToLargeViewInteractiveAnimator? { get }
}
