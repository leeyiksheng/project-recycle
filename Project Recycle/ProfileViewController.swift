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
    func dismissViewController()
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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var personalDetails: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//          for font family search
//        for name in UIFont.familyNames
//        {
//            print(name)
//            for namename in UIFont.fontNames(forFamilyName: name)
//            {
//                print(namename)
//            }
//        }

        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        

        
        self.view.backgroundColor = UIColor.viewLightGray
        profileTitle.navigationItemAttributes()
        nameLabel.mediumTitleFonts()
        phoneLabel.mediumTitleFonts()
        addressLabel.mediumTitleFonts()
        
        
        topBar.isHidden = false
        topBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        topBar.shadowImage? = UIImage()
        topBar.isTranslucent = true
        topBar.isOpaque = false
        topBar.backgroundColor = UIColor (colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        
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
        
        signOutButton.tintColor = UIColor.forestGreen
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
        userNameText.backgroundColor = UIColor.viewLightGray
        userNumberText.backgroundColor = UIColor.viewLightGray
        userAddText.backgroundColor = UIColor.viewLightGray
        
        
        frDBref = FIRDatabase.database().reference()
        
        fetchUserInfo()
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        userProImage?.addGestureRecognizer(tap)
        
        
    }
    
    func editProfile (sender: UIButton)
    {
        if sender.titleLabel?.text == "Edit Profile"
        {
            sender.setTitle("Save Changes", for: .normal)
            userNameText.isUserInteractionEnabled  = true
            userNumberText.isUserInteractionEnabled  = true
            userAddText.isUserInteractionEnabled  = true
            userNameText.backgroundColor = UIColor.white
            userNumberText.backgroundColor = UIColor.white
            userAddText.backgroundColor = UIColor.white
        }
        else
        {
            self.saveNewName()
            self.saveNewNumber()
            
            sender.setTitle("Edit Profile", for: .normal)
            userNameText.isUserInteractionEnabled  = false
            userNumberText.isUserInteractionEnabled  = false
            userAddText.isUserInteractionEnabled  = false
            userNameText.backgroundColor = UIColor.viewLightGray
            userNumberText.backgroundColor = UIColor.viewLightGray
            userAddText.backgroundColor = UIColor.viewLightGray
        }
        
    }
    
    
    
    
    func imageTapped(sender: UIGestureRecognizer)
    {
        if let imagePressed = sender.view as? UIImageView
        {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileImageLibrary") as! ProfileImageLibraryViewController
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            

        }
    }
    
    
    func dismissViewController()
    {
        self.dismiss(animated: false, completion: { () -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            self.present(vc, animated: true, completion: nil)
        })
    }
    
    
    private func fetchUserInfo()
    {
        self.activityIndicator.startAnimating()
        let newUser = User()
        newUser.initWithCurrentUser { () -> () in
            self.userNameText.text = newUser.name
            self.userNumberText.text = newUser.phoneNumber

            
            
            

            self.userAddText.text = newUser.defaultFormattedAddress

        

            if newUser.profileImage == "default" || newUser.profileImage == ""
            {
                
                self.userProImage?.image = UIImage(named: "noone")
                self.activityIndicator.stopAnimating()
                
               
            }
            else
            {
                Downloader.getDataFromUrl(url: URL.init(string: newUser.profileImage)!, completion: { (data, response, error) in
                    
                    self.userProImage?.layer.borderColor = UIColor.forestGreen.cgColor
                    if error != nil
                    {
                        print(error!)
                        self.activityIndicator.stopAnimating()
                        return
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.userProImage?.image = UIImage (data: data!)
                        self.activityIndicator.stopAnimating()
                        
                    }
                    
                })
            }
        }
        
    }
    
    
    func saveNewName ()
    {
        let changeRequest = FIRAuth.auth()?.currentUser?.uid
        frDBref.child("users/\(changeRequest!)/name").setValue(userNameText.text)
    }
    

    
    func saveNewNumber ()
    {
        let changeRequest = FIRAuth.auth()?.currentUser?.uid
        frDBref.child("users/\(changeRequest!)/phoneNumber").setValue(userNumberText.text)
    }
    
    

    
   
    @IBAction func editEmailButtPressed(_ sender: UIButton)
    {
        
        var emailText: UITextField?
        var passText: UITextField?
        let noti = UIAlertController(title: "Change Email", message: "Please enter a new email", preferredStyle: .alert)
        noti.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter a new Email"
            emailText = textField
        })
        noti.addTextField(configurationHandler: {(textFeed: UITextField!) in
            textFeed.placeholder = "Enter password to confirm update password"
            textFeed.isSecureTextEntry = true
            passText = textFeed
        })
        noti.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        noti.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let changeRequest = FIRAuth.auth()?.currentUser
            
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: (changeRequest?.email)!, password: (passText?.text)!)
            
            changeRequest?.reauthenticate(with: credential, completion: {(error) in
                if let error = error
                {
                    print("error:::::")
                    print(error.localizedDescription)
                }
                else
                {
                    
                    changeRequest?.updateEmail((emailText?.text)!, completion: {(error) in
                        if (error != nil)
                        {
                            print(error?.localizedDescription)
                        }
                        else
                        {
//                            let alertController = UIAlertController(title: "Update Email", message: "You have successfully updated your email", preferredStyle: .alert)
//                            alertController.addAction(UIAlertAction(title: "OK, Thanks", style: UIAlertActionStyle.default, handler: nil))
                            
                            print("success")
                            frDBref.child("users/\((changeRequest?.uid)!)/email").setValue(emailText!.text)
                        }
                    })
                    
                }
                
                
                
            })
            
        }))
        present(noti,animated: true, completion:  nil)
    }
    
