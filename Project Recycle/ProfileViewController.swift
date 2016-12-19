//
//  ProfileViewController.swift
//  Project Recycle
//
//  Created by Students on 11/30/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
var frDBref : FIRDatabaseReference!

protocol ProfileImageLibraryViewControllerProtocol {
    func dismissViewController(catchImage: UIImage)
}

class ProfileViewController: UIViewController, ProfileImageLibraryViewControllerProtocol {
    @IBOutlet weak var userProImage: UIImageView?
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var userNumberText: UITextField!
    @IBOutlet weak var userAddText: UITextView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var rightProfileButton: UIBarButtonItem!
   
    @IBOutlet weak var profileTitle: UINavigationItem!
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var changePassButton: UIButton!
    @IBOutlet weak var changeEmailButt: UIButton!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var activityIndicator = UIActivityIndicatorView()
    var emailText = ""
    var passText = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator.hidesWhenStopped = true

        profileTitle.navigationItemAttributes()
        nameLabel.mediumTitleFonts()
        phoneLabel.mediumTitleFonts()
        addressLabel.mediumTitleFonts()
        
        
        topBar.isHidden = false
        topBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        topBar.shadowImage? = UIImage()
        topBar.isTranslucent = true
        topBar.isOpaque = false
        topBar.backgroundColor = UIColor (colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.0)
        
        userProImage?.image = UIImage(named: "noone")
        userProImage?.layer.borderColor = UIColor.clear.cgColor
        userProImage?.layer.borderWidth = 1
        userProImage?.layer.masksToBounds = false
        userProImage?.layer.cornerRadius = (userProImage?.frame.height)!/2
        userProImage?.clipsToBounds = true
        userProImage?.isUserInteractionEnabled = true
        
        editProfileButton.layer.masksToBounds = false
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.cornerRadius = (editProfileButton.frame.height)/2
        editProfileButton.tintColor = UIColor.forestGreen
        editProfileButton.layer.borderColor = UIColor.forestGreen.cgColor
        editProfileButton.backgroundColor = UIColor.white
        editProfileButton.buttonFonts()
        editProfileButton.clipsToBounds = true
        editProfileButton.isUserInteractionEnabled = true
        editProfileButton.addTarget(self, action:#selector (editProfile(sender:)), for: .touchUpInside)
        
        signOutButton.tintColor = UIColor.white
        signOutButton.buttonFonts()
      
        
        changePassButton.tintColor = UIColor.forestGreen
        changePassButton.smallButtonFonts()
        changePassButton.isUserInteractionEnabled = true


        changeEmailButt.tintColor = UIColor.forestGreen
        changeEmailButt.smallButtonFonts()
        changeEmailButt.isUserInteractionEnabled = true

        userNameText.isUserInteractionEnabled = false
        userNumberText.isUserInteractionEnabled  = false
        userAddText.isUserInteractionEnabled  = false
        userNameText.userInputFonts()
        userNumberText.userInputFonts()
        userAddText.userTypedFonts()
        userNameText.borderStyle = UITextBorderStyle.none
        userNumberText.borderStyle = UITextBorderStyle.none
        userNameText.backgroundColor = UIColor.white
        userNumberText.backgroundColor = UIColor.white
        userAddText.backgroundColor = UIColor.white
        
        
        
        frDBref = FIRDatabase.database().reference()
        
        fetchUserInfo()
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        userProImage?.addGestureRecognizer(tap)
        
        
    }
    
    func indicatorRun()
    {
        let container = UIView()
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3)
        container.tag = 100
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
    
        self.activityIndicator.frame = CGRect (x: 0, y: 0, width: 40, height: 40)
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.activityIndicator.center = CGPoint(x: loadingView.frame.size.width/2, y: loadingView.frame.size.height/2)
    
        loadingView.addSubview(self.activityIndicator)
        container.addSubview(loadingView)
        
