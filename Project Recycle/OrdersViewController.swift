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
    @IBOutlet weak var unsortBarButtonItem: UIBarButtonItem! {
        didSet {
            unsortBarButtonItem.isEnabled = false
        }
    }
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
        viewTitleLabel.textColor = UIColor.black
        
        initializeObservers()
        
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
        
        menuSegmentedControl.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "SanFranciscoText-Semibold", size: 18.0)!, NSForegroundColorAttributeName: UIColor.white], for: .normal)
        menuSegmentedControl.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "SanFranciscoText-Semibold", size: 18.0)!, NSForegroundColorAttributeName: UIColor.white], for: .selected)
        
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
        unsortBarButtonItem.isEnabled = true
    }
    
    @IBAction func onUnsortBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        
    }
    
    func setupSortingAlert() {
        let sortingAlert = UIAlertController.init(title: "Sorting", message: "Select a category to sort with.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (cancelAction) in
            
        })
        
        let orderStatusAscendingAction = UIAlertAction.init(title: "Order Status (Ascending)", style: .default, handler: { (orderStatusAction) in
            let userDidTapOrderStatusAscendingActionNotification = Notification(name: Notification.Name(rawValue: "userDidTapOrderStatusAscendingActionNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(userDidTapOrderStatusAscendingActionNotification)
        })
        
        let orderStatusDescendingAction = UIAlertAction.init(title: "Order Status (Descending)", style: .default, handler: { (orderStatusAction) in
            let userDidTapOrderStatusDescendingActionNotification = Notification(name: Notification.Name(rawValue: "userDidTapOrderStatusActionDescendingNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(userDidTapOrderStatusDescendingActionNotification)
        })
        
        let timeAscendingAction = UIAlertAction.init(title: "Date & Time (Ascending)", style: .default, handler: { (timeAction) in
            let userDidTapTimeAscendingActionNotification = Notification(name: Notification.Name(rawValue: "userDidTapTimeActionAscendingNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(userDidTapTimeAscendingActionNotification)
        })
        
        let timeDescendingAction = UIAlertAction.init(title: "Date & Time (Descending)", style: .default, handler: { (timeAction) in
            let userDidTapTimeDescendingActionNotification = Notification(name: Notification.Name(rawValue: "userDidTapTimeActionDescendingNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(userDidTapTimeDescendingActionNotification)
        })

        let orderValueAscendingAction = UIAlertAction.init(title: "Order Value (Ascending)", style: .default, handler: { (orderValueAction) in
            let userDidTapOrderValueAscendingActionNotification = Notification(name: Notification.Name(rawValue: "userDidTapOrderValueAscendingActionNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(userDidTapOrderValueAscendingActionNotification)
        })
        
        let orderValueDescendingAction = UIAlertAction.init(title: "Order Value (Descending)", style: .default, handler: { (orderValueAction) in
            let userDidTapOrderValueDescendingActionNotification = Notification(name: Notification.Name(rawValue: "userDidTapOrderValueDescendingActionNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(userDidTapOrderValueDescendingActionNotification)
        })
        
        sortingAlert.addAction(orderStatusAscendingAction)
        sortingAlert.addAction(orderStatusDescendingAction)
        sortingAlert.addAction(timeAscendingAction)
        sortingAlert.addAction(timeDescendingAction)
        
        if !orderHistoryContainerView.isHidden {
            sortingAlert.addAction(orderValueAscendingAction)
            sortingAlert.addAction(orderValueDescendingAction)
        }
        
        sortingAlert.addAction(cancelAction)
        
        self.present(sortingAlert, animated: true, completion: nil)
    }
    
    func initializeObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDidBeginEditingSearchBarTextNotification), name: Notification.Name(rawValue: "userDidBeginEditingSearchBarTextNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserTappedSearchBarCancelButtonNotification), name: Notification.Name(rawValue: "userTappedSearchBarCancelButtonNotification"), object: nil)
    }
    
    func handleUserDidBeginEditingSearchBarTextNotification() {
        sortBarButtonItem.isEnabled = false
    }
    
    func handleUserTappedSearchBarCancelButtonNotification() {
        sortBarButtonItem.isEnabled = true
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
