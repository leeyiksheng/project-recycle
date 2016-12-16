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
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            self.imageCollectionView.delegate = self
            self.imageCollectionView.dataSource = self
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
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "glassCell", for: indexPath) as! IconCollectionViewCell
            cell.iconImageView?.image = iconArray[indexPath.row]
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paperCell", for: indexPath) as! IconCollectionViewCell
            cell.iconImageView?.image = iconArray[indexPath.row]
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plasticCell", for: indexPath) as! IconCollectionViewCell
            cell.iconImageView?.image = iconArray[indexPath.row]
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aluminiumCell", for: indexPath) as! IconCollectionViewCell
            cell.iconImageView?.image = UIImage.init(named: "redErrorIcon")
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