        self.view.addSubview(container)
        self.activityIndicator.startAnimating()
    }
    
    func indicatorStop()
    {
        self.activityIndicator.stopAnimating()
        if let viewWithTag = self.view.viewWithTag(100)
        {
            viewWithTag.removeFromSuperview()
        }
        
    }
    
    func editProfile (sender: UIButton)
    {
        if sender.titleLabel?.text == "Edit Profile"
        {
            sender.setTitle("Save Changes", for: .normal)
            userNameText.isUserInteractionEnabled  = true
            userNumberText.isUserInteractionEnabled  = true
            userAddText.isUserInteractionEnabled  = true
            userNameText.backgroundColor = UIColor.viewLightGray
            userNumberText.backgroundColor = UIColor.viewLightGray
            userAddText.backgroundColor = UIColor.viewLightGray
        }
        else
        {
            self.saveNewName()
            self.saveNewNumber()
            
            sender.setTitle("Edit Profile", for: .normal)
            userNameText.isUserInteractionEnabled  = false
            userNumberText.isUserInteractionEnabled  = false
            userAddText.isUserInteractionEnabled  = false
            userNameText.backgroundColor = UIColor.white
            userNumberText.backgroundColor = UIColor.white
            userAddText.backgroundColor = UIColor.white
        }
        
    }

    func imageTapped(sender: UIGestureRecognizer)
    {
        if let _ = sender.view as? UIImageView
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileImageLibrary") as! ProfileImageLibraryViewController
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)

        }
    }
    
    
    func dismissViewController(catchImage: UIImage)
    {
        
        self.dismiss(animated: false, completion: { () -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            self.present(vc, animated: true, completion: nil)
        })
        self.userProImage?.image = catchImage
    }
    
    
    private func fetchUserInfo()
    {
        self.indicatorRun()
        let newUser = User()
        newUser.initWithCurrentUser { () -> () in
            self.userNameText.text = "\(newUser.name)"
            self.userNumberText.text = "\(newUser.phoneNumber)"

            if newUser.addressIDArray.count != 0
            {
            self.userAddText.text = newUser.defaultFormattedAddress
            }
            else
            {
                self.userAddText.text = ""
            }
        

            if newUser.profileImage == "default" || newUser.profileImage == ""
            {
                
                self.userProImage?.image = UIImage(named: "noone")
                self.indicatorStop()
                
               
            }
            else
            {
                Downloader.getDataFromUrl(url: URL.init(string: newUser.profileImage)!, completion: { (data, response, error) in
                    
                    self.userProImage?.layer.borderColor = UIColor.forestGreen.cgColor
                    if error != nil
                    {
                        print(error!)
                        self.indicatorStop()
                        return
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.userProImage?.image = UIImage (data: data!)
                        self.indicatorStop()
                        
                    }
                    
                })
            }
        }
        
    }
    
    
    func saveNewName ()
    {
//        let holdName = userNameText.text
        let changeRequest = FIRAuth.auth()?.currentUser?.uid
        frDBref.child("users/\(changeRequest!)/name").setValue(userNameText.text)
//        userNameText.text = "  \(holdName!)"
    }
    

    
    func saveNewNumber ()
    {
//        let holdNumber = userNumberText.text
        let changeRequest = FIRAuth.auth()?.currentUser?.uid
        frDBref.child("users/\(changeRequest!)/phoneNumber").setValue(userNumberText.text)
//        userNumberText.text = "\(holdNumber!)"
    }
    
    

    
   
    @IBAction func editEmailButtPressed(_ sender: UIButton)
    {
        let noti = UIAlertController(title: "Change email", message: "Please enter a new email", preferredStyle: .alert)
        noti.addTextField(configurationHandler: {(textField : UITextField!) in
            textField.placeholder = "Enter a new email"
            self.emailText = textField.text!
        })
        
        noti.addTextField(configurationHandler: {(textFeed : UITextField!) in
            textFeed.placeholder = "Enter password to update"
            textFeed.isSecureTextEntry = true
            self.passText = textFeed.text!
        })
        
        noti.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.default, handler: nil))
        noti.addAction(UIAlertAction(title:"Update", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            
//            print(self.emailText)
//            print(self.passText)
            self.editEmailWithPassword(emailKey: noti.textFields![0], passKey: noti.textFields![1])
        
        }))
        
        present(noti, animated: true, completion: nil)

    }
        
        
    
    func editEmailWithPassword(emailKey: UITextField, passKey: UITextField)
    {
        let changeRequest = FIRAuth.auth()?.currentUser
        //should compare password
        if changeRequest != nil
        {
            changeRequest?.updateEmail((emailKey.text)!, completion: {(error) in
            if (error == nil)
            {
                print("success")
                frDBref.child("users/\((changeRequest?.uid)!)/email").setValue((emailKey.text)!)
                self.secondAlert(message: "updateEmailSuccess")
            }
            else
            {
                print("erorrrr :::::")
                print(error?.localizedDescription)
                self.secondAlert(message: "Loginagain")
            }
                })
        }

    }
    
    func editPassword(oldPass: UITextField, newPass: UITextField, conPass: UITextField)
    {
        
            let changeRequest = FIRAuth.auth()?.currentUser
        
            if changeRequest != nil
            {
                if newPass.text != conPass.text
                {
                    self.secondAlert(message: "Not match")
                }
                else
                {
                    changeRequest?.updatePassword((newPass.text)!, completion: {(error) in
                        if error != nil
                        {
                            self.secondAlert(message: "Loginagain")
                            print(error?.localizedDescription)
                        }
                        else
                        {
                            self.secondAlert(message: "match")
                        }
                    })
                }
            }
    }

    
    

    
    @IBAction func signOutButtPressed(_ sender: UIButton)
    {
        let popUp = UIAlertController(title: "Log Out", message: "yes or no", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "YES", style: .default){ (action) in
            do
            {
                try FIRAuth.auth()?.signOut()
                
            }
            catch let logoutError {
                print(logoutError)
            }
            self.notifySuccessLogout()
        }
        popUp.addAction(noButton)
        popUp.addAction(yesButton)
        present(popUp, animated: true, completion: nil)
        
    }
    
    func notifySuccessLogout()
    {
        let UserLogoutNotification = Notification (name: Notification.Name(rawValue: "UserLogoutNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(UserLogoutNotification)
    }
    
    
    
    
    
    @IBAction func changePassButtPressed(_ sender: UIButton)
    {
        
        let noti = UIAlertController(title: "Change Password", message: "Fill in the fields to change password", preferredStyle: .alert)
        noti.addTextField(configurationHandler: {(old: UITextField!) in
            old.placeholder = "Enter current password"
            old.isSecureTextEntry = true
        })
        noti.addTextField(configurationHandler: {(new: UITextField!) in
            new.placeholder = "Enter a new password"
            new.isSecureTextEntry = true
        })
        noti.addTextField(configurationHandler: {(con: UITextField!) in
            con.placeholder = "Confirm your new password"
            con.isSecureTextEntry = true
        })
        
        noti.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        noti.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            self.editPassword(oldPass: noti.textFields![0], newPass: noti.textFields![1], conPass: noti.textFields![2])
            
                    }))
        
        present(noti, animated: true, completion: nil)
        
    }
    
    func secondAlert(message : String)
    {
        if message == "Not match"
        {
            let alert = UIAlertController(title: "Not match", message: "New Password is not match to confirm password. Or You should try SIGN OUT & SIGN IN again to enable you to change password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else if message == "match"
        {
            let alert = UIAlertController(title: "Update Password Successful", message: "You have successfully update your password. Remember to SIGN OUT & SIGN IN again to proceed for other actions.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else if message == "updateEmailSuccess"
        {
            let alert = UIAlertController(title: "Update Email Successful", message: "You have successfully update your Email. Make sure you SIGN OUT & SIGN IN again to proceed other actions.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else if message == "Loginagain"
        {
            let alert = UIAlertController(title: "Update Unsuccessful", message: "Please log out and log in again to enable updates and more.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
