import Foundation
import UIKit

class AlertDispatcher: IAlertDispatcher {
    private var message: AlertDialogMessage?
    
    func dispatch(message: AlertDialogMessage) {
        guard self.message != message else { return }
        self.message = message
        onMainThread {
            if let viewController = UIApplication.shared.keyWindow?.rootViewController {
                showAlert(on: viewController, message: message)
            }
        }
    }
    
    private func showAlert(on viewController: UIViewController, message: AlertDialogMessage) {
        let alert = UIAlertController(title: message.title, message: message.message, preferredStyle: message.style)
        
        for button in message.dialogActions {
            let style: UIAlertAction.Style = button.isAccented ? .default : .cancel
            let alertAction = UIAlertAction(title: button.title, style:  style) { [weak self] _ in
                button.action?()
                self?.message = nil
            }
            
            alert.addAction(alertAction)
        }
        viewController.presentOnTop(alert, animated: true)
    }
}
