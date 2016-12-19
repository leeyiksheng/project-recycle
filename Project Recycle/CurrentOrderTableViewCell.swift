//
//  CurrentOrderProcessingTableViewCell.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 01/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class CurrentOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var creationTimestampLabel: UILabel!
    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var receiverContactLabel: UILabel!
    @IBOutlet weak var receiverAddressTitleLabel: UILabel!
    @IBOutlet weak var receiverAddressLabel: UILabel!
    @IBOutlet weak var orderStateLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayShadowView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var headerView: UIView! {
        didSet {
            headerView.backgroundColor = UIColor.darkMagenta
        }
    }
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            imageCollectionView.delegate = self
            imageCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var userIcon: UIImageView! {
        didSet {
            userIcon.image = UIImage(named: "UserIcon")
            userIcon.layer.cornerRadius = 5.0
            userIcon.layer.masksToBounds = true
            userIcon.layer.shouldRasterize = true
        }
    }
    @IBOutlet weak var userContactIcon: UIImageView! {
        didSet {
            userContactIcon.image = UIImage(named: "PhoneIcon")
            userContactIcon.layer.cornerRadius = 5.0
            userContactIcon.layer.masksToBounds = true
            userContactIcon.layer.shouldRasterize = true
        }
    }
    @IBOutlet weak var driverIcon: UIImageView! {
        didSet {
            driverIcon.image = UIImage(named: "DriverIcon")
            driverIcon.layer.cornerRadius = 5.0
            driverIcon.layer.masksToBounds = true
            driverIcon.layer.shouldRasterize = true
        }
    }
    
    var iconArray: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CurrentOrderTableViewCell: UICollectionViewDelegate {
    
}

extension CurrentOrderTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aluminiumCell", for: indexPath) as! IconCollectionViewCell
            cell.iconImageView?.image = iconArray[indexPath.row]
            
            cell.layer.cornerRadius = 8.0
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "glassCell", for: indexPath) as! IconCollectionViewCell
            cell.iconImageView?.image = iconArray[indexPath.row]
            cell.layer.cornerRadius = 8.0
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paperCell", for: indexPath) as! IconCollectionViewCell
            cell.iconImageView?.image = iconArray[indexPath.row]
            cell.layer.cornerRadius = 8.0
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plasticCell", for: indexPath) as! IconCollectionViewCell
            cell.iconImageView?.image = iconArray[indexPath.row]
            cell.layer.cornerRadius = 8.0
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aluminiumCell", for: indexPath) as! IconCollectionViewCell
            cell.iconImageView?.image = UIImage.init(named: "redErrorIcon")
            cell.layer.cornerRadius = 8.0
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconArray.count
    }
}
