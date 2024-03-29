import Foundation
import UIKit

class TeamToHackDetailsTransitionCoordinator: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: Properties
    
    var toViewController: HackathonDetailViewController?
    lazy var toViewControllerInitialYPosition: CGFloat = {
//        let bottomTriggerViewHeight: CGFloat = fromViewControllerGestureView?.frame.height ?? 0
//        let cardsViewYPosition = self.toViewController?.cardsView.frame.minY ?? 0
//        let y = bottomTriggerViewHeight + cardsViewYPosition
        return 546//y
    }()
    lazy var bottomTriggerImageViewHeight: CGFloat = 100 //toViewController?.cardImageViewHeight ?? 0
    var interactivePresentTransition: MiniToLargeViewInteractiveAnimator?
    var interactiveDismissTransition: MiniToLargeViewInteractiveAnimator?
    var fromViewControllerGestureView: UIView?
    
    // MARK: Methods
    
    func prepareViewForCustomTransition(fromViewController: TeamSearchViewController) {
        if self.toViewController != nil { return }
        let toViewController = HackathonDetailViewController.instantiate()
        toViewController.transitioningDelegate = self
        toViewController.modalPresentationStyle = .custom
        interactivePresentTransition = MiniToLargeViewInteractiveAnimator(fromViewController: fromViewController, toViewController: toViewController, gestureView: fromViewController.bottomTriggerView)
        interactiveDismissTransition = MiniToLargeViewInteractiveAnimator(fromViewController: toViewController, toViewController: nil, gestureView: toViewController.view)
        self.toViewController = toViewController
        self.fromViewControllerGestureView = fromViewController.bottomTriggerView
    }
    
    func removeCustomTransitionBehaviour() {
        interactivePresentTransition = nil
        interactiveDismissTransition = nil
        toViewController = nil
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MiniToLargePresentingViewAnimator(initialY: toViewControllerInitialYPosition)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MiniToLargeDismissingViewAnimator(initialY: toViewControllerInitialYPosition)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let presentInteractor = interactivePresentTransition else {
            return nil
        }
        guard presentInteractor.isTransitionInProgress else {
            return nil
        }
        return presentInteractor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let dismissInteractor = interactiveDismissTransition else {
            return nil
        }
        guard dismissInteractor.isTransitionInProgress else {
            return nil
        }
        return dismissInteractor
    }
}