//    @IBAction func editAddButtPressed(_ sender: UIButton)
//    {
//        var add1: UITextField!
//        var add2: UITextField!
//        var add3: UITextField!
//        var post: UITextField!
//        var siti: UITextField!
//        var state: UITextField!
//        
//        let noti = UIAlertController(title: "Change Address", message: "Please enter your address", preferredStyle: .alert)
//        noti.addTextField(configurationHandler: {(line1: UITextField!) in
//            line1.placeholder = "First Line Address"
//            add1 = line1!
//        })
//        noti.addTextField(configurationHandler: {(line2: UITextField!) in
//            line2.placeholder = "Second Line Address"
//            add2 = line2!
//        })
//        noti.addTextField(configurationHandler: {(line3: UITextField!) in
//            line3.placeholder = "Third Line Address"
//            add3 = line3!
//        })
//        noti.addTextField(configurationHandler: {(code: UITextField!) in
//            code.placeholder = "Postcode"
//            post = code!
//        })
//        noti.addTextField(configurationHandler: {(town: UITextField!) in
//            town.placeholder = "City"
//            siti = town!
//        })
//        noti.addTextField(configurationHandler: {(district: UITextField!) in
//            district.placeholder = "State"
//            state = district!
//        })
//        noti.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
//        noti.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) -> Void in
//            let changeRequest = FIRAuth.auth()?.currentUser?.uid
//            frDBref.child("users/\(changeRequest!)/address/firstLine").setValue(add1!.text)
//            frDBref.child("users/\(changeRequest!)/address/secondLine").setValue(add2!.text)
//            frDBref.child("users/\(changeRequest!)/address/thirdLine").setValue(add3!.text)
//            frDBref.child("users/\(changeRequest!)/address/postcode").setValue(post!.text)
//            frDBref.child("users/\(changeRequest!)/address/city").setValue(siti!.text)
//            frDBref.child("users/\(changeRequest!)/address/state").setValue(state!.text)
//            if add3.text != nil
//            {
//                self.userAddText.text = "\(add1.text!), \(add2.text!), \(add3.text!), \(post.text!) \(siti.text!), \(state.text!)"
//            }
//            else
//            {
//                self.userAddText.text = "\(add1.text!), \(add2.text!), \(post.text!) \(siti.text!), \(state.text!)"
//            }
//        }))
//        present(noti, animated: true, completion: nil)
//    }
    
    //////////////////////////////////////////////////////////////////
    
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
        var oldPassText: UITextField?
        var newPassText: UITextField?
        var conPassText: UITextField?
        let noti = UIAlertController(title: "Change Password", message: "Fill in the fields to change password", preferredStyle: .alert)
        noti.addTextField(configurationHandler: {(old: UITextField!) in
            old.placeholder = "Enter current password"
            old.isSecureTextEntry = true
            oldPassText = old
        })
        noti.addTextField(configurationHandler: {(new: UITextField!) in
            new.placeholder = "Enter a new password"
            new.isSecureTextEntry = true
            newPassText = new
        })
        noti.addTextField(configurationHandler: {(con: UITextField!) in
            con.placeholder = "Confirm your new password"
            con.isSecureTextEntry = true
            conPassText = con
        })
        
        noti.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        noti.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            if newPassText?.text != conPassText?.text
            {
                self.secondAlert(message : "Not match")
                
            }
            else
            {
                let changeRequest = FIRAuth.auth()?.currentUser
                
                let credential = FIREmailPasswordAuthProvider.credential(withEmail: (changeRequest?.email)!, password: (oldPassText?.text)!)
                
                changeRequest?.reauthenticate(with: credential, completion: {(error) in
                    if ((error) != nil)
                    {
                        print(error!)
                        
                    }
                    else
                    {
                        changeRequest?.updatePassword((newPassText?.text)!, completion: {(error) in
                            if error != nil
                            {
                                print(error?.localizedDescription)
                            }
                            else
                            {
                                
                                self.secondAlert(message: "match")
                                
                            }
                            
                        })
                        
                        
                        
                    }
                })
            }
        }))
        
        present(noti, animated: true, completion: nil)
        
    }
    
    func secondAlert(message : String)
    {
        if message == "Not match"
        {
            let alert = UIAlertController(title: "Not match", message: "New Password is not match to confirm password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else if message == "match"
        {
            let alert = UIAlertController(title: "Update Successful", message: "You have successfully update your password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
