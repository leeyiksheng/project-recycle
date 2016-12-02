//
//  AlternativeAddressViewController.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 12/1/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit

class AlternativeAddressViewController: UIViewController {

    
//    let selectionContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//        return view
//    }()
    
    let inputsAddressContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let confirmButton : UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        return button
    }()
//
//    let glassView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.red
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//        return view
//    }()
//    
//    let glassLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Glass"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.textAlignment = .center
//        return label
//    }()
//    
//    let glassImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.roundShape()
//        iv.layer.cornerRadius = 5
//        return iv
//    }()
//    
//    let glassDescription: UILabel = {
//        let label = UILabel()
//        label.text = "bottles and jars"
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 12)
//        label.textColor = UIColor(r: 169, g: 169, b: 169)
//        label.textAlignment = .justified
//        return label
//    }()
//    
//    let paperView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.red
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//        return view
//    }()
//    
//    let paperLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Paper"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.textAlignment = .center
//        return label
//    }()
//    
//    let paperImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.roundShape()
//        iv.layer.cornerRadius = 5
//        return iv
//    }()
//    
//    let paperDescription: UILabel = {
//        let label = UILabel()
//        label.text = "Cardboard, magazines, newspapers, office paper, etc."
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 12)
//        label.textColor = UIColor(r: 169, g: 169, b: 169)
//        label.textAlignment = .justified
//        return label
//    }()
//    
//    let aluminiumView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.red
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//        return view
//    }()
//    
//    let aluminiumLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Aluminium"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.textAlignment = .center
//        return label
//    }()
//    
//    let aluminiumImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.roundShape()
//        iv.layer.cornerRadius = 5
//        return iv
//    }()
//    
//    let aluminiumDescription: UILabel = {
//        let label = UILabel()
//        label.text = "Aluminium cans"
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 12)
//        label.textColor = UIColor(r: 169, g: 169, b: 169)
//        label.textAlignment = .justified
//        return label
//    }()
//
//    let plasticView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.red
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//        return view
//    }()
//    
//    let plasticLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Aluminium"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.textAlignment = .center
//        return label
//    }()
//    
//    let plasticImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.roundShape()
//        iv.layer.cornerRadius = 5
//        return iv
//    }()
//    
//    let plasticDescription: UILabel = {
//        let label = UILabel()
//        label.text = "Aluminium cans"
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 12)
//        label.textColor = UIColor(r: 169, g: 169, b: 169)
//        label.textAlignment = .justified
//        return label
//    }()
//    
//    let termsAndConditionBoxButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 12.5
//        button.layer.borderWidth = 1.5
//        button.layer.borderColor = UIColor.forestGreen.cgColor
//        button.backgroundColor = UIColor.white
//        return button
//    }()
//    
//    let termsAndConditionWordButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = UIColor.viewLightGray
//        button.setTitle("Terms and Conditions", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        button.setTitleColor(UIColor.blue, for: .normal)
//        return button
//    }()
    
    let alternativeAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Alternative Address"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(r: 45, g: 45, b: 45)
        return label
    }()
    
    let addressDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "To use default user address, leave blank"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(r: 169, g: 169, b: 169)
        return label
    }()
    
    
    let alternativeAddress1TextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "e.g No 13 @ndFloor , Blok B"
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let alternativeAddress2TextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "e.g HighNoon apartment"
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let alternativeAddress3TextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "e.g Taman High noon"
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "ADDRESS"
        label.addressLabelAttributes()
        return label
    }()
    
    let cityTextField : UITextField = {
        let tf = UITextField()
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "CITY"
        label.addressLabelAttributes()
        return label
    }()
    
    let postcodeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "e.g 81200"
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let postcodeLabel: UILabel = {
        let label = UILabel()
        label.text = "POSTCODE"
        label.addressLabelAttributes()
        return label
    }()
    
    let stateTextField: UITextField = {
        let tf = UITextField()
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let stateLabel: UILabel = {
        let label = UILabel()
        label.text = "STATE"
        label.addressLabelAttributes()
        return label
    }()
 
    let phoneNoTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number"
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let phoneNoLabel: UILabel = {
        let label = UILabel()
        label.text = "PHONE NO"
        label.addressLabelAttributes()
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.viewLightGray
//        view.addSubview(selectionContainerView)
//        view.addSubview(glassView)
//        view.addSubview(glassLabel)
//        view.addSubview(glassImageView)
//        view.addSubview(glassDescription)
//        view.addSubview(paperView)
//        view.addSubview(paperLabel)
//        view.addSubview(paperImageView)
//        view.addSubview(paperDescription)
//        view.addSubview(aluminiumView)
//        view.addSubview(aluminiumLabel)
//        view.addSubview(aluminiumImageView)
//        view.addSubview(aluminiumDescription)
//        view.addSubview(plasticView)
//        view.addSubview(plasticLabel)
//        view.addSubview(plasticImageView)
//        view.addSubview(plasticDescription)
        
        view.addSubview(inputsAddressContainerView)
//        view.addSubview(termsAndConditionBoxButton)
//        view.addSubview(termsAndConditionWordButton)
        view.addSubview(alternativeAddressLabel)
        view.addSubview(addressDescriptionLabel)
        view.addSubview(addressLabel)
        view.addSubview(alternativeAddress1TextField)
        view.addSubview(alternativeAddress2TextField)
        view.addSubview(alternativeAddress3TextField)
        view.addSubview(cityLabel)
        view.addSubview(cityTextField)
        view.addSubview(postcodeLabel)
        view.addSubview(postcodeTextField)
        view.addSubview(stateLabel)
        view.addSubview(stateTextField)
        view.addSubview(phoneNoLabel)
        view.addSubview(phoneNoTextField)
        view.addSubview(confirmButton)
        
        
        
        setupInputsAddressContainerView()
//        setupSelectionContainerView()
//        setupGlassView()
//        setupGlassLabel()
//        setupGlassImageView()
//        setupGlassDescriptionLabel()
//        setupPaperView()
//        setupPaperLabel()
//        setupPaperImageView()
//        setupPaperDescriptionLabel()
//        setupAluminiumView()
//        setupAluminiumLabel()
//        setupAluminiumImageView()
//        setupAluminiumDescriptionLabel()
//        setupPlasticView()
//        setupPlasticLabel()
//        setupPlasticImageView()
//        setupPlasticDescriptionLabel()
//        setupTermsAndConditionBoxButton()
//        setupTermsAndConditionWordButton()
        setupConfirmButton()
        setupAlternativeAddressLabel()
        setupAddressDescriptionLabel()
        setupAddressLabelsetup()
        setupAlternativeAddress1TextField()
        setupAlternativeAddress2TextField()
        setupAlternativeAddress3TextField()
        setupCityLabel()
        setupCityTextField()
        setupPostcodeLabel()
        setupPostcodeTextField()
        setupStateLabel()
        setupStateTextField()
        setupPhoneNoLabel()
        setupPhoneNoTextField()
    }
    
    
    func setupAlternativeAddressLabel() {
        alternativeAddressLabel.topAnchor.constraint(equalTo: inputsAddressContainerView.topAnchor, constant: 12).isActive = true
        alternativeAddressLabel.leftAnchor.constraint(equalTo: inputsAddressContainerView.leftAnchor, constant: 8).isActive = true
    }
    
    func setupAddressDescriptionLabel() {
        addressDescriptionLabel.topAnchor.constraint(equalTo: alternativeAddressLabel.bottomAnchor, constant: 4).isActive = true
        addressDescriptionLabel.leftAnchor.constraint(equalTo: inputsAddressContainerView.leftAnchor, constant: 8).isActive = true

    }
    
    func setupAddressLabelsetup() {
        addressLabel.topAnchor.constraint(equalTo: addressDescriptionLabel.bottomAnchor, constant: 12).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: inputsAddressContainerView.leftAnchor, constant: 8).isActive = true
    }
    
    func setupAlternativeAddress1TextField() {
        alternativeAddress1TextField.topAnchor.constraint(equalTo: addressLabel.topAnchor).isActive = true
        alternativeAddress1TextField.leftAnchor.constraint(equalTo: addressLabel.rightAnchor, constant: 12).isActive = true

    }
    
    func setupAlternativeAddress2TextField() {
        alternativeAddress2TextField.topAnchor.constraint(equalTo: alternativeAddress1TextField.bottomAnchor, constant: 4).isActive = true
        alternativeAddress2TextField.leftAnchor.constraint(equalTo: addressLabel.rightAnchor, constant: 12).isActive = true

    }
    
    func setupAlternativeAddress3TextField() {
        alternativeAddress3TextField.topAnchor.constraint(equalTo: alternativeAddress2TextField.bottomAnchor, constant: 4).isActive = true
        alternativeAddress3TextField.leftAnchor.constraint(equalTo: addressLabel.rightAnchor, constant: 12).isActive = true

    }
    
    func setupCityLabel() {
        cityLabel.topAnchor.constraint(equalTo: alternativeAddress3TextField.bottomAnchor, constant: 12).isActive = true
        cityLabel.leftAnchor.constraint(equalTo: inputsAddressContainerView.leftAnchor, constant: 8).isActive = true

    }
    
    func setupCityTextField() {
        cityTextField.topAnchor.constraint(equalTo: cityLabel.topAnchor).isActive = true
        cityTextField.leftAnchor.constraint(equalTo: cityLabel.rightAnchor, constant: 12).isActive = true
    }
    
    func setupPostcodeLabel() {
        postcodeLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 12).isActive = true
        postcodeLabel.leftAnchor.constraint(equalTo: inputsAddressContainerView.leftAnchor, constant: 8).isActive = true
    }
    
    func setupPostcodeTextField() {
        postcodeTextField.topAnchor.constraint(equalTo: postcodeLabel.topAnchor).isActive = true
        postcodeTextField.leftAnchor.constraint(equalTo: postcodeLabel.rightAnchor, constant: 12).isActive = true
    }
    
    func setupStateLabel() {
        stateLabel.topAnchor.constraint(equalTo: postcodeLabel.bottomAnchor, constant: 12).isActive = true
        stateLabel.leftAnchor.constraint(equalTo: inputsAddressContainerView.leftAnchor, constant: 8).isActive = true
    }
    
    func setupStateTextField() {
        stateTextField.topAnchor.constraint(equalTo: stateLabel.topAnchor).isActive = true
        stateTextField.leftAnchor.constraint(equalTo: stateLabel.rightAnchor, constant: 12).isActive = true
    }
    
    func setupPhoneNoLabel() {
        phoneNoLabel.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 12).isActive = true
        phoneNoLabel.leftAnchor.constraint(equalTo: inputsAddressContainerView.leftAnchor, constant: 8).isActive = true
    }
    
    func setupPhoneNoTextField() {
        phoneNoTextField.topAnchor.constraint(equalTo: phoneNoLabel.topAnchor).isActive = true
        phoneNoTextField.leftAnchor.constraint(equalTo: phoneNoLabel.rightAnchor, constant: 12).isActive = true
    }
    
    
