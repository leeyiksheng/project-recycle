//
//  LoginViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 28/11/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //MARK: IB Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IB Actions
    
    @IBAction func onLoginButtonTouchUpInside(_ sender: UIButton) {
        loginUser()
    }
    
    @IBAction func onSignupButtonTouchUpInside(_ sender: UIButton) {
        
    }
    
    func loginUser() {
        if emailTextField.text != nil && passwordTextField.text != nil {
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                if let authError = error {
                    print("Authentication error :\(authError)")
                    return
                }
            })
        } else {
            let fieldEmptyAlert = UIAlertController.init(title: "Empty Field", message: "Your email or password field is empty, please try again.", preferredStyle: .alert)
            let okAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            fieldEmptyAlert.addAction(okAlertAction)
            self.present(fieldEmptyAlert, animated: true, completion: nil)
        }
        
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
