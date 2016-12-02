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
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        if FIRAuth.auth()?.currentUser != nil {
    
            window!.rootViewController = instantiateKelvinViewController()
            
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
    
    func observeAuthNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSignedInNotification(_:)), name: Notification.Name(rawValue: "SignedInNotification") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSignedOutNotification(_:)), name: Notification.Name(rawValue: "SignedOutNotification") , object: nil)
    }
    
    func handleSignedOutNotification(_ notification: Notification) {
        // This will only be called if user gets logged out.
        
        window!.rootViewController = instantiateLoginViewController()
    }
    
    func handleSignedInNotification(_ notification: Notification) {
        window!.rootViewController = instantiateHomeContainerViewController()
    }
    
    func instantiateHomeContainerViewController() -> HomeContainerViewController {
        let homeStoryboard = UIStoryboard.init(name: "Home", bundle: Bundle.init(identifier: "Home"))
        let homeContainerViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeContainerView")
        return homeContainerViewController as! HomeContainerViewController
    }
    
    func instantiateLoginViewController() -> LoginViewController {
        let loginSignupStoryboard = UIStoryboard.init(name: "LoginSignup", bundle: Bundle.init(identifier: "LoginSignup"))
        let loginViewController = loginSignupStoryboard.instantiateViewController(withIdentifier: "LoginView")
        return loginViewController as! LoginViewController
    }
    
    func instantiateDriverViewController() -> DriverViewController {
        let driverStoryboard = UIStoryboard.init(name: "DriverStoryboard", bundle: Bundle.init(identifier: "DriverStoryboard"))
        let driverViewController = driverStoryboard.instantiateViewController(withIdentifier: "Driver")
        return driverViewController as! DriverViewController
    }
    
    func instantiateKelvinViewController() -> RecycleGeneralViewController {
        let kelvinStoryboard = UIStoryboard.init(name: "Kelvin's Storyboard", bundle: Bundle.init(identifier: "Kelvin's Storyboard"))
        let kelvinViewController = kelvinStoryboard.instantiateViewController(withIdentifier: "RecycleGeneralViewController")
        return kelvinViewController as! RecycleGeneralViewController
    }
}
