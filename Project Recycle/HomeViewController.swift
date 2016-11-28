//
//  HomeViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 28/11/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var recycleButton: UIButton!
    
    var delegate: HomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onRecycleButtonTouchUpInside(_ sender: UIButton) {
        
    }
    
    @IBAction func onMenuButtonTouchUpInside(_ sender: UIButton) {
        delegate?.toggleMenuPanel()
    }
}

protocol HomeViewControllerDelegate {
    func toggleMenuPanel()
    func collapseSidePanels()
}
