//
//  AppDelegate.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 28/11/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
//        try! FIRAuth.auth()?.signOut()

        if FIRAuth.auth()?.currentUser != nil {

            window!.rootViewController = instantiateMenuTabBarController()

            FIRAuth.auth()?.addStateDidChangeListener { auth, user in
                if user != nil {
                    return
                } else {
                    let signedOutAlert = UIAlertController.init(title: "Signed Out", message: "You have been signed out from Project Recycle. Please login again.", preferredStyle: .alert)
                    let okAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
                        let signedOutNotification = Notification(name: Notification.Name(rawValue: "SignedOutNotification"), object: nil, userInfo: nil)
                        NotificationCenter.default.post(signedOutNotification)
                    })
                    signedOutAlert.addAction(okAlertAction)
                    self.window!.rootViewController?.present(signedOutAlert, animated: true, completion: nil)
                }
            }

        } else {
            window!.rootViewController = instantiateLoginViewController()
        }
        
        window!.makeKeyAndVisible()
        
        observeAuthNotification()
        observeTransitionNotification()
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    func observeAuthNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSignedInNotification(_:)), name: Notification.Name(rawValue: "SignedInNotification") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSignedOutNotification(_:)), name: Notification.Name(rawValue: "SignedOutNotification") , object: nil)
    }
    
    func observeTransitionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserTransitionToRecycleGeneralViewController), name: Notification.Name(rawValue: "UserTransitionToRecycleGeneral"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserTransitionToProfileViewController), name: Notification.Name(rawValue: "UserTransitionToProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserTransitionToGuideViewController), name: Notification.Name(rawValue: "UserTransitionToGuide"), object: nil)

    }
    
    func handleSignedOutNotification(_ notification: Notification) {
        window!.rootViewController = instantiateLoginViewController()
    }
    
    func handleSignedInNotification(_ notification: Notification) {
        window!.rootViewController = instantiateMenuTabBarController()
    }
    
    func handleUserTransitionToRecycleGeneralViewController(_ notification: Notification) {
        window!.rootViewController?.present(instantiateKelvinViewController(), animated: true, completion: nil)
    }
    
    func handleUserTransitionToProfileViewController(_ notification: Notification) {
        window!.rootViewController?.present(instantiateUserViewController(), animated: true, completion: nil)
    }
    
    func handleUserTransitionToGuideViewController(_ notification: Notification) {
        window!.rootViewController?.present(instatiateGuideViewController(), animated: true, completion: nil)
    }
}

extension AppDelegate {
    func instantiateMenuTabBarController() -> MenuTabBarController {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.init(identifier: "Main"))
        let menuTabBarController = mainStoryboard.instantiateViewController(withIdentifier: "Menu Tab Bar")
        return menuTabBarController as! MenuTabBarController
    }
    
    func instantiateLoginViewController() -> LoginViewController {
        let loginViewController = LoginViewController()
        return loginViewController
    }
    
    func instantiateDriverViewController() -> DriverViewController {
        let driverStoryboard = UIStoryboard.init(name: "DriverStoryboard", bundle: Bundle.init(identifier: "DriverStoryboard"))
        let driverViewController = driverStoryboard.instantiateViewController(withIdentifier: "Driver")
        return driverViewController as! DriverViewController
    }
    
    func instantiateKelvinViewController() -> RecycleGeneralViewController {
        let kelvinViewController = RecycleGeneralViewController()
        return kelvinViewController
    }
    
    func instantiateUserViewController() -> ProfileViewController {
        let userStoryboard = UIStoryboard.init(name: "Profile", bundle: Bundle.init(identifier: "Profile"))
        let userViewController = userStoryboard.instantiateViewController(withIdentifier: "Profile")
        return userViewController as! ProfileViewController
    }
    
    func instatiateGuideViewController() -> UINavigationController {
        let guideViewController = GuideViewController()
        let navController = UINavigationController(rootViewController: guideViewController)
        return navController
    }
}