//    func setupTermsAndConditionBoxButton() {
//        termsAndConditionWordButton.topAnchor.constraint(equalTo: inputsAddressContainerView.bottomAnchor, constant: 20).isActive = true
//        termsAndConditionBoxButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36).isActive = true
//        termsAndConditionBoxButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        termsAndConditionBoxButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
//    }
//    
//    func setupTermsAndConditionWordButton() {
//        termsAndConditionWordButton.leftAnchor.constraint(equalTo: termsAndConditionBoxButton.leftAnchor, constant: 36).isActive = true
//        termsAndConditionWordButton.topAnchor.constraint(equalTo: termsAndConditionBoxButton.topAnchor).isActive = true
//        termsAndConditionWordButton.heightAnchor.constraint(equalTo: termsAndConditionBoxButton.heightAnchor).isActive = true
//        termsAndConditionWordButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
//    }

//    func setupGlassView() {
//        glassView.topAnchor.constraint(equalTo: selectionContainerView.topAnchor, constant: 36).isActive = true
//        glassView.leftAnchor.constraint(equalTo: selectionContainerView.leftAnchor, constant: 36).isActive = true
//        glassView.widthAnchor.constraint(equalToConstant: 140).isActive = true
//        glassView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//    }
//    
//    func setupGlassLabel() {
//        glassLabel.topAnchor.constraint(equalTo: glassView.topAnchor).isActive = true
//        glassLabel.leftAnchor.constraint(equalTo: glassView.leftAnchor).isActive = true
//        glassLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
//        glassLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//    }
//    
//    func setupGlassImageView() {
//        glassImageView.topAnchor.constraint(equalTo: glassView.topAnchor, constant: 10).isActive = true
//        glassImageView.rightAnchor.constraint(equalTo: glassView.rightAnchor, constant: -10).isActive = true
//        glassImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        glassImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
//    }
//    
//    func setupGlassDescriptionLabel() {
//        glassDescription.topAnchor.constraint(equalTo: glassView.bottomAnchor, constant: 4).isActive = true
//        glassDescription.leftAnchor.constraint(equalTo: glassView.leftAnchor).isActive = true
//        glassDescription.widthAnchor.constraint(equalTo: glassView.widthAnchor).isActive = true
//    }
//    
//    func setupPaperView() {
//        paperView.topAnchor.constraint(equalTo: selectionContainerView.topAnchor, constant: 36).isActive = true
//        paperView.rightAnchor.constraint(equalTo: selectionContainerView.rightAnchor, constant: -36).isActive = true
//        paperView.widthAnchor.constraint(equalToConstant: 140).isActive = true
//        paperView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//    }
//    
//    func setupPaperLabel() {
//        paperLabel.topAnchor.constraint(equalTo: paperView.topAnchor).isActive = true
//        paperLabel.leftAnchor.constraint(equalTo: paperView.leftAnchor).isActive = true
//        paperLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
//        paperLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//    }
//    
//    func setupPaperImageView() {
//        paperImageView.topAnchor.constraint(equalTo: paperView.topAnchor, constant: 10).isActive = true
//        paperImageView.rightAnchor.constraint(equalTo: paperView.rightAnchor, constant: -10).isActive = true
//        paperImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        paperImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
//    }
//    
//    func setupPaperDescriptionLabel() {
//        paperDescription.topAnchor.constraint(equalTo: paperView.bottomAnchor, constant: 4).isActive = true
//        paperDescription.leftAnchor.constraint(equalTo: paperView.leftAnchor).isActive = true
//        paperDescription.widthAnchor.constraint(equalTo: paperView.widthAnchor).isActive = true
//    }
//    
//    func setupAluminiumView() {
//        aluminiumView.topAnchor.constraint(equalTo: glassView.bottomAnchor, constant: 50).isActive = true
//        aluminiumView.leftAnchor.constraint(equalTo: glassView.leftAnchor).isActive = true
//        aluminiumView.widthAnchor.constraint(equalToConstant: 140).isActive = true
//        aluminiumView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//    }
//    
//    func setupAluminiumLabel() {
//        aluminiumLabel.topAnchor.constraint(equalTo: aluminiumView.topAnchor).isActive = true
//        aluminiumLabel.leftAnchor.constraint(equalTo: aluminiumView.leftAnchor).isActive = true
//        aluminiumLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
//        aluminiumLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//    }
//    
//    func setupAluminiumImageView() {
//        aluminiumImageView.topAnchor.constraint(equalTo: aluminiumView.topAnchor, constant: 10).isActive = true
//        aluminiumImageView.rightAnchor.constraint(equalTo: aluminiumView.rightAnchor, constant: -10).isActive = true
//        aluminiumImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        aluminiumImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
//    }
//    
//    func setupAluminiumDescriptionLabel() {
//        aluminiumDescription.topAnchor.constraint(equalTo: aluminiumView.bottomAnchor, constant: 4).isActive = true
//        aluminiumDescription.leftAnchor.constraint(equalTo: aluminiumView.leftAnchor).isActive = true
//        aluminiumDescription.widthAnchor.constraint(equalTo: aluminiumView.widthAnchor).isActive = true
//    }
//
//    func setupPlasticView() {
//        plasticView.topAnchor.constraint(equalTo: aluminiumView.topAnchor).isActive = true
//        plasticView.rightAnchor.constraint(equalTo: selectionContainerView.rightAnchor, constant: -36).isActive = true
//        plasticView.widthAnchor.constraint(equalToConstant: 140).isActive = true
//        plasticView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//    }
//    
//    func setupPlasticLabel() {
//        plasticLabel.topAnchor.constraint(equalTo: plasticView.topAnchor).isActive = true
//        plasticLabel.leftAnchor.constraint(equalTo: plasticView.leftAnchor).isActive = true
//        plasticLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
//        plasticLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//    }
//    
//    func setupPlasticImageView() {
//        plasticImageView.topAnchor.constraint(equalTo: plasticView.topAnchor, constant: 10).isActive = true
//        plasticImageView.rightAnchor.constraint(equalTo: plasticView.rightAnchor, constant: -10).isActive = true
//        plasticImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        plasticImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
//    }
//    
//    func setupPlasticDescriptionLabel() {
//        plasticDescription.topAnchor.constraint(equalTo: plasticView.bottomAnchor, constant: 4).isActive = true
//        plasticDescription.leftAnchor.constraint(equalTo: plasticView.leftAnchor).isActive = true
//        plasticDescription.widthAnchor.constraint(equalTo: plasticView.widthAnchor).isActive = true
//    }
//
//    func setupSelectionContainerView() {
//        selectionContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
//        selectionContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        selectionContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
//        selectionContainerView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
//    }
//    
    func setupInputsAddressContainerView() {
        inputsAddressContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 36).isActive = true
        inputsAddressContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsAddressContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsAddressContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -86).isActive = true
        
    }
    
    func setupConfirmButton() {
        confirmButton.topAnchor.constraint(equalTo: inputsAddressContainerView.bottomAnchor, constant: 20).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    
    
    
    
    
    
}

extension UILabel {
    
    func addressLabelAttributes() {
        self.font = UIFont.boldSystemFont(ofSize: 15)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = UIColor(r: 45, g: 45, b: 45)
    }
}

extension UITextField {
    
    func addressTextFieldAttributes() {
        self.font = UIFont.boldSystemFont(ofSize: 15)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
