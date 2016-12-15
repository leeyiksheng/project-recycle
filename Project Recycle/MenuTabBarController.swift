//
//  MenuTabBarController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 09/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class MenuTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeItem = RecycleGeneralViewController()
        let homeItemIcon = UITabBarItem(title: "Home", image: UIImage(named: "redErrorIcon"), selectedImage: UIImage(named: "redErrorIcon"))
        homeItem.tabBarItem = homeItemIcon
        
        let profileStoryboard = UIStoryboard.init(name: "Profile", bundle: Bundle.init(identifier: "Profile"))
        let profileItem = profileStoryboard.instantiateViewController(withIdentifier: "Profile")
        let profileItemIcon = UITabBarItem(title: "Profile", image: UIImage(named: "redErrorIcon"), selectedImage: UIImage(named: "redErrorIcon"))
        profileItem.tabBarItem = profileItemIcon
        
        let ordersStoryboard = UIStoryboard.init(name: "Orders", bundle: Bundle.init(identifier: "Orders"))
        let ordersItem = ordersStoryboard.instantiateViewController(withIdentifier: "Orders")
        let ordersItemIcon = UITabBarItem(title: "Orders", image: UIImage(named: "redErrorIcon"), selectedImage: UIImage(named: "redErrorIcon"))
        ordersItem.tabBarItem = ordersItemIcon
        
       
        let guideViewController = GuideViewController()
        let guideItem = UINavigationController(rootViewController: guideViewController)
        let guideItemIcon = UITabBarItem(title: "Guide", image: UIImage(named: "redErrorIcon"), selectedImage: UIImage(named: "redErrorIcon"))
        guideItem.tabBarItem = guideItemIcon
        
        let viewControllers = [homeItem, ordersItem, guideItem, profileItem]
        self.viewControllers = viewControllers
        self.selectedViewController = self.viewControllers![0]
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is OrdersViewController {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
