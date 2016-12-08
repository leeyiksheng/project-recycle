//
//  AssignedOrderTableViewCell.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 08/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class AssignedOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var processedTimestampLabel: UILabel!
    @IBOutlet weak var receiverAddressLabel: UILabel!
    @IBOutlet weak var orderCategoriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
