//
//  GuideTableViewCell.swift
//  Project Recycle
//
//  Created by Students on 12/6/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class GuideTableViewCell: UITableViewCell {
    
    let backImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let viewContainer: UIView = {
        let vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.layer.cornerRadius = 4
        vc.clipsToBounds = true
        vc.backgroundColor = UIColor.white
        return vc
    }()
    
    let materialName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white
        label.mediumTitleFonts()
        return label
    }()
    
    let desc: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white
        label.smallTitleFonts()
        label.numberOfLines = 0
        return label
    }()
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor.viewLightGray
        contentView.addSubview(backImage)
        contentView.addSubview(viewContainer)
        contentView.addSubview(materialName)
        contentView.addSubview(desc)
        
        setupBackImage()
        setupViewContainer()
        setupMaterialName()
        setupDesc()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        if highlighted {
//            self.backgroundColor = UIColor.forestGreen.withAlphaComponent(0.2)
//        } else {
//        }
//    }
//    
    
    
    
    func setupBackImage() {
        backImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        backImage.widthAnchor.constraint(equalToConstant: 414).isActive = true
        backImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    func setupViewContainer() {
        viewContainer.topAnchor.constraint(equalTo: backImage.bottomAnchor, constant: -30).isActive = true
        viewContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        viewContainer.widthAnchor.constraint(equalToConstant: 390).isActive = true
        viewContainer.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    
    func setupMaterialName() {
        materialName.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 12).isActive = true
        materialName.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16).isActive = true
        materialName.widthAnchor.constraint(equalTo: viewContainer.widthAnchor, constant: -32).isActive = true
        materialName.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupDesc() {
        desc.topAnchor.constraint(equalTo: materialName.bottomAnchor, constant: 4).isActive = true
        desc.leftAnchor.constraint(equalTo: materialName.leftAnchor).isActive = true
        desc.widthAnchor.constraint(equalTo: materialName.widthAnchor).isActive = true
    }
    

}
