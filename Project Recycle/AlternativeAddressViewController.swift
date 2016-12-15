//
//  AlternativeAddressViewController.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 12/1/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class AlternativeAddressViewController: UIViewController {



    let inputsAddressContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var confirmButton : UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.buttonFonts()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleNewAddress), for: .touchUpInside)
        return button
    }()
    
    func handleNewAddress() {
        var formattedAddress = ""
        var contact = ""
        var name = ""
        
        if let receiverName = receiverNameTextField.text {
            if receiverName != "" {
                name = receiverName
            } else {
                return
            }
        }
        
        if let contactNo = phoneNoTextField.text {
            if contactNo != "" {
                contact = contactNo
            } else {
                return
            }
        }
        
        
        if let add1 = alternativeAddress1TextField.text {
            if add1 != "" {
                formattedAddress = add1 + String(", ")
            } else {
                return
            }
        }
        
        if let add2 = alternativeAddress2TextField.text {
            if add2 != "" {
                formattedAddress =  formattedAddress + add2 + String(", ")
            }
        }
        
        if let add3 = alternativeAddress3TextField.text {
            if add3 != "" {
                formattedAddress =  formattedAddress + add3 + String(", ")
            }
        }
        
        if let postcode = postcodeTextField.text {
            if postcode != "" {
                formattedAddress =  formattedAddress + postcode + String(", ")
            } else {
                return
            }
        }
        
        if let city = cityTextField.text {
            if city != "" {
                formattedAddress =  formattedAddress + city + String(", ")
            } else {
                return
            }
        }
        
        if let state = stateTextField.text {
            if state != "" {
                formattedAddress =  formattedAddress + state
            } else {
                return
            }
        }
        
        
        formattedAddress =  formattedAddress + String(", Malaysia.")
        print(formattedAddress)
        
        
        let newAddress = NewAddresses.init(UID: self.userUID, address: formattedAddress, receiverName: name, receiverContact: contact)
        
        newAddress.submitAddress()
        
        dismiss(animated: true, completion: nil)
    }

    let receiverNameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "  Full Name"
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let receiverNameLabel: UILabel = {
        let label = UILabel()
        label.text = "  RECEIVER NAME"
        label.addressLabelAttributes()
        return label
    }()

    
    let alternativeAddress1TextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "  e.g No 13 @ndFloor , Blok B"
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let alternativeAddress2TextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "  e.g HighNoon apartment"
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let alternativeAddress3TextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "  e.g Taman High noon"
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
        tf.placeholder = "  e.g 81200"
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
        tf.placeholder = "  Phone Number"
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let phoneNoLabel: UILabel = {
        let label = UILabel()
        label.text = "PHONE NO"
        label.addressLabelAttributes()
        return label
    }()
    
    let otherPhoneNoTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "  Phone Number"
        tf.addressTextFieldAttributes()
        return tf
    }()
    
    let otherPhoneNoLabel: UILabel = {
        let label = UILabel()
        label.text = "OTHER NO"
        label.addressLabelAttributes()
        return label
    }()
    
    var navigationBarHeight: CGFloat = 0
    let spaceBetweenLabel: CGFloat = 18
    let spaceBetweenTextField: CGFloat = 4
    var userUID = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else {return}
        self.userUID = currentUser
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
        navigationItem.title = "New Address"
        navigationController?.navigationBarAttributes()
        navigationItem.navigationItemAttributes()
        navigationBarHeight = self.navigationController!.navigationBar.frame.height
        view.backgroundColor = UIColor.viewLightGray
        view.addSubview(inputsAddressContainerView)
        view.addSubview(receiverNameLabel)
        view.addSubview(receiverNameTextField)
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
        view.addSubview(otherPhoneNoLabel)
        view.addSubview(otherPhoneNoTextField)
        view.addSubview(confirmButton)
        
        
        setupInputsAddressContainerView()
        setupConfirmButton()
        setupReceiverNameLabel()
        setupReceiverNameTextField()
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
        setupOtherPhoneNoLabel()
        setupOtherPhoneNoTextField()
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupReceiverNameLabel() {
        receiverNameLabel.topAnchor.constraint(equalTo: inputsAddressContainerView.topAnchor, constant: 12).isActive = true
        receiverNameLabel.leftAnchor.constraint(equalTo: inputsAddressContainerView.leftAnchor, constant: 8).isActive = true
    }
    
    func setupReceiverNameTextField() {
        receiverNameTextField.topAnchor.constraint(equalTo: receiverNameLabel.bottomAnchor, constant: 4).isActive = true
        receiverNameTextField.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        receiverNameTextField.widthAnchor.constraint(equalTo: inputsAddressContainerView.widthAnchor, constant: -16).isActive = true
        receiverNameTextField.addressTextFieldHeight()
    }
    
    func setupAddressLabelsetup() {
        addressLabel.topAnchor.constraint(equalTo: receiverNameTextField.bottomAnchor, constant: spaceBetweenLabel).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
    }
    
    func setupAlternativeAddress1TextField() {
        alternativeAddress1TextField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: spaceBetweenTextField).isActive = true
        alternativeAddress1TextField.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        alternativeAddress1TextField.widthAnchor.constraint(equalTo: inputsAddressContainerView.widthAnchor, constant: -16).isActive = true
        alternativeAddress1TextField.addressTextFieldHeight()

    }
    
    func setupAlternativeAddress2TextField() {
        alternativeAddress2TextField.topAnchor.constraint(equalTo: alternativeAddress1TextField.bottomAnchor, constant: spaceBetweenTextField).isActive = true
        alternativeAddress2TextField.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        alternativeAddress2TextField.widthAnchor.constraint(equalTo: inputsAddressContainerView.widthAnchor, constant: -16).isActive = true
        alternativeAddress2TextField.addressTextFieldHeight()

    }
    
    func setupAlternativeAddress3TextField() {
        alternativeAddress3TextField.topAnchor.constraint(equalTo: alternativeAddress2TextField.bottomAnchor, constant: spaceBetweenTextField).isActive = true
        alternativeAddress3TextField.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        alternativeAddress3TextField.widthAnchor.constraint(equalTo: inputsAddressContainerView.widthAnchor, constant: -16).isActive = true
        alternativeAddress3TextField.addressTextFieldHeight()

    }
    
    func setupCityLabel() {
        cityLabel.topAnchor.constraint(equalTo: alternativeAddress3TextField.bottomAnchor, constant: spaceBetweenLabel).isActive = true
        cityLabel.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
    }
    
    func setupCityTextField() {
        cityTextField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: spaceBetweenTextField).isActive = true
        cityTextField.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        cityTextField.widthAnchor.constraint(equalTo: inputsAddressContainerView.widthAnchor, constant: -16).isActive = true
        cityTextField.addressTextFieldHeight()
    }
    
    func setupPostcodeLabel() {
        postcodeLabel.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: spaceBetweenLabel).isActive = true
        postcodeLabel.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
    }
    
    func setupPostcodeTextField() {
        postcodeTextField.topAnchor.constraint(equalTo: postcodeLabel.bottomAnchor, constant: spaceBetweenTextField).isActive = true
        postcodeTextField.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        postcodeTextField.widthAnchor.constraint(equalTo: inputsAddressContainerView.widthAnchor, constant: -16).isActive = true
        postcodeTextField.addressTextFieldHeight()
    }
    
    func setupStateLabel() {
        stateLabel.topAnchor.constraint(equalTo: postcodeTextField.bottomAnchor, constant: spaceBetweenLabel).isActive = true
        stateLabel.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
    }
    
    func setupStateTextField() {
        stateTextField.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: spaceBetweenTextField).isActive = true
        stateTextField.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        stateTextField.widthAnchor.constraint(equalTo: inputsAddressContainerView.widthAnchor, constant: -16).isActive = true
        stateTextField.addressTextFieldHeight()
    }
    
    func setupPhoneNoLabel() {
        phoneNoLabel.topAnchor.constraint(equalTo: stateTextField.bottomAnchor, constant: spaceBetweenLabel).isActive = true
        phoneNoLabel.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
    }
    
    func setupPhoneNoTextField() {
        phoneNoTextField.topAnchor.constraint(equalTo: phoneNoLabel.bottomAnchor, constant: spaceBetweenTextField).isActive = true
        phoneNoTextField.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        phoneNoTextField.widthAnchor.constraint(equalTo: inputsAddressContainerView.widthAnchor, constant: -16).isActive = true
        phoneNoTextField.addressTextFieldHeight()
    }
    
    func setupOtherPhoneNoLabel() {
        otherPhoneNoLabel.topAnchor.constraint(equalTo: phoneNoTextField.bottomAnchor, constant: spaceBetweenLabel).isActive = true
        otherPhoneNoLabel.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
    }
    
    func setupOtherPhoneNoTextField() {
        otherPhoneNoTextField.topAnchor.constraint(equalTo: otherPhoneNoLabel.bottomAnchor, constant: spaceBetweenTextField).isActive = true
        otherPhoneNoTextField.leftAnchor.constraint(equalTo: receiverNameLabel.leftAnchor).isActive = true
        otherPhoneNoTextField.widthAnchor.constraint(equalTo: inputsAddressContainerView.widthAnchor, constant: -16).isActive = true
        otherPhoneNoTextField.addressTextFieldHeight()
    }
    
    func setupInputsAddressContainerView() {
        inputsAddressContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight + 12).isActive = true
        inputsAddressContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsAddressContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        inputsAddressContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -96).isActive = true
        
    }
    
    func setupConfirmButton() {
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    
    
    
    
    
    
}

extension UILabel {
    
    func addressLabelAttributes() {
        self.mediumTitleFonts()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = UIColor.black
    }
    
}

extension UITextField {
    
    func addressTextFieldAttributes() {
        self.userInputFonts()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.forestGreen.cgColor

    }
    
    func addressTextFieldHeight() {
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
