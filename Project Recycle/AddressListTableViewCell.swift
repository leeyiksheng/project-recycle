//
//  AddressListTableViewCell.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 19/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var receiverContactImageView: UIImageView! {
        didSet {
            receiverContactImageView.image = UIImage(named: "PhoneIcon")
            receiverContactImageView.layer.cornerRadius = 6.0
            receiverContactImageView.layer.masksToBounds = true
            receiverContactImageView.layer.shouldRasterize = true
        }
    }
    
    @IBOutlet weak var receiverNameImageView: UIImageView! {
        didSet {
            receiverNameImageView.image = UIImage(named: "UserIcon")
            receiverNameImageView.layer.cornerRadius = 6.0
            receiverNameImageView.layer.masksToBounds = true
            receiverNameImageView.layer.shouldRasterize = true
        }
    }
    
    @IBOutlet weak var receiverAddressImageView: UIImageView! {
        didSet {
            receiverAddressImageView.image = UIImage(named: "UserIcon")
            receiverAddressImageView.layer.cornerRadius = 6.0
            receiverAddressImageView.layer.masksToBounds = true
            receiverAddressImageView.layer.shouldRasterize = true
        }
    }
    
    @IBOutlet weak var receiverNameTextField: UITextField!
    @IBOutlet weak var receiverContactTextField: UITextField!
    @IBOutlet weak var receiverAddressTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
