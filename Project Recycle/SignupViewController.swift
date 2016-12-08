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
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.addTarget(self, action: #selector(checkNameTextField), for: .editingDidEnd)
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.addTarget(self, action: #selector(checkEmailTextField), for: .editingDidEnd)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField! {
        didSet {
            passwordConfirmationTextField.addTarget(self, action: #selector(checkPasswordTextFields), for: .editingDidEnd)
        }
    }
    @IBOutlet weak var nameErrorImageView: UIImageView! {
        didSet {
            nameErrorImageView.isHidden = true
        }
    }
    @IBOutlet weak var nameErrorLabel: UILabel! {
        didSet {
            nameErrorLabel.isHidden = true
        }
    }
    @IBOutlet weak var emailErrorImageView: UIImageView! {
        didSet {
            emailErrorImageView.isHidden = true
        }
    }
    @IBOutlet weak var emailErrorLabel: UILabel! {
        didSet {
            emailErrorLabel.isHidden = true
        }
    }
    @IBOutlet weak var passwordErrorImageView: UIImageView! {
        didSet {
            passwordErrorImageView.isHidden = true
        }
    }
    @IBOutlet weak var passwordErrorLabel: UILabel! {
        didSet {
            passwordErrorLabel.isHidden = true
        }
    }
    
    var usersFRDBRef : FIRDatabaseReference = FIRDatabase.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSignupButtonTouchUpInside(_ sender: UIButton) {
        if emailErrorLabel.isHidden && passwordErrorLabel.isHidden && nameErrorLabel.isHidden {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if (error != nil) {
                    print(error!)
                    return
                } else {
                    let userData = ["email": self.emailTextField.text!,
                                    "name": self.nameTextField.text!,
                                    "profileImage": "default"] as [String : Any]
                    
                    self.loginUser(email: self.emailTextField.text!, password: self.passwordTextField.text!)
                    
                    let userUID : String? = FIRAuth.auth()?.currentUser?.uid
                    let childUpdate = ["\(userUID!)/": userData]
                    self.usersFRDBRef.updateChildValues(childUpdate)
                }
            }
        }
    }
    
    func checkPasswordTextFields() {
        if passwordConfirmationTextField.text != nil {
            if passwordConfirmationTextField.text!.characters.count < 6 {
                passwordErrorImageView.isHidden = false
                passwordErrorLabel.isHidden = false
            } else {
                passwordErrorImageView.isHidden = true
                passwordErrorLabel.isHidden = true
            }
        }
    }
    
    func checkEmailTextField() {
        if emailTextField.text != nil {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: emailTextField.text) {
                emailErrorImageView.isHidden = true
                emailErrorLabel.isHidden = true
            } else {
                emailErrorImageView.isHidden = false
                emailErrorLabel.isHidden = false
            }
        }
    }
    
    func checkNameTextField() {
        if nameTextField.text != nil {
            if nameTextField.text!.rangeOfCharacter(from: .letters) != nil {
                nameErrorImageView.isHidden = true
                nameErrorLabel.isHidden = true
            } else {
                nameErrorImageView.isHidden = false
                nameErrorLabel.isHidden = false
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
