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
        navigationMenuItemArray = [createMenuPanelItem(imageName: "errorIcon", itemName: "Item 1"), createMenuPanelItem(imageName: "errorIcon", itemName: "Item 1"), createMenuPanelItem(imageName: "errorIcon", itemName: "Item 3"), createMenuPanelItem(imageName: "errorIcon", itemName: "Item 4"), createMenuPanelItem(imageName: "errorIcon", itemName: "Item 5")]
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
