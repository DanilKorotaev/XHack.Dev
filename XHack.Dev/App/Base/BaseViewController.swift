//
//  BaseViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 06.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController<TViewModel>: UIViewController where TViewModel:BaseViewModel {
    
    private(set) var disposeBag = DisposeBag()
    
    var dataContext: TViewModel? {
        didSet {
            guard isViewLoaded else { return }
            disposeBag = DisposeBag()
            applyBinding()
        }
    }
    
    var safeAreaInsets: UIEdgeInsets {
        let window = UIApplication.shared.windows[0]
        return window.safeAreaInsets
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataContext?.viewCreated()
        completeUi()
        applyBinding()
        dataContext?.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataContext?.viewWillAppear()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataContext?.viewWillDisappear()
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataContext?.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dataContext?.viewDidDisappear()
    }
    
    private func subscribeToKeyboardNotifications() {
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardShown))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardHidden))
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        unsubscribeFromAllNotifications()
    }
    
    @objc
    private func keyboardShown(notification: NSNotification) {
        if  let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]{
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            keyboardShownHandler(endRect)
        }
    }
    
    
    @objc
    private func keyboardHidden(notification: NSNotification) {
        if  let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]{
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            keyboardHideHandler(endRect)
        }
    }
    
    func keyboardShownHandler(_ keyboardBounds: CGRect) {
        
    }
    
    func keyboardHideHandler(_ keyboardBounds: CGRect) {
        
    }
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
//    @objc func keyboardWillShowOrHide(notification: NSNotification) {
//        if  let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
//
//            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
//            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
//            scrollView.contentInset.bottom = keyboardOverlap
//            scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
//
//            let duration = (durationValue as AnyObject).doubleValue
//            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
//            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
//                self.view.layoutIfNeeded()
//            }, completion: nil)
//        }
//    }
    
    func completeUi() { }
    
    func applyBinding() { }
}
