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
    @IBOutlet weak var userProImage: UIImageView!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var userNumberText: UITextField!
    @IBOutlet weak var userEmailText: UITextField!
    @IBOutlet weak var userAddText: UITextView!
    
    var personalDetails: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        userProImage.layer.borderWidth = 5
        userProImage.layer.masksToBounds = false
        userProImage.layer.borderColor = UIColor.red.cgColor
        userProImage.layer.cornerRadius = userProImage.frame.height/2
        userProImage.clipsToBounds = true
        
        frDBref = FIRDatabase.database().reference()
        fetchUserInfo()
    }
    
    private func fetchUserInfo()
    {
        let user = FIRAuth.auth()?.currentUser?.email
        frDBref.child("users").observe(.childAdded, with: {(snapshot) in
            let newUser = User()
            
            guard let userDictionary = snapshot.value as? [String : AnyObject]
            else
            {
                return
            }
            
            if (userDictionary["email"] as? String) != user
            {
                return
            }
            
            newUser.name = userDictionary["name"] as? String
            self.userNameText.text = newUser.name
            newUser.email = userDictionary["email"] as? String
            self.userEmailText.text = newUser.email
            newUser.phoneNum = userDictionary["phoneNumber"] as? String
            self.userNumberText.text = newUser.phoneNum
            
            let addr = userDictionary["address"] as! NSDictionary
            newUser.firstAdd = addr["firstLine"] as? String
            newUser.secondAdd = addr["secondLine"] as? String
            newUser.thirdAdd = addr["thirdLine"] as? String
            newUser.postcode = addr["postcode"] as? String
            newUser.city = addr["city"] as? String
            newUser.state = addr["state"] as? String
            self.userAddText.text = "\(newUser.firstAdd!), \(newUser.secondAdd!), \(newUser.thirdAdd!), \(newUser.postcode!) \(newUser.city!), \(newUser.state!)"
            
            newUser.proImage = userDictionary["profileImage"] as? String
            Downloader.getDataFromUrl(url: URL.init(string: newUser.proImage!)!, completion: { (data, response, error) in
                if error != nil
                {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.userProImage.image = UIImage (data: data!)
                }
            })
        })
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
    }
    
    @IBAction func editAddButtPressed(_ sender: UIButton)
    {
        var add1: UITextField?
        var add2: UITextField?
        var add3: UITextField?
        var post: UITextField?
        var siti: UITextField?
        var state: UITextField?
        
        let noti = UIAlertController(title: "Change Address", message: "Please enter your address", preferredStyle: .alert)
        noti.addTextField(configurationHandler: {(line1: UITextField!) in
            line1.placeholder = "First Line Address"
            add1 = line1
        })
        noti.addTextField(configurationHandler: {(line2: UITextField!) in
            line2.placeholder = "Second Line Address"
            add2 = line2
        })
        noti.addTextField(configurationHandler: {(line3: UITextField!) in
            line3.placeholder = "Third Line Address"
            add3 = line3
        })
        noti.addTextField(configurationHandler: {(code: UITextField!) in
            code.placeholder = "Postcode"
            post = code
        })
        noti.addTextField(configurationHandler: {(town: UITextField!) in
            town.placeholder = "City"
            siti = town
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
            self.userAddText.text = "\(add1!.text), \(add2!.text), \(add3!.text), \(post!.text) \(siti!.text), \(state!.text)"
            
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
    }
}
