//
//  LoginViewController.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 28/11/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    

    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.loginTextFieldAttributes()
        tf.attributedPlaceholder = NSAttributedString(string: "  Email Address", attributes: [NSForegroundColorAttributeName: UIColor.textLightGray])
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.loginTextFieldAttributes()
        tf.attributedPlaceholder = NSAttributedString(string: "  Password", attributes: [NSForegroundColorAttributeName: UIColor.textLightGray])
        return tf
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleLoginUser), for: .touchUpInside)
        return button
    }()
    
    func handleLoginUser() {
        if emailTextField.text != nil && passwordTextField.text != nil {
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                if let authError = error {
                    print("Authentication error :\(authError)")
                    return
                } else {
                    let signedInNotification = Notification(name: Notification.Name(rawValue: "SignedInNotification"), object: nil, userInfo: nil)
                    NotificationCenter.default.post(signedInNotification)
                }
            })
        } else {
            let fieldEmptyAlert = UIAlertController.init(title: "Empty Field", message: "Your email or password field is empty, please try again.", preferredStyle: .alert)
            let okAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            fieldEmptyAlert.addAction(okAlertAction)
            self.present(fieldEmptyAlert, animated: true, completion: nil)
        }
    }
    
    
    lazy var signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleSignUpUser), for: .touchUpInside)
        return button
    }()

    func handleSignUpUser() {
        emailTextField.removeFromSuperview()
        passwordTextField.removeFromSuperview()
        loginButton.removeFromSuperview()
        signUpButton.removeFromSuperview()
        
        
        self.view.addSubview(nameSignUpTextField)
        self.view.addSubview(emailSignUpTextField)
        self.view.addSubview(passwordSignUpTextField)
        self.view.addSubview(confirmPasswordTextField)
        self.view.addSubview(confirmButton)
        self.view.addSubview(backButton)
        
        
        
        setupNameSignUpTextField()
        setupEmailSignUpTextField()
        setupPasswordSignUpTextField()
        setupConfirmPasswordTextField()
        setupConfirmButton()
        setupBackButton()
    }
    
    //MARK: SignUp Views
    
    let nameSignUpTextField: UITextField = {
        let tf = UITextField()
        tf.loginTextFieldAttributes()
        tf.attributedPlaceholder = NSAttributedString(string: "  Full Name", attributes: [NSForegroundColorAttributeName: UIColor.textLightGray])
        return tf
    }()
    
    func checkNameTextField() {
        if nameSignUpTextField.text != nil {
            if nameSignUpTextField.text!.rangeOfCharacter(from: .letters) != nil {
                //dont do anything
            } else {
                //do something
                
            }
        }
    }
    
    let emailSignUpTextField: UITextField = {
        let tf = UITextField()
        tf.loginTextFieldAttributes()
        tf.attributedPlaceholder = NSAttributedString(string: "  Email Address", attributes: [NSForegroundColorAttributeName: UIColor.textLightGray])
        return tf
    }()
    
    func checkEmailTextField() {
        if emailSignUpTextField.text != nil {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: emailSignUpTextField.text) {
                //dont do anything
            } else {
                //do something
                
            }
        }
    }
    
    let passwordSignUpTextField: UITextField = {
        let tf = UITextField()
        tf.loginTextFieldAttributes()
        tf.attributedPlaceholder = NSAttributedString(string: "  Password", attributes: [NSForegroundColorAttributeName: UIColor.textLightGray])
        return tf
    }()
    
    lazy var confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.loginTextFieldAttributes()
        tf.attributedPlaceholder = NSAttributedString(string: "  Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor.textLightGray])
        tf.addTarget(self, action: #selector(checkPasswordTextFields), for: .editingDidEnd)
        return tf
    }()
    
    func checkPasswordTextFields() {
        if confirmPasswordTextField.text != nil {
            if confirmPasswordTextField.text!.characters.count < 6 {
                //dont do anything
            } else {
                //do something
            }
        }
    }
    
    lazy var confirmButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    func handleSignUp() {
        if confirmPasswordTextField.text! == passwordSignUpTextField.text! {
            FIRAuth.auth()?.createUser(withEmail: emailSignUpTextField.text!, password: passwordSignUpTextField.text!) { (user, error) in
                if (error != nil) {
                    print(error!)
                    return
                } else {
                    let userData = ["email": self.emailSignUpTextField.text!,
                                    "name": self.nameSignUpTextField.text!,
                                    "profileImage": "default"] as [String : Any]
                    
                    self.loginUser(email: self.emailSignUpTextField.text!, password: self.passwordSignUpTextField.text!)
                    
                    let userUID : String? = FIRAuth.auth()?.currentUser?.uid
                    let childUpdate = ["\(userUID!)/": userData]
                    self.usersFRDBRef.updateChildValues(childUpdate)
                }
            }
        }
    }

    
    lazy var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    func handleBack() {
        nameSignUpTextField.removeFromSuperview()
        emailSignUpTextField.removeFromSuperview()
        passwordSignUpTextField.removeFromSuperview()
        confirmPasswordTextField.removeFromSuperview()
        confirmButton.removeFromSuperview()
        backButton.removeFromSuperview()
        
        
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(signUpButton)
        
        
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupSignUpButton()
    }
    
    
    var usersFRDBRef : FIRDatabaseReference = FIRDatabase.database().reference(withPath: "users")
    var signUpButtonPress = false

    
    //MARK: View Functions®
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        let webViewBG = UIWebView(frame: self.view.frame)
        let url = Bundle.main.url(forResource: "loginBackground", withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webViewBG.load(data, mimeType: "image/gif", textEncodingName: "UTF-8", baseURL: NSURL() as URL)
        webViewBG.scalesPageToFit = true
        webViewBG.contentMode = UIViewContentMode.scaleToFill
        webViewBG.contentMode = UIViewContentMode.scaleAspectFit
        webViewBG.isUserInteractionEnabled = false;
        self.view.addSubview(webViewBG)
        
        let filter = UIView()
        filter.frame = self.view.frame
        filter.backgroundColor = UIColor.black
        filter.alpha = 0.2
        self.view.addSubview(filter)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(signUpButton)
        
        
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupSignUpButton()
        
        //Signup
        
    }
    

    
    func setupEmailTextField() {
        emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 275).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupPasswordTextField() {
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 6).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupLoginButton() {
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 60).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setupSignUpButton() {
        signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: -> Constraints for signup
    
    func setupNameSignUpTextField() {
        nameSignUpTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 165).isActive = true
        nameSignUpTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        nameSignUpTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        nameSignUpTextField.signUpTextFieldHeight()
    }
    
    func setupEmailSignUpTextField() {
        emailSignUpTextField.topAnchor.constraint(equalTo: nameSignUpTextField.bottomAnchor, constant: 12).isActive = true
        emailSignUpTextField.leftAnchor.constraint(equalTo: nameSignUpTextField.leftAnchor).isActive = true
        emailSignUpTextField.rightAnchor.constraint(equalTo: nameSignUpTextField.rightAnchor).isActive = true
        emailSignUpTextField.signUpTextFieldHeight()
    }
    
    func setupPasswordSignUpTextField() {
        passwordSignUpTextField.topAnchor.constraint(equalTo: emailSignUpTextField.bottomAnchor, constant: 12).isActive = true
        passwordSignUpTextField.leftAnchor.constraint(equalTo: nameSignUpTextField.leftAnchor).isActive = true
        passwordSignUpTextField.rightAnchor.constraint(equalTo: nameSignUpTextField.rightAnchor).isActive = true
        passwordSignUpTextField.signUpTextFieldHeight()
    }
    
    func setupConfirmPasswordTextField() {
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordSignUpTextField.bottomAnchor, constant: 12).isActive = true
        confirmPasswordTextField.leftAnchor.constraint(equalTo: nameSignUpTextField.leftAnchor).isActive = true
        confirmPasswordTextField.rightAnchor.constraint(equalTo: nameSignUpTextField.rightAnchor).isActive = true
        confirmPasswordTextField.signUpTextFieldHeight()
    }
    
    func setupConfirmButton() {
        backButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 60).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }

    func setupBackButton() {
    
        confirmButton.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 12).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    
    func loginUser(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: emailSignUpTextField.text!, password: passwordSignUpTextField.text!, completion: {(user, error) in
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





extension UITextField {
    
    func loginTextFieldAttributes() {
        self.font = UIFont.boldSystemFont(ofSize: 14)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.forestGreen.cgColor
        self.textColor = UIColor.white
    }
    
    func signUpTextFieldAttributes() {
        self.font = UIFont.boldSystemFont(ofSize: 14)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.forestGreen.cgColor
        self.textColor = UIColor.white
        
        
    }
    
    func loginTextFieldHeight() {
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func signUpTextFieldHeight() {
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}



