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

    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

    @IBAction func changePassButtPressed(_ sender: UIButton)
    {
    }
}
