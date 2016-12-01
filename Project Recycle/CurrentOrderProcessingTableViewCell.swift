//
//  CurrentOrderProcessingTableViewCell.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 01/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class CurrentOrderProcessingTableViewCell: UITableViewCell {

    @IBOutlet weak var priceTagLabel: UILabel!
    @IBOutlet weak var orderImagesCollectionView: UICollectionView!
    @IBOutlet weak var orderTimestampLabel: UILabel!
    @IBOutlet weak var orderStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
