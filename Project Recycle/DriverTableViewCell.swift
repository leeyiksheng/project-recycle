//
//  DriverTableViewCell.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 07/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class DriverTableViewCell: UITableViewCell {

    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var assignedOrderCount: UILabel!
    @IBOutlet weak var completedOrderCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
