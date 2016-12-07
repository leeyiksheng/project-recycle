//
//  GuideTableViewCell.swift
//  Project Recycle
//
//  Created by Students on 12/6/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class GuideTableViewCell: UITableViewCell {
    @IBOutlet weak var backImage: UIImageView!
    {
        didSet{
            backImage.layer.borderWidth = 3
            backImage.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var materialName: UILabel!{
        didSet{
            materialName.backgroundColor = UIColor.clear
//            materialName.layer.background.opacity = 0.1
        }
    }
    @IBOutlet weak var materialCategory: UILabel!{
        didSet{
            materialCategory.backgroundColor = UIColor.clear
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
