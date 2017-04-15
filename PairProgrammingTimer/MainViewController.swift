//
//  MainViewController.swift
//  PairProgrammingTimer
//
//  Created by Stefan Mehnert on 11.04.17.
//  Copyright © 2017 Stefan Mehnert. All rights reserved.
//

import UIKit

class MainViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    let sessionLog = SessionLog(dateTime: SystemDateTime(), sessionLogService: SessionUserDefaultsLogService())
    
    let pages = ["SessionViewController", "SessionLogViewController"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setViewControllers(
            [(instantiateAndInitViewController(withIdentifier: pages[0]))!],
            direction: .forward,
            animated: true,
            completion: nil)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index > 0 {
                    return instantiateAndInitViewController(withIdentifier: pages[index-1])
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index < pages.count - 1 {
                    return instantiateAndInitViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                return index
            }
        }
        return 0
    }

    private func instantiateAndInitViewController(withIdentifier identifier: String) -> UIViewController? {
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) else {
            NSLog("Failed to instantiate viewController with identifier: \(identifier)")
            return nil
        }
        
        if var sessionLogConsumer = viewController as? SessionLogConsumer {
            sessionLogConsumer.sessionLog = sessionLog
        }
        
        return viewController
    }
}
