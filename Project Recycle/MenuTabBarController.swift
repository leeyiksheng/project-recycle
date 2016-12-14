//
//  MenuTabBarController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 09/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class MenuTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.init(identifier: "Main"))
        let homeItem = homeStoryboard.instantiateViewController(withIdentifier: "Home")
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
        
        let guidePackStoryboard = UIStoryboard.init(name: "GuidePack", bundle: Bundle.init(identifier: "GuidePack"))
        let guideItem = guidePackStoryboard.instantiateViewController(withIdentifier: "Guide")
        let guideItemIcon = UITabBarItem(title: "Guide", image: UIImage(named: "redErrorIcon"), selectedImage: UIImage(named: "redErrorIcon"))
        guideItem.tabBarItem = guideItemIcon
        
        let viewControllers = [homeItem, ordersItem, guideItem, profileItem]
        self.viewControllers = viewControllers
        self.selectedViewController = self.viewControllers![0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is OrdersViewController {
            
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
