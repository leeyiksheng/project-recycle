//
//  DriverViewController.swift
//  Project Recycle
//
//  Created by Students on 11/29/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DriverViewController: UIViewController {
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var driverProImage: UIImageView!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverEmailLabel: UILabel!
    @IBOutlet weak var driverPhoneLabel: UILabel!
    @IBOutlet weak var titleVCLabel: UILabel!
    
    var firebaseDatabase : FIRDatabaseReference?
    var driverArray : [DriverDetails] = []
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        driverProImage.layer.borderWidth = 1
        driverProImage.layer.masksToBounds = false
        driverProImage.layer.borderColor = UIColor.green.cgColor
        driverProImage.layer.cornerRadius = driverProImage.frame.height/2
        driverProImage.clipsToBounds = true
        
    

        
        firebaseDatabase = FIRDatabase.database().reference()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.titleVCLabel.text = "Driver Information"
    }

    private func fetchData()
    {
        firebaseDatabase?.child("drivers").observe(.childAdded, with:{ (snapshot) in
            let newData = DriverDetails()
            guard let dataDictionary = snapshot.value as? [String : AnyObject]
                else
            {
                return
            }
            
            newData.name = dataDictionary["name"] as? String
            self.driverNameLabel.text = newData.name
            newData.phoneNumber = dataDictionary["phoneNumber"] as? String
            self.driverPhoneLabel.text = newData.phoneNumber
            newData.email = dataDictionary["email"] as? String
            self.driverEmailLabel.text = newData.email
            newData.profilePic = (dataDictionary["profileImage"] as! String?)!
            Downloader.getDataFromUrl(url: URL.init(string: newData.profilePic!)!, completion: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.driverProImage.image = UIImage (data: data!)
                }
            })
            
//            if let profileImageUrl = newData.profilePic
//            {
//                let url = NSURL(string: profileImageUrl)
//                URLSession.sharedSession.dataTask(with: url!, completionHandler: { (data, response, error) in
//                
//                    if error != nil
//                    {
//                        print(error)
//                        return
//                    }
//                    
//                    
//                    DispatchQueue.main.async
//                        {
//                        self.driverProImage.image = UIImage (data: data!)
//                    }
//                })
//            }
        })
    }
 
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem)
    {
    }



}
