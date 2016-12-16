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
        
        self.tabBar.addDropShadow()
        
        let homeItem = RecycleGeneralViewController()
        let homeItemIcon = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        homeItem.tabBarItem = homeItemIcon
        
        let profileStoryboard = UIStoryboard.init(name: "Profile", bundle: Bundle.init(identifier: "Profile"))
        let profileItem = profileStoryboard.instantiateViewController(withIdentifier: "Profile")
        let profileItemIcon = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
        profileItem.tabBarItem = profileItemIcon
        
        let ordersStoryboard = UIStoryboard.init(name: "Orders", bundle: Bundle.init(identifier: "Orders"))
        let ordersItem = ordersStoryboard.instantiateViewController(withIdentifier: "Orders")
        let ordersItemIcon = UITabBarItem(title: "Orders", image: UIImage(named: "orders"), selectedImage: UIImage(named: "orders"))
        ordersItem.tabBarItem = ordersItemIcon
        
       
        let guideViewController = GuideViewController()
        let guideItem = UINavigationController(rootViewController: guideViewController)
        let guideItemIcon = UITabBarItem(title: "Guide", image: UIImage(named: "guide"), selectedImage: UIImage(named: "guide"))
        guideItem.tabBarItem = guideItemIcon
        
        let viewControllers = [homeItem, ordersItem, guideItem, profileItem]
        self.viewControllers = viewControllers
        self.selectedViewController = self.viewControllers![0]
        self.tabBar.barTintColor = UIColor.viewLightGray
        self.tabBar.tintColor = UIColor.black
        self.tabBar.selectedItem?.badgeColor = UIColor.black
        self.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "San Francisco Text", size: 12)!], for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
