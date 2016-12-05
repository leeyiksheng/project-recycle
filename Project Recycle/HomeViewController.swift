//
//  HomeViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 28/11/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var navigationMenuCollectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    
    var navigationMenuItemArray : [MenuPanelItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationMenuCollectionView.delegate = self
        navigationMenuCollectionView.dataSource = self
        
        generateNavigationMenuItems()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateNavigationMenuItems() {
        navigationMenuItemArray = [createMenuPanelItem(imageName: "errorIcon", itemName: "Learn"), createMenuPanelItem(imageName: "errorIcon", itemName: "Non-recyclable"), createMenuPanelItem(imageName: "errorIcon", itemName: "Current Orders"), createMenuPanelItem(imageName: "errorIcon", itemName: "Past Orders"), createMenuPanelItem(imageName: "errorIcon", itemName: "Profile"), createMenuPanelItem(imageName: "errorIcon", itemName: "Settings"), createMenuPanelItem(imageName: "errorIcon", itemName: "Sign Out")]
        self.navigationMenuCollectionView.reloadData()
    }
    
    func createMenuPanelItem(imageName: String, itemName: String) -> MenuPanelItem {
        guard let image = UIImage.init(named: "\(imageName)") else {
            return MenuPanelItem.init(image: UIImage.init(named: "errorIcon")!, name: "\(imageName)")
        }
        
        return MenuPanelItem.init(image: image, name: "\(itemName)")
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch navigationMenuItemArray[indexPath.row].itemName {
        case "Learn":
            print("Tapped Learn Button")
        case "Non-recyclable":
            print("Tapped Non-recyclable Button")
        case "Current Orders":
            
            let transitionToCurrentOrdersNotification = Notification(name: Notification.Name(rawValue: "UserTransitionToCurrentOrders"), object: nil, userInfo: nil)
            NotificationCenter.default.post(transitionToCurrentOrdersNotification)
            print("Tapped Current Orders Button")
        case "Past Orders":
            let transitionToCompletedOrdersNotification = Notification(name: Notification.Name(rawValue: "UserTransitionToCompletedOrders"), object: nil, userInfo: nil)
            NotificationCenter.default.post(transitionToCompletedOrdersNotification)
            print("Tapped Past Orders Button")
        case "Profile":
            let transitionToProfileNotification = Notification(name: Notification.Name(rawValue: "UserTransitionToProfile"), object: nil, userInfo: nil)
            NotificationCenter.default.post(transitionToProfileNotification)
            print("Tapped Profile Button")
        case "Settings":
            print("Tapped Settings Button")
        case "Sign Out":
            do {
                try FIRAuth.auth()?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            print("Tapped Sign Out Button")
        default: break
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navigationMenuItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! NavigationMenuCollectionViewCell
        
        cell.itemImageView.image = navigationMenuItemArray[indexPath.row].itemImage
        cell.itemLabel.text = navigationMenuItemArray[indexPath.row].itemName
        
        return cell
    }
}

