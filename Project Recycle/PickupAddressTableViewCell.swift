//
//  PickupAddressTableViewCell.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 12/2/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class PickupAddressTableViewCell: UITableViewCell {

    
    let receiverNameLabel: UILabel = {
        let label = UILabel()
        label.text = "RECEIVER NAME"
        label.titleOfAddressesLabelAttributes()
        return label
    }()
    
    let receiverNameDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Kelvin Lee Wei Sern"
        label.descriptionOfAddressesLabelAttributes()
        return label
    }()
    
    let contactNOLabel: UILabel = {
        let label = UILabel()
        label.text = "CONTACT NO."
        label.titleOfAddressesLabelAttributes()
        return label
    }()
    
    let contactNODetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "0164440980"
        label.descriptionOfAddressesLabelAttributes()
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "ADDRESS"
        label.titleOfAddressesLabelAttributes()
        return label
    }()
    
    let addressDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "20 Jalan Inang, 14/9, Bandar mahkota cheras, 43200 Selangor"
        label.descriptionOfAddressesLabelAttributes()
        return label
    }()
    
    let otherNoLabel: UILabel = {
        let label = UILabel()
        label.text = "OTHER NO."
        label.titleOfAddressesLabelAttributes()
        return label
    }()
    
    let otherNoDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "0164440980"
        label.descriptionOfAddressesLabelAttributes()
        return label
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(receiverNameLabel)
        contentView.addSubview(receiverNameDetailsLabel)
        contentView.addSubview(contactNOLabel)
        contentView.addSubview(contactNODetailsLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressDescriptionLabel)
        contentView.addSubview(otherNoLabel)
        contentView.addSubview(otherNoDetailsLabel)
        
        setupReceiverNameLabel()
        setupReceiverNameDetailsLabel()
        setupContactNOLabel()
        setupContactNODetailsLabel()
        setupAddressLabel()
        setupAddressDescriptionLabel()
        setupOtherNoLabel()
        setupOtherNoDetailsLabel()
    }

    
    func setupReceiverNameLabel() {
        receiverNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        receiverNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
    }

    func setupReceiverNameDetailsLabel() {
        receiverNameDetailsLabel.topAnchor.constraint(equalTo: receiverNameLabel.bottomAnchor, constant: 12).isActive = true
        receiverNameDetailsLabel.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        receiverNameDetailsLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func setupContactNOLabel() {
        contactNOLabel.topAnchor.constraint(equalTo: receiverNameLabel.topAnchor).isActive = true
        contactNOLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 200).isActive = true
    }
    
    func setupContactNODetailsLabel(){
        contactNODetailsLabel.topAnchor.constraint(equalTo: receiverNameLabel.bottomAnchor, constant: 12).isActive = true
        contactNODetailsLabel.leftAnchor.constraint(equalTo: contactNOLabel.leftAnchor).isActive = true
    }
    
    func setupAddressLabel(){
        addressLabel.topAnchor.constraint(equalTo: receiverNameDetailsLabel.bottomAnchor, constant: 30).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: receiverNameDetailsLabel.leftAnchor).isActive = true
    }
    
    func setupAddressDescriptionLabel(){
        addressDescriptionLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12).isActive = true
        addressDescriptionLabel.leftAnchor.constraint(equalTo: addressLabel.leftAnchor).isActive = true
        addressDescriptionLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func setupOtherNoLabel() {
        otherNoLabel.topAnchor.constraint(equalTo: addressLabel.topAnchor).isActive = true
        otherNoLabel.leftAnchor.constraint(equalTo: contactNODetailsLabel.leftAnchor).isActive = true
    }
    
    func setupOtherNoDetailsLabel(){
        otherNoDetailsLabel.topAnchor.constraint(equalTo: addressDescriptionLabel.topAnchor).isActive = true
        otherNoDetailsLabel.leftAnchor.constraint(equalTo: otherNoLabel.leftAnchor).isActive = true
    }
}


extension UILabel {
    
    func titleOfAddressesLabelAttributes() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.smallTitleFonts()
        self.numberOfLines = 0
    }
    
    func descriptionOfAddressesLabelAttributes() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.smallTitleFonts()
        self.textColor = UIColor.black
        self.numberOfLines = 0
    }
}
