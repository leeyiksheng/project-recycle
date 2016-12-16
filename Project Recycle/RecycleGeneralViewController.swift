//
//  RecycleGeneralViewController.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 11/30/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseAuth

class RecycleGeneralViewController: UIViewController {

    let headerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "greenScenery")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var paperButton : UIButton = {
        let button = UIButton(type: .system)
        button.basicItemsButtonAttributes()
        button.addTarget(self, action: #selector(handlePaperButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func handlePaperButtonTapped() {
        if paperButtonTapped{
            self.paperButtonTapped = false
            print(12)
            paperButton.backgroundColor = UIColor.viewLightGray
            paperButton.layer.borderWidth = 0
        } else {
            self.paperButtonTapped = true
            paperButton.layer.borderWidth = 2.5
            paperButton.backgroundColor = UIColor.white
            paperButton.layer.borderColor = UIColor.forestGreen.cgColor
        }
    }
    
    let paperLabel : UILabel = {
        let label = UILabel()
        label.basicItemsLabelAttributes()
        label.text = "PAPER"
        return label
    }()
    
    lazy var glassButton : UIButton = {
        let button = UIButton(type: .system)
        button.basicItemsButtonAttributes()
        button.setImage(#imageLiteral(resourceName: "glass"), for: .normal)
        button.addTarget(self, action: #selector(handleGlassButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func handleGlassButtonTapped() {
        if glassButtonTapped{
            self.glassButtonTapped = false
            glassButton.backgroundColor = UIColor.viewLightGray
            glassButton.layer.borderWidth = 0
        } else {
            self.glassButtonTapped = true
            glassButton.layer.borderWidth = 2.5
            glassButton.backgroundColor = UIColor.white
            glassButton.layer.borderColor = UIColor.forestGreen.cgColor
        }
    }
    
    
    let glassLabel : UILabel = {
        let label = UILabel()
        label.basicItemsLabelAttributes()
        label.text = "GLASS"
        return label
    }()
    
    lazy var aluminiumButton : UIButton = {
        let button = UIButton(type: .system)
        button.basicItemsButtonAttributes()
        button.setImage(#imageLiteral(resourceName: "aluminium"), for: .normal)
        button.addTarget(self, action: #selector(handleAluminiumButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func handleAluminiumButtonTapped() {
        if aluminiumButtonTapped{
            self.aluminiumButtonTapped = false
            aluminiumButton.backgroundColor = UIColor.viewLightGray
            aluminiumButton.layer.borderWidth = 0
        } else {
            self.aluminiumButtonTapped = true
            aluminiumButton.layer.borderWidth = 2.5
            aluminiumButton.backgroundColor = UIColor.white
            aluminiumButton.layer.borderColor = UIColor.forestGreen.cgColor
        }
    }
    
    let aluminiumLabel : UILabel = {
        let label = UILabel()
        label.basicItemsLabelAttributes()
        label.text = "ALUMINIUM"
        return label
    }()
    
    lazy var plasticButton : UIButton = {
        let button = UIButton(type: .system)
        button.basicItemsButtonAttributes()
        button.setImage(#imageLiteral(resourceName: "plastic"), for: .normal)
        button.addTarget(self, action: #selector(handlePlasticButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func handlePlasticButtonTapped() {
        if plasticButtonTapped{
            self.plasticButtonTapped = false
            plasticButton.backgroundColor = UIColor.viewLightGray
            plasticButton.layer.borderWidth = 0
        } else {
            self.plasticButtonTapped = true
            plasticButton.layer.borderWidth = 2.5
            plasticButton.backgroundColor = UIColor.white
            plasticButton.layer.borderColor = UIColor.forestGreen.cgColor
        }
    }
    
    let plasticLabel : UILabel = {
        let label = UILabel()
        label.basicItemsLabelAttributes()
        label.text = "PLASTIC"
        return label
    }()
    
    lazy var otherButton : UIButton = {
        let button = UIButton(type: .system)
        button.basicItemsButtonAttributes()

        button.setImage(#imageLiteral(resourceName: "other"), for: .normal)

        button.setImage(#imageLiteral(resourceName: "other"), for: .normal)

        button.addTarget(self, action: #selector(handleOtherTapped), for: .touchUpInside)
        return button
    }()
    
    func handleOtherTapped() {
        if otherButtonTapped{
            self.otherButtonTapped = false
            otherButton.backgroundColor = UIColor.viewLightGray
            otherButton.layer.borderWidth = 0
        } else {
            self.otherButtonTapped = true
            otherButton.layer.borderWidth = 2.5
            otherButton.backgroundColor = UIColor.white
            otherButton.layer.borderColor = UIColor.forestGreen.cgColor
        }
    }
    
    let otherLabel : UILabel = {
        let label = UILabel()
        label.basicItemsLabelAttributes()
        label.text = "OTHER"
        return label
    }()

    
    
    lazy var confirmButton : UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.buttonFonts()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(moveToNextController), for: .touchUpInside)
        return button
    }()
    
    func moveToNextController() {
        let nextController = PickupAddressViewController()
        
        let order = CategoriesChosen.init(hasAluminium: self.aluminiumButtonTapped, hasGlass: self.glassButtonTapped, hasPaper: self.paperButtonTapped, hasPlastic: self.plasticButtonTapped)
        nextController.categoriesChoosed = order
        
        let navController = UINavigationController(rootViewController: nextController)
        self.present(navController, animated: true, completion: nil)
    }

    let infoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.text = "CHOOSE TYPES TO RECYCLE"
        label.textAlignment = .center
        label.mediumTitleFonts()
        label.backgroundColor = UIColor.white
        label.clipsToBounds = true

        return label
    }()
    
    
    var tabBarHeight : CGFloat = 0
    var paperButtonTapped = false
    var glassButtonTapped = false
    var aluminiumButtonTapped = false
    var plasticButtonTapped = false
    var otherButtonTapped = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewLightGray
        self.tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        view.addSubview(headerImageView)
        view.addSubview(paperButton)
        view.addSubview(paperLabel)
        view.addSubview(glassButton)
        view.addSubview(glassLabel)
        view.addSubview(aluminiumButton)
        view.addSubview(aluminiumLabel)
        view.addSubview(plasticButton)
        view.addSubview(plasticLabel)
        view.addSubview(otherButton)
        view.addSubview(otherLabel)
        view.addSubview(confirmButton)
        view.addSubview(infoLabel)
        
        setupHeaderImageView()
        setupLabelForBigItems()
        setupPaperButton()
        setupPaperLabel()
        setupGlassButton()
        setupGlassLabel()
        setupAluminiumButton()
        setupAluminiumLabel()
        setupPlasticButton()
        setupPlasticLabel()
        setupOtherButton()
        setupOtherLabel()
        setupConfirmButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        

    }
    
    
    func setupHeaderImageView() {
        
        headerImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
    }
    
    func setupLabelForBigItems() {
        infoLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -30).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -36).isActive = true
    }
    
    
    func setupPaperButton() {
        paperButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        paperButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30).isActive = true
        paperButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        paperButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        paperButton.setImage(#imageLiteral(resourceName: "paper"), for: .normal)
    }
    
    func setupPaperLabel() {
        paperLabel.leftAnchor.constraint(equalTo: paperButton.leftAnchor).isActive = true
        paperLabel.rightAnchor.constraint(equalTo: paperButton.rightAnchor).isActive = true
        paperLabel.topAnchor.constraint(equalTo: paperButton.bottomAnchor).isActive = true
    }
    
    func setupGlassButton() {
        glassButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        glassButton.topAnchor.constraint(equalTo: paperButton.topAnchor).isActive = true
        glassButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        glassButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    func setupGlassLabel() {
        glassLabel.leftAnchor.constraint(equalTo: glassButton.leftAnchor).isActive = true
        glassLabel.rightAnchor.constraint(equalTo: glassButton.rightAnchor).isActive = true
        glassLabel.topAnchor.constraint(equalTo: glassButton.bottomAnchor).isActive = true
    }
    
    func setupAluminiumButton() {
        aluminiumButton.leftAnchor.constraint(equalTo: paperButton.leftAnchor).isActive = true
        aluminiumButton.topAnchor.constraint(equalTo: paperLabel.bottomAnchor, constant : 30).isActive = true
        aluminiumButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        aluminiumButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    func setupAluminiumLabel() {
        aluminiumLabel.leftAnchor.constraint(equalTo: aluminiumButton.leftAnchor, constant : -10).isActive = true
        aluminiumLabel.rightAnchor.constraint(equalTo: aluminiumButton.rightAnchor, constant : 10).isActive = true
        aluminiumLabel.topAnchor.constraint(equalTo: aluminiumButton.bottomAnchor).isActive = true
    }
    
    func setupPlasticButton() {
        plasticButton.rightAnchor.constraint(equalTo: glassButton.rightAnchor).isActive = true
        plasticButton.topAnchor.constraint(equalTo: glassLabel.bottomAnchor, constant : 30).isActive = true
        plasticButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        plasticButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    func setupPlasticLabel() {
        plasticLabel.leftAnchor.constraint(equalTo: plasticButton.leftAnchor).isActive = true
        plasticLabel.rightAnchor.constraint(equalTo: plasticButton.rightAnchor).isActive = true
        plasticLabel.topAnchor.constraint(equalTo: plasticButton.bottomAnchor).isActive = true
    }
    
    func setupOtherButton() {
        otherButton.topAnchor.constraint(equalTo: aluminiumLabel.bottomAnchor, constant: 30).isActive = true
        otherButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        otherButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        otherButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    
    func setupOtherLabel() {
        otherLabel.topAnchor.constraint(equalTo: otherButton.bottomAnchor).isActive = true
        otherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupConfirmButton() {
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20 - tabBarHeight).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }


    
    
}


extension UIButton {
    
    
    func basicItemsButtonAttributes() {
        let buttonImageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        self.imageEdgeInsets = buttonImageEdgeInsets
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 15
        
    }
    
}

extension UILabel {
    
    func basicItemsLabelAttributes() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.mediumTitleFonts()
        self.textColor = UIColor.textDarkGray
        self.textAlignment = .center
    }
}




