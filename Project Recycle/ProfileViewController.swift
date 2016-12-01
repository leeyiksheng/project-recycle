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
            newUser.email = userDictionary["email"] as? String
            newUser.phoneNum = userDictionary["phoneNumber"] as? String
            
        })
        
    }
    
    @IBAction func editNameButtPressed(_ sender: UIButton)
    {
    }
  
    @IBAction func editNumberButPressed(_ sender: UIButton)
    {
    }

    @IBAction func editEmailButtPressed(_ sender: UIButton)
    {
    }
    
    @IBAction func editAddButtPressed(_ sender: UIButton)
    {
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
