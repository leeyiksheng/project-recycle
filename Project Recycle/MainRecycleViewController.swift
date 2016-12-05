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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRecycleButtonTouchUpInside(_ sender: UIButton) {
        let transitionToRecycleGeneralNotification = Notification(name: Notification.Name(rawValue: "UserTransitionToRecycleGeneral"), object: nil, userInfo: nil)
        NotificationCenter.default.post(transitionToRecycleGeneralNotification)
    }
}
