//
//  SignupViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 28/11/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignupViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var addressFirstLineTextField: UITextField!
    @IBOutlet weak var addressSecondLineTextField: UITextField!
    @IBOutlet weak var addressThirdLineTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var usersFRDBRef : FIRDatabaseReference = FIRDatabase.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSignupButtonTouchUpInside(_ sender: UIButton) {
        let textFieldArray = [nameTextField, emailTextField, passwordTextField, passwordConfirmationTextField, addressFirstLineTextField, addressSecondLineTextField, addressThirdLineTextField, cityTextField, postcodeTextField, stateTextField, phoneNumberTextField]
        for textField: UITextField? in textFieldArray {
            if textField?.text != nil {
                
            } else {
                let fieldEmptyAlert = UIAlertController.init(title: "Empty Field", message: "One of the fields is empty, please try again.", preferredStyle: .alert)
                let okAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                fieldEmptyAlert.addAction(okAlertAction)
                self.present(fieldEmptyAlert, animated: true, completion: nil)
                return
            }
        }
        
        if passwordTextField.text != passwordConfirmationTextField.text {
            let passwordConfirmationErrorAlert = UIAlertController.init(title: "Passwords do not match.", message: "The passwords do not match, please try again.", preferredStyle: .alert)
            let okAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            passwordConfirmationErrorAlert.addAction(okAlertAction)
            self.present(passwordConfirmationErrorAlert, animated: true, completion: nil)
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if (error != nil) {
                print(error!)
                return
            } else {
                let userData = ["address": [
                    "firstLine": self.addressFirstLineTextField.text!,
                    "secondLine": self.addressSecondLineTextField.text!,
                    "thirdLine": self.addressThirdLineTextField.text!,
                    "city": self.cityTextField.text!,
                    "state": self.stateTextField.text!,
                    "postcode": self.postcodeTextField.text!,
                    "formattedAddress": [self.addressFirstLineTextField.text!, self.addressSecondLineTextField.text!, self.addressThirdLineTextField.text!, self.cityTextField.text!, self.postcodeTextField.text!, self.cityTextField.text!, self.stateTextField.text!, "Malaysia"]],
                                "email": self.emailTextField.text!,
                                "name": self.nameTextField.text!,
                                "phoneNumber": self.phoneNumberTextField.text!,
                                "currentOrders": "",
                                "completedOrders": "",
                                "profileImage": ""] as [String : Any]
                
                self.loginUser(email: self.emailTextField.text!, password: self.passwordTextField.text!)
                
                let userUID : String? = FIRAuth.auth()?.currentUser().uid
                let childUpdate = ["\(userUID!)/": userData]
                self.usersFRDBRef.updateChildValues(childUpdate)
                
                
            }
        }
    }
    
    func loginUser(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
            if let authError = error {
                print("Authentication error :\(authError)")
                return
            }
        })
        
        let signedInNotification = Notification(name: Notification.Name(rawValue: "SignedInNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(signedInNotification)
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                return
            } else {
                let signedOutAlert = UIAlertController.init(title: "Signed Out", message: "You have been signed out from Project Recycle.", preferredStyle: .alert)
                let okAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
                    let signedOutNotification = Notification(name: Notification.Name(rawValue: "SignedOutNotification"), object: nil, userInfo: nil)
                    NotificationCenter.default.post(signedOutNotification)
                })
                signedOutAlert.addAction(okAlertAction)
                self.present(signedOutAlert, animated: true, completion: nil)
            }
        }
    }
}
