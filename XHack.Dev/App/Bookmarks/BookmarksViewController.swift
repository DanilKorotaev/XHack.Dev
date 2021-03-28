//
//  BookmarksViewController.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 28.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift

class BookmarksViewController: BaseViewController<BookmarksViewModel>, Storyboarded {
    static var storyboard = AppStoryboard.bookmarks
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pageContainer: UIView!
    @IBOutlet weak var pageBarControlView : PageBarControlView!
    
    private var selectedIndex = BehaviorSubject<Int>(value: 0)
    
    private lazy var pageViewController: UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.addChild(pageController)
        self.pageContainer.addSubview(pageController.view)
        pageController.view.joinToSuperView()
        pageController.didMove(toParent: self)
        return pageController
    }()
    
    var pages: [InnerPage]!
    
    override func completeUi() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([pages[0].view], direction: .forward, animated: true, completion: nil)
        pageBarControlView.items.onNext(pages)
        pageBarControlView.didSelectSegmentCallback.bind { [weak self] index in
            self?.setSelected(index)
        }.disposed(by: disposeBag)
    }
    
    override func applyBinding() {
        guard let dataContext = dataContext else { return }
        
        (dataContext.back <- backButton.rx.tap)
            .disposed(by: disposeBag)
        
        (selectedIndex <-> dataContext.selectedIndex)
            .disposed(by: disposeBag)
        
        (pageBarControlView.indexSelected <- dataContext.selectedIndex)
            .disposed(by: disposeBag)
    }
    
    func didScrollToPage(_ index: Int) {
        selectedIndex.onNext(index)
    }
    
    func setSelected(_ pageIndex: Int, animate: Bool = true) {
        let direction: UIPageViewController.NavigationDirection = selectedIndex.value > pageIndex ? .reverse : .forward
        pageViewController.setViewControllers([pages[pageIndex].view], direction: direction, animated: animate, completion: nil)
        selectedIndex.onNext(pageIndex)
    }
}

extension BookmarksViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.lastIndex(where: { $0.view == viewController}) else { return nil }
        if index - 1 < pages.startIndex {
            return nil
        }
        return pages[index - 1].view
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.lastIndex(where: { $0.view == viewController}) else { return nil }
        if index + 1 >= pages.endIndex {
            return nil
        }
        return pages[index + 1].view
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, completed,
              let firstVC = pageViewController.viewControllers?.first,
              let index = pages.lastIndex(where: { $0.view == firstVC})
            else { return  }
        let newIndex = index
        if selectedIndex.value != newIndex {
            didScrollToPage(newIndex)
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
}
