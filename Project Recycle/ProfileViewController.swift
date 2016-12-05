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

class ProfileViewController: UIViewController {
    @IBOutlet weak var userProImage: UIImageView?
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var userNumberText: UITextField!
    @IBOutlet weak var userEmailText: UITextField!
    @IBOutlet weak var userAddText: UITextView!

    var personalDetails: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProImage?.layer.borderWidth = 5
        userProImage?.layer.masksToBounds = false
        userProImage?.layer.borderColor = UIColor.white.cgColor
        userProImage?.layer.cornerRadius = (userProImage?.frame.height)!/2
        userProImage?.clipsToBounds = true
        userProImage?.isUserInteractionEnabled = true
        
        frDBref = FIRDatabase.database().reference()
        
        fetchUserInfo()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        userProImage?.addGestureRecognizer(tap)
        
    }
    
    func imageTapped(sender: UIGestureRecognizer)
    {
        if let imagePressed = sender.view as? UIImageView
        {
            self.performSegue(withIdentifier: "imageSegue", sender: self)
        }
    }

    private func fetchUserInfo()
    {

        let newUser = User()
        newUser.initWithCurrentUser { () -> () in
            self.userNameText.text = newUser.name
            self.userEmailText.text = newUser.email
            self.userNumberText.text = newUser.phoneNumber
            self.userAddText.text = "\(newUser.firstAddressLine), \(newUser.secondAddressLine), \(newUser.thirdAddressLine), \(newUser.postcode) \(newUser.city), \(newUser.state)"
        
            if newUser.profileImage == ""
            {
                
                self.userProImage?.image = UIImage(named: "noone")
            }
            else
            {
            Downloader.getDataFromUrl(url: URL.init(string: newUser.profileImage)!, completion: { (data, response, error) in
               
                self.userProImage?.layer.borderColor = UIColor.red.cgColor
                if error != nil
                {
                    print(error!)
                    return
                }
                
                
                DispatchQueue.main.async {
                    self.userProImage?.image = UIImage (data: data!)
                }
            })
            }
        }
    }


    @IBAction func editNameButtPressed(_ sender: UIButton)
    {
        var inputChangesText: UITextField?
        let noti = UIAlertController(title: "Change Name", message: "Please enter your new name.", preferredStyle: .alert)
        noti.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "New Name"
            inputChangesText = textField
        })
        noti.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        noti.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            let changeRequest = FIRAuth.auth()?.currentUser?.uid
            frDBref.child("users/\(changeRequest!)/name").setValue(inputChangesText!.text)
            self.userNameText.text = inputChangesText?.text
        }))
        present(noti, animated: true, completion: nil)

    }

    @IBAction func editNumberButPressed(_ sender: UIButton)
    {
        var inputChangesText: UITextField?
        let noti = UIAlertController(title: "Change Phone Number", message: "Please enter your phone number.", preferredStyle: .alert)
        noti.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "New Number"
            inputChangesText = textField
        })
        noti.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        noti.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            let changeRequest = FIRAuth.auth()?.currentUser?.uid
            frDBref.child("users/\(changeRequest!)/phoneNumber").setValue(inputChangesText!.text)
            self.userNumberText.text = inputChangesText?.text
        }))
        present(noti, animated: true, completion: nil)


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
            changeRequest?.updateEmail((emailText?.text)!){(error) in
                if let error = error{
                    print(error.localizedDescription)
                }
                else
                {
                    let credential = FIREmailPasswordAuthProvider.credential(withEmail: (emailText?.text)!, password: (passText?.text)!)
                    changeRequest?.reauthenticate(with: credential, completion: {(error) in
                        if (error != nil)
                        {
                            print(error?.localizedDescription)
                        }
                        else
                        {
                            let alertController = UIAlertController(title: "Update Email", message: "You have successfully updated your email", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK, Thanks", style: UIAlertActionStyle.default, handler: nil))
                        }
                    })

                }


            }
            frDBref.child("users/\((changeRequest?.uid)!)/email").setValue(emailText!.text)
            self.userEmailText.text = emailText?.text
        }))
        present(noti,animated: true, completion:  nil)
    }

    @IBAction func editAddButtPressed(_ sender: UIButton)
    {
        var add1: UITextField!
        var add2: UITextField!
        var add3: UITextField!
        var post: UITextField!
        var siti: UITextField!
        var state: UITextField!

        let noti = UIAlertController(title: "Change Address", message: "Please enter your address", preferredStyle: .alert)
        noti.addTextField(configurationHandler: {(line1: UITextField!) in
            line1.placeholder = "First Line Address"
            add1 = line1!
        })
        noti.addTextField(configurationHandler: {(line2: UITextField!) in
            line2.placeholder = "Second Line Address"
            add2 = line2!
        })
        noti.addTextField(configurationHandler: {(line3: UITextField!) in
            line3.placeholder = "Third Line Address"
            add3 = line3!
        })
        noti.addTextField(configurationHandler: {(code: UITextField!) in
            code.placeholder = "Postcode"
            post = code!
        })
        noti.addTextField(configurationHandler: {(town: UITextField!) in
            town.placeholder = "City"
            siti = town!
        })
        noti.addTextField(configurationHandler: {(district: UITextField!) in
            district.placeholder = "State"
            state = district!
        })
        noti.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        noti.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            let changeRequest = FIRAuth.auth()?.currentUser?.uid
            frDBref.child("users/\(changeRequest!)/address/firstLine").setValue(add1!.text)
            frDBref.child("users/\(changeRequest!)/address/secondLine").setValue(add2!.text)
            frDBref.child("users/\(changeRequest!)/address/thirdLine").setValue(add3!.text)
            frDBref.child("users/\(changeRequest!)/address/postcode").setValue(post!.text)
            frDBref.child("users/\(changeRequest!)/address/city").setValue(siti!.text)
            frDBref.child("users/\(changeRequest!)/address/state").setValue(state!.text)
            if add3.text != nil
            {
                self.userAddText.text = "\(add1.text!), \(add2.text!), \(add3.text!), \(post.text!) \(siti.text!), \(state.text!)"
            }
            else
            {
                self.userAddText.text = "\(add1.text!), \(add2.text!), \(post.text!) \(siti.text!), \(state.text!)"
            }
        }))
        present(noti, animated: true, completion: nil)
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
            changeRequest?.updatePassword((newPassText?.text)!, completion: {(error) in
                if error != nil
                {
                    print(error?.localizedDescription)
                }
                else
                {
                    let credential = FIREmailPasswordAuthProvider.credential(withEmail: (changeRequest?.email)!, password: (oldPassText?.text)!)
                    changeRequest?.reauthenticate(with: credential, completion: {(error) in
                        if ((error) != nil)
                        {
                            print(error!)

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
