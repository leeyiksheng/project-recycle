//
//  GuideDetailViewController.swift
//  Project Recycle
//
//  Created by Students on 12/9/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class GuideDetailViewController: UIViewController {
    
    let matImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let viewContainer: UIView = {
        let vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.layer.cornerRadius = 5
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
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white
        label.smallTitleFonts()
        label.numberOfLines = 0
        return label
    }()
    
    
    let viewContainer2: UIView = {
        let vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.layer.cornerRadius = 5
        vc.clipsToBounds = true
        vc.backgroundColor = UIColor.white
        return vc
    }()
    


    var matCat : String? = nil
    var matName : String? = nil
    var imageName : UIImage? = nil
    var desc : String? = nil
    var navigationBarHeight: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewLightGray
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
        navigationController?.navigationBarAttributes()
        navigationItem.navigationItemAttributes()
        navigationBarHeight = self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        navigationItem.title = matCat
        
        
        materialName.text = matName
        matImage.image = imageName
        descriptionLabel.text = desc
        
        view.addSubview(matImage)
        view.addSubview(viewContainer)
        view.addSubview(materialName)
        view.addSubview(descriptionLabel)
        
        setupMatImage()
        setupViewContainer()
        setupMaterialName()
        setupDescriptionLabel()
        
        
    }
    
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }

    func setupMatImage() {
        matImage.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight).isActive = true
        matImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        matImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        matImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
    }
    
    func setupViewContainer() {
        viewContainer.topAnchor.constraint(equalTo: matImage.bottomAnchor, constant: -20).isActive = true
        viewContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        viewContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        viewContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
    func setupMaterialName() {
        materialName.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 12).isActive = true
        materialName.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 16).isActive = true
        materialName.widthAnchor.constraint(equalTo: viewContainer.widthAnchor, constant: -32).isActive = true
        materialName.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.topAnchor.constraint(equalTo: materialName.bottomAnchor, constant: 4).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: materialName.leftAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: materialName.widthAnchor).isActive = true
    }

    
    
}
