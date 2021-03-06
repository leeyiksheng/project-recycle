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
        tf.keyboardType = UIKeyboardType.emailAddress
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
        button.buttonFonts()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = (UIColor.forestGreen).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleLoginUser), for: .touchUpInside)
        return button
    }()
    
    func handleLoginUser() {
        if emailTextField.text != nil && passwordTextField.text != nil {
            loginUser(email: emailTextField.text!, password: passwordTextField.text!)
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
        button.buttonFonts()
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
        tf.keyboardType = UIKeyboardType.emailAddress
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
        button.buttonFonts()
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
        button.buttonFonts()
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
    var emailTextFieldTopAnchor: NSLayoutConstraint?
    var nameSignUpTextFieldTopAnchor: NSLayoutConstraint?

    
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        filter.addGestureRecognizer(tap)
        
        self.view.addSubview(filter)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(signUpButton)
        
        
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupSignUpButton()
        setupKeyboardObservers()
    }
    
   
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector:#selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(notification: NSNotification) {
        print(notification.userInfo)
        let userInfo = notification.userInfo! as NSDictionary
        let keyboardFrame = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let viewHeight = self.view.frame.height
        
        emailTextFieldTopAnchor?.constant = viewHeight - 126 - keyboardHeight
        nameSignUpTextFieldTopAnchor?.constant = viewHeight - 228 - keyboardHeight
    }

    
    func handleKeyboardWillHide() {
        emailTextFieldTopAnchor?.constant = 275
        nameSignUpTextFieldTopAnchor?.constant = 165
    }
    
    
    func setupEmailTextField() {
        emailTextFieldTopAnchor = emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 275)
        emailTextFieldTopAnchor?.isActive = true
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
        nameSignUpTextFieldTopAnchor = nameSignUpTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 165)
        nameSignUpTextFieldTopAnchor?.isActive = true
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
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                        // universal errors
                    case .errorCodeNetworkError:
                        self.displayAlertWith(message: "A network error occured. Please check if you have a valid Internet connection.")
                    case .errorCodeUserNotFound:
                        self.displayAlertWith(message: "Credentials do not match any users in our database. Please check your entered fields again.")
                    case .errorCodeUserTokenExpired:
                        self.displayAlertWith(message: "You have recently changed your password on a different device, please sign in again with your updated credentials.")
                    case .errorCodeTooManyRequests:
                        self.displayAlertWith(message: "You have been temporarily suspended from logging in due to our servers receiving too many requests from your IP address.")
                    case .errorCodeInvalidAPIKey:
                        self.displayAlertWith(message: "The application was configured with an invalid API key, this is abnormal. Please contact admin@projectrecycle.com to allow us to help you.")
                    case .errorCodeAppNotAuthorized:
                        self.displayAlertWith(message: "The application was not authorized to connect to the servers with the provided API key, this is abnormal. Please contact admin@projectrecycle.com to allow us to help you.")
                    case .errorCodeKeychainError:
                        self.displayAlertWith(message: "A keychain error occured. Please contact the administrator at admin@projectrecycle.com to allow us to help you.")
                    case .errorCodeInternalError:
                        self.displayAlertWith(message: "An internal error occured within our servers. Please try again later.")
                        // email & password errors
                    case .errorCodeInvalidEmail:
                        self.displayAlertWith(message: "Invalid email detected. Please check the email you typed in again.")
                    case .errorCodeOperationNotAllowed:
                        self.displayAlertWith(message: "This account has not been enabled in our system. Please contact admin@projectrecycle.com for further details.")
                    case .errorCodeWrongPassword:
                        self.displayAlertWith(message: "Invalid password detected. Please review your password again.")
                    case .errorCodeUserDisabled:
                        self.displayAlertWith(message: "This user has been disabled by the administrator. Please contact admin@projectrecycle.com for further enquiries.")
                    case .errorCodeInvalidCredential:
                        self.displayAlertWith(message: "Invalid credentials detected. Please check your entered fields again.")
                    case .errorCodeUserMismatch:
                        self.displayAlertWith(message: "Invalid re-authentication by a user which is not the current user. Please restart the app and try again.")
                    default: self.displayAlertWith(message: "An unknown error occured.")
                    }
                }
                return
            }
            
            let signedInNotification = Notification(name: Notification.Name(rawValue: "SignedInNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(signedInNotification)
            
            FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
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
        })
    }
    
    func displayAlertWith(message: String) {
        let errorAlert = UIAlertController.init(title: "Authentication Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
}





extension UITextField {
    
    func loginTextFieldAttributes() {
        self.userInputFonts()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.forestGreen.cgColor
        self.textColor = UIColor.white
    }
    
    func signUpTextFieldAttributes() {
        self.userInputFonts()
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



