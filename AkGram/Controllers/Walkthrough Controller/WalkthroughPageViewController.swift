//
//  WalkthroughPageViewController.swift
//  AkGram
//
//  Created by Amg on 27/05/2019.
//  Copyright © 2019 Amg-Industries. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController {
    //MARK: - Vars
    var contentText = ["Welcome to a New Instagram will created by Amg", "You can share a posts photo and video with your friends in Realtime", "Make your profile and let's go"]

    var backgroundImages = ["background1", "background2","background3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        checkStartingVC()
    }
}

extension WalkthroughPageViewController: UIPageViewControllerDataSource {
    //MARK: - Page View Controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as? WalkthroughViewController)?.index ?? 0
        index += 1
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as? WalkthroughViewController)?.index ?? 0
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    func viewControllerAtIndex(index: Int) -> WalkthroughViewController? {
        if index < 0 || index >= contentText.count {
            return nil
        }
        
        if let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
        pageContentVC.contentText = contentText[index]
        pageContentVC.index = index
        pageContentVC.backgroundImage = backgroundImages[index]
            return pageContentVC
        }
        
        return nil
    }
    
    private func checkStartingVC() {
        if let startingVC = viewControllerAtIndex(index: 0) {
            setViewControllers([startingVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func forward(index: Int) {
        if let nextVC = viewControllerAtIndex(index: index + 1) {
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        }
    }
}
