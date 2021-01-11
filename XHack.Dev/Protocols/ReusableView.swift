import Foundation
import UIKit

/// All objects, adopeted by this protocol will use the same identifier as their class's name.
protocol ReusableView: class {}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: ReusableView {}
extension UIView: ReusableView {}
