//
//  MainRecycleViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 02/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class MainRecycleViewController: UIViewController {

    @IBOutlet weak var recycleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()


//                view.backgroundColor = UIColor.clear
//                var backgroundLayer = CAGradientLayer()
//                backgroundLayer.mainPageBackground()
//                backgroundLayer.frame = view.frame
//                view.layer.insertSublayer(backgroundLayer, at: 0)
//        
    }




    
    @IBAction func onRecycleButtonTouchUpInside(_ sender: UIButton) {
        let transitionToRecycleGeneralNotification = Notification(name: Notification.Name(rawValue: "UserTransitionToRecycleGeneral"), object: nil, userInfo: nil)
        NotificationCenter.default.post(transitionToRecycleGeneralNotification)
    }
}
