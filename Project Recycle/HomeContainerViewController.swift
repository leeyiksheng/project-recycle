//
//  HomeContainerViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 28/11/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

enum SlideOutState {
    case BothCollapsed
    case MenuPanelExpanded
    case RightPanelExpanded
}

class HomeContainerViewController: UIViewController {
    
    var homeNavigationController: UINavigationController!
    var homeViewController: HomeViewController!
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForHomeViewController(shouldShowShadow: shouldShowShadow)
        }
    }
    var menuPanelViewController: MenuPanelViewController?
    
    let homePanelExpandedOffset: CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewController = UIStoryboard.homeViewController()
        homeViewController.delegate = self
        
        // wrap the homeViewController in a navigation controller, so that views can be pushed to it
        // and display bar button items in the navigation bar
        
        homeNavigationController = UINavigationController(rootViewController: homeViewController)
        view.addSubview(homeNavigationController.view)
        addChildViewController(homeNavigationController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeContainerViewController: HomeViewControllerDelegate {
    func toggleMenuPanel() {
        let notAlreadyExpanded = (currentState != .MenuPanelExpanded)
        
        if notAlreadyExpanded {
            addMenuPanelViewController()
        }
        
        animateMenuPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        
    }
    
    func addMenuPanelViewController() {
        if (menuPanelViewController == nil) {
            menuPanelViewController = UIStoryboard.menuPanelViewController()
            
            addChildSidePanelController(menuPanelController: menuPanelViewController!)
        }
    }
    
    func addChildSidePanelController(menuPanelController: MenuPanelViewController) {
        view.insertSubview(menuPanelController.view, at: 0)
        
        addChildViewController(menuPanelController)
        menuPanelController.didMove(toParentViewController: self)
    }
    
    func animateMenuPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .MenuPanelExpanded
            
            animateHomePanelXPosition(targetPosition : homeNavigationController.view.frame.width - homePanelExpandedOffset)
        } else {
            animateHomePanelXPosition(targetPosition: 0) { (finished) in
                self.currentState = .BothCollapsed
                
                self.menuPanelViewController!.view.removeFromSuperview()
                self.menuPanelViewController = nil
            }
        }
    }
    
    func animateHomePanelXPosition(targetPosition: CGFloat, completion: ((Bool) ->Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.homeNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func showShadowForHomeViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            homeNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            homeNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Home", bundle: Bundle.main) }
    
    class func menuPanelViewController() -> MenuPanelViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MenuPanelView") as? MenuPanelViewController
    }
    
    class func homeViewController() -> HomeViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeView") as? HomeViewController
    }
}

extension UIViewController {
    func instantiateHomeContainerViewController() -> HomeContainerViewController {
        let homeStoryboard = UIStoryboard.init(name: "Home", bundle: Bundle.main)
        let homeContainerViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeContainerView")
        return homeContainerViewController as! HomeContainerViewController
    }
}
