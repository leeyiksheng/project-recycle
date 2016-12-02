//
//  RecycleGeneralViewController.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 11/30/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class RecycleGeneralViewController: UIViewController {

    var paperButtonTapped = false
    var glassButtonTapped = false
    var aluminiumButtonTapped = false
    var plasticButtonTapped = false
    
    
    let headerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "greenScenery")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CHOOSE TYPES TO RECYCLE"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(r: 169, g: 169, b: 169)
        label.textAlignment = .center
        return label
    }()
    
    lazy var paperButton : UIButton = {
        let button = UIButton(type: .system)
        button.buttonAttributes()
        button.addTarget(self, action: #selector(handlePaperButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func handlePaperButtonTapped() {
        if paperButtonTapped{
            self.paperButtonTapped = false
            print(12)
            paperButton.layer.borderWidth = 0
        } else {
            self.paperButtonTapped = true
            paperButton.layer.borderWidth = 2.5
            paperButton.layer.borderColor = UIColor.forestGreen.cgColor
        }
    }
    
    let paperLabel : UILabel = {
        let label = UILabel()
        label.labelAttributes()
        label.text = "PAPER"
        return label
    }()
    
    lazy var glassButton : UIButton = {
        let button = UIButton(type: .system)
        button.buttonAttributes()
        button.setImage(#imageLiteral(resourceName: "Glass"), for: .normal)
        button.addTarget(self, action: #selector(handleGlassButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func handleGlassButtonTapped() {
        if glassButtonTapped{
            self.glassButtonTapped = false
            print(12)
            glassButton.layer.borderWidth = 0
        } else {
            self.glassButtonTapped = true
            glassButton.layer.borderWidth = 2.5
            glassButton.layer.borderColor = UIColor.forestGreen.cgColor
        }
    }
    
    
    let glassLabel : UILabel = {
        let label = UILabel()
        label.labelAttributes()
        label.text = "GLASS"
        return label
    }()
    
    lazy var aluminiumButton : UIButton = {
        let button = UIButton(type: .system)
        button.buttonAttributes()
        button.setImage(#imageLiteral(resourceName: "Aluminium"), for: .normal)
        button.addTarget(self, action: #selector(handleAluminiumButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func handleAluminiumButtonTapped() {
        if aluminiumButtonTapped{
            self.aluminiumButtonTapped = false
            print(12)
            aluminiumButton.layer.borderWidth = 0
        } else {
            self.aluminiumButtonTapped = true
            aluminiumButton.layer.borderWidth = 2.5
            aluminiumButton.layer.borderColor = UIColor.forestGreen.cgColor
        }
    }
    
    let aluminiumLabel : UILabel = {
        let label = UILabel()
        label.labelAttributes()
        label.text = "ALUMINIUM"
        return label
    }()
    
    lazy var plasticButton : UIButton = {
        let button = UIButton(type: .system)
        button.buttonAttributes()
        button.setImage(#imageLiteral(resourceName: "Plastic"), for: .normal)
        button.addTarget(self, action: #selector(handlePlasticButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func handlePlasticButtonTapped() {
        if plasticButtonTapped{
            self.plasticButtonTapped = false
            print(12)
            plasticButton.layer.borderWidth = 0
        } else {
            self.plasticButtonTapped = true
            plasticButton.layer.borderWidth = 2.5
            plasticButton.layer.borderColor = UIColor.forestGreen.cgColor
        }
    }
    
    let plasticLabel : UILabel = {
        let label = UILabel()
        label.labelAttributes()
        label.text = "PLASTIC"
        return label
    }()
    
    lazy var confirmButton : UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(moveToNextController), for: .touchUpInside)
        return button
    }()
    
    func moveToNextController() {
        let nextController = AlternativeAddressViewController()
        //let navController = UINavigationController(rootViewController: nextController)
        present(nextController, animated: true, completion: nil)
    }

    let infoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.text = "For large items and more varieties tap here"
        label.textColor = UIColor.forestGreen
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.white
        label.clipsToBounds = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewLightGray
        
        view.addSubview(headerImageView)
        view.addSubview(titleLabel)
        view.addSubview(paperButton)
        view.addSubview(paperLabel)
        view.addSubview(glassButton)
        view.addSubview(glassLabel)
        view.addSubview(aluminiumButton)
        view.addSubview(aluminiumLabel)
        view.addSubview(plasticButton)
        view.addSubview(plasticLabel)
        view.addSubview(confirmButton)
        view.addSubview(infoLabel)
        
        setupHeaderImageView()
        setupLabelForBigItems()
        setupHeaderTitle()
        setupPaperButton()
        setupPaperLabel()
        setupGlassButton()
        setupGlassLabel()
        setupAluminiumButton()
        setupAluminiumLabel()
        setupPlasticButton()
        setupPlasticLabel()
        setupConfirmButton()
        
    }
    
    
    
    func setupHeaderImageView() {
        
        headerImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
    }
    
    func setupHeaderTitle() {
        
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func setupPaperButton() {
        paperButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        paperButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 275).isActive = true
        paperButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        paperButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        paperButton.setImage(#imageLiteral(resourceName: "Paper"), for: .normal)
    }
    
    func setupPaperLabel() {
        paperLabel.leftAnchor.constraint(equalTo: paperButton.leftAnchor).isActive = true
        paperLabel.rightAnchor.constraint(equalTo: paperButton.rightAnchor).isActive = true
        paperLabel.topAnchor.constraint(equalTo: paperButton.bottomAnchor).isActive = true
    }
    
    func setupGlassButton() {
        glassButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        glassButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 275).isActive = true
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
        aluminiumButton.topAnchor.constraint(equalTo: paperLabel.bottomAnchor, constant : 75).isActive = true
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
        plasticButton.topAnchor.constraint(equalTo: glassLabel.bottomAnchor, constant : 75).isActive = true
        plasticButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        plasticButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    func setupPlasticLabel() {
        plasticLabel.leftAnchor.constraint(equalTo: plasticButton.leftAnchor).isActive = true
        plasticLabel.rightAnchor.constraint(equalTo: plasticButton.rightAnchor).isActive = true
        plasticLabel.topAnchor.constraint(equalTo: plasticButton.bottomAnchor).isActive = true
    }
    
    func setupConfirmButton() {
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }

    func setupLabelForBigItems() {
        infoLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 20).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -36).isActive = true
    }
    
    
    
}




