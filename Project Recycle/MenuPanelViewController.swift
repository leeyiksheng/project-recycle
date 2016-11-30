//
//  MenuPanelViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 28/11/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import Firebase

class MenuPanelViewController: UIViewController {

    @IBOutlet weak var menuPanelTableView: UITableView!
    
    var profileMenuPanelItemArray : [MenuPanelItem] = []
    var ordersMenuPanelItemArray : [MenuPanelItem] = []
    var supportMenuPanelItemArray : [MenuPanelItem] = []
    var userProfileImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuPanelTableView.delegate = self
        menuPanelTableView.dataSource = self
        
        menuPanelTableView.rowHeight = UITableViewAutomaticDimension
        menuPanelTableView.estimatedRowHeight = 120.0
        
        generateMenuItemSections()
        
        menuPanelTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateMenuItemSections() {
        downloadImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/recycle-ece8c.appspot.com/o/C0s5XPPa.png?alt=media&token=b8f9dc75-a6e3-4d0d-b1ab-9d40cf7c14fa")!)
        ordersMenuPanelItemArray = [generateOrderHistoryMenuItem(), generateScheduledOrdersMenuItem()]
        supportMenuPanelItemArray = [generateSupportMenuItem(), generateDriveWithUsMenuItem(), generateSignOutMenuItem()]
    }
    
    func generateProfileMenuItem() -> MenuPanelItem {
        return MenuPanelItem.init(image: userProfileImage!, name: (FIRAuth.auth()?.currentUser?.email)!)
    }
    
    func generateSignOutMenuItem() -> MenuPanelItem {
        return MenuPanelItem.init(image: UIImage.init(named: "signOutIcon")!, name: "Sign Out")
    }
    
    func generateSupportMenuItem() -> MenuPanelItem {
        return MenuPanelItem.init(image: UIImage.init(named: "supportIcon")!, name: "Support")
    }
    
    func generateDriveWithUsMenuItem() -> MenuPanelItem {
        return MenuPanelItem.init(image: UIImage.init(named: "driveWithUsIcon")!, name: "Drive with Us")
    }
    
    func generateOrderHistoryMenuItem() -> MenuPanelItem {
        return MenuPanelItem.init(image: UIImage.init(named: "orderHistoryIcon")!, name: "Order History")
    }
    
    func generateScheduledOrdersMenuItem() -> MenuPanelItem {
        return MenuPanelItem.init(image: UIImage.init(named: "scheduledOrdersIcon")!, name: "Scheduled Orders")
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        Downloader.getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.userProfileImage = UIImage(data: data)
                self.profileMenuPanelItemArray = [self.generateProfileMenuItem()]
                self.menuPanelTableView.reloadData()
            }
        }
    }
}

extension MenuPanelViewController: UITableViewDelegate {
    
}

extension MenuPanelViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return profileMenuPanelItemArray.count
        } else if section == 1 {
            return ordersMenuPanelItemArray.count
        } else if section == 2 {
            return supportMenuPanelItemArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! MenuProfileTableViewCell
            cell.userProfileImage.image = profileMenuPanelItemArray[indexPath.row].itemImage
            cell.userEmailLabel.text = profileMenuPanelItemArray[indexPath.row].itemName
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! MenuItemTableViewCell
            cell.menuItemImageView.image = ordersMenuPanelItemArray[indexPath.row].itemImage
            cell.menuItemLabel.text = ordersMenuPanelItemArray[indexPath.row].itemName
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! MenuItemTableViewCell
            cell.menuItemImageView.image = supportMenuPanelItemArray[indexPath.row].itemImage
            cell.menuItemLabel.text = supportMenuPanelItemArray[indexPath.row].itemName
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
}
