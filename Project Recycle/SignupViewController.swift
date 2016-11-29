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
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var usersFRDBRef : FIRDatabaseReference = FIRDatabase.database().reference(withPath: "users")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSubmitButtonTouchUpInside(_ sender: UIButton) {
        let textFieldArray = [firstNameTextField, middleNameTextField, lastNameTextField, emailTextField, passwordTextField, passwordConfirmationTextField, titleTextField, phoneNumberTextField]
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
                                    "firstLine": "",
                                    "formattedAddress": ["","",""],
                                    "secondLine": "",
                                    "thirdLine": ""
                                ],
                                "completedOrders": "",
                                "currentOrders": "",
                                "email": self.emailTextField.text!,
                                "name": "\(self.firstNameTextField.text!) \(self.middleNameTextField.text!) \(self.lastNameTextField.text!)",
                                "phoneNumber": self.phoneNumberTextField.text!,
                                "profileImage": "",
                                "title": self.titleTextField.text!] as [String : Any]
                
                let userUID : String? = user!.uid
                let childUpdate = ["\(userUID!)/": userData]
                self.usersFRDBRef.updateChildValues(childUpdate)
                
                self.loginUser(email: self.emailTextField.text!, password: self.passwordTextField.text!)
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
                let signedOutAlert = UIAlertController.init(title: "Signed Out", message: "You have been signed out from Project Recycle. Please login again.", preferredStyle: .alert)
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
