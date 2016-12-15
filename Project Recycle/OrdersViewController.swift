//
//  OrdersViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 09/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var currentOrdersContainerView: UIView! {
        didSet {
            currentOrdersContainerView.isHidden = false
        }
    }
    @IBOutlet weak var orderHistoryContainerView: UIView! {
        didSet {
            orderHistoryContainerView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onMenuSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentOrdersContainerView.isHidden = false
            orderHistoryContainerView.isHidden = true
        case 1:
            currentOrdersContainerView.isHidden = true
            orderHistoryContainerView.isHidden = false
        default: print("Error: Segmented control value out of bounds.")
        }
    }
}
