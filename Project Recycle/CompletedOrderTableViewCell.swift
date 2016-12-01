//
//  CompletedOrderTableViewCell.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 01/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class CompletedOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var priceTagLabel: UILabel!
    @IBOutlet weak var orderImagesCollectionView: UICollectionView!
    @IBOutlet weak var orderTimestampLabel: UILabel!
    @IBOutlet weak var orderAssignedDriverImageView: UIImageView!
    @IBOutlet weak var orderAssignedDriverNameLabel: UILabel!
    @IBOutlet weak var orderAssignedDriverProfileLabel: UILabel!
    @IBOutlet weak var orderAssignedDriverNameBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
