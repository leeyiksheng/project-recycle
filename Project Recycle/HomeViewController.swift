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
    @IBOutlet weak var navigationMenuCollectionView: UICollectionView!
    
    var delegate: HomeViewControllerDelegate?
    
    var navigationMenuItemArray : [MenuPanelItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationMenuCollectionView.delegate = self
        self.navigationMenuCollectionView.dataSource = self
        
        generateNavigationMenuItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onRecycleButtonTouchUpInside(_ sender: UIButton) {
        
    }
    
    @IBAction func onMenuButtonTouchUpInside(_ sender: UIButton) {
        delegate?.toggleMenuPanel()
    }
    
    func generateNavigationMenuItems() {
        navigationMenuItemArray = [createMenuPanelItem(imageName: "errorIcon", itemName: "Learn"), createMenuPanelItem(imageName: "errorIcon", itemName: "Non-recyclable"), createMenuPanelItem(imageName: "errorIcon", itemName: "Current Orders"), createMenuPanelItem(imageName: "errorIcon", itemName: "Past Orders"), createMenuPanelItem(imageName: "errorIcon", itemName: "Profile"), createMenuPanelItem(imageName: "errorIcon", itemName: "Settings")]
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
            print("Tapped Current Orders Button")
        case "Past Orders":
            print("Tapped Past Orders Button")
        case "Profile":
            print("Tapped Profile Button")
        case "Settings":
            print("Tapped Settings Button")
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

protocol HomeViewControllerDelegate {
    func toggleMenuPanel()
    func collapseSidePanels()
}
