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
            backImage.layer.borderColor = UIColor.forestGreen.cgColor
           // backImage.layer.borderColor = UIColor.init(red:67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0).cgColor
        }
    }
    @IBOutlet weak var materialName: UILabel!{
        didSet{
            
            materialName.backgroundColor = UIColor.white
            
        }
    }

    @IBOutlet weak var desc: UITextView!{
        didSet{
            desc.backgroundColor = UIColor.white
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
