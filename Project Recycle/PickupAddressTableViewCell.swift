//
//  PickupAddressTableViewCell.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 12/2/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class PickupAddressTableViewCell: UITableViewCell {

    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        return view
    }()
    
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
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.viewLightGray
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.viewLightGray
        contentView.addSubview(containerView)
        contentView.addSubview(receiverNameLabel)
        contentView.addSubview(receiverNameDetailsLabel)
        contentView.addSubview(contactNOLabel)
        contentView.addSubview(contactNODetailsLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressDescriptionLabel)
        
        setupContainerView()
        setupReceiverNameLabel()
        setupReceiverNameDetailsLabel()
        setupContactNOLabel()
        setupContactNODetailsLabel()
        setupAddressLabel()
        setupAddressDescriptionLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
  
    
    func setupContainerView() {
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 382).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 256).isActive = true
    }
    
    func setupReceiverNameLabel() {
        receiverNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        receiverNameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
    }

    func setupReceiverNameDetailsLabel() {
        receiverNameDetailsLabel.topAnchor.constraint(equalTo: receiverNameLabel.bottomAnchor, constant: 12).isActive = true
        receiverNameDetailsLabel.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        receiverNameDetailsLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func setupContactNOLabel() {
        contactNOLabel.topAnchor.constraint(equalTo: receiverNameLabel.topAnchor).isActive = true
        contactNOLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 200).isActive = true
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
        addressDescriptionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
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
