//
//  OrdersViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 09/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {

    @IBOutlet weak var sortBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var viewTitleLabel: UILabel!
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
        viewTitleLabel.largeTitleFonts()
        setupMenuSegmentedControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupMenuSegmentedControl() {
        menuSegmentedControl.layer.cornerRadius = 0.0
        menuSegmentedControl.layer.borderWidth = 0.5
        menuSegmentedControl.layer.masksToBounds = true
        
        menuSegmentedControl.layer.backgroundColor = UIColor.viewLightGray.cgColor
        menuSegmentedControl.layer.borderColor = UIColor.forestGreen.cgColor
        menuSegmentedControl.tintColor = UIColor.forestGreen
        
        menuSegmentedControl.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "San Francisco Text", size: 18.0)!, NSForegroundColorAttributeName: UIColor.white], for: .normal)
        menuSegmentedControl.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "San Francisco Text", size: 18.0)!, NSForegroundColorAttributeName: UIColor.white], for: .selected)
        
        menuSegmentedControl.setDividerImage(self.imageWithColor(color: UIColor.clear), forLeftSegmentState: UIControlState.normal, rightSegmentState: UIControlState.normal, barMetrics: UIBarMetrics.default)
        menuSegmentedControl.setBackgroundImage(self.imageWithColor(color: UIColor.darkGreen), for: UIControlState.normal, barMetrics: UIBarMetrics.default)
        menuSegmentedControl.setBackgroundImage(self.imageWithColor(color: UIColor.forestGreen), for: UIControlState.selected, barMetrics: UIBarMetrics.default)
        
        for borderView in menuSegmentedControl.subviews {
            let upperBorder : CALayer = CALayer()
            upperBorder.backgroundColor = UIColor.forestGreen.cgColor
            upperBorder.frame = CGRect.init(x: 0, y: borderView.frame.size.height-1, width: borderView.frame.size.width, height: 1.0)
            borderView.layer.addSublayer(upperBorder)
        }
    }
    
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: menuSegmentedControl.frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
    @IBAction func onSortBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        setupSortingAlert()
    }
    
    func setupSortingAlert() {
        let sortingAlert = UIAlertController.init(title: "Sorting", message: "Select a category to sort with.", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let orderStatusAction = UIAlertAction.init(title: "Order Status", style: .default, handler: nil)
        let timeAction = UIAlertAction.init(title: "Date & Time", style: .default, handler: nil)
        let orderValueAction = UIAlertAction.init(title: "Order Value", style: .default, handler: nil)
        
        sortingAlert.addAction(orderStatusAction)
        sortingAlert.addAction(timeAction)
        
        if !orderHistoryContainerView.isHidden {
            sortingAlert.addAction(orderValueAction)
        }
        
        sortingAlert.addAction(cancelAction)
        
        self.present(sortingAlert, animated: true, completion: nil)
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
