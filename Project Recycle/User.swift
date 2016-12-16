//
//  User.swift
//  Project Recycle
//
//  Created by Students on 12/1/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//
import Foundation
import FirebaseDatabase
import FirebaseAuth

class User {
    var name : String
    var email : String
    var phoneNumber : String
    var profileImage : String
    var currentOrders: [String]
    var completedOrders: [String]
    var userUID: String
    var defaultFormattedAddress: String
    var addressIDArray: [String]
    
    init() {
        self.name = ""
        self.email = ""
        self.phoneNumber = ""
        self.profileImage = ""
        self.currentOrders = []
        self.completedOrders = []
        self.userUID = ""
        self.addressIDArray = []
        self.defaultFormattedAddress = ""
    }
    
    func initWithCurrentUser(completion: @escaping (() -> ())) {
        guard let user = FIRAuth.auth()?.currentUser else {
            print("User not signed in.")
            return
        }
        
        self.userUID = user.uid
        self.email = user.email!
        
        let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(user.uid)")
        
        userDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let userRawDataDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.name = userRawDataDictionary["name"] as! String
            
            if userRawDataDictionary["phoneNumber"] as? String != nil {
                self.phoneNumber = userRawDataDictionary["phoneNumber"] as! String
            } else {
                self.phoneNumber = "No phone number given."
            }
            
            if userRawDataDictionary["profileImage"] as? String != nil {
                self.profileImage = userRawDataDictionary["profileImage"] as! String //MARK: - (TBD FEATURE) CONVERT STRING TO URL AND DOWNLOAD IMAGE
            } else {
                self.profileImage = "default"
            }
            
            if userRawDataDictionary["currentOrders"] as? [String] != nil {
                self.currentOrders = userRawDataDictionary["currentOrders"] as! [String]
            }
            
            if userRawDataDictionary["completedOrders"] as? [String] != nil {
                self.completedOrders = userRawDataDictionary["completedOrders"] as! [String]
            }
            
            if userRawDataDictionary["addressID"] as? [String] != nil {
                self.addressIDArray = userRawDataDictionary["addressID"] as! [String]
                
                self.fetchAddressFromDatabaseWith(addressID: self.addressIDArray[0], completion: { () -> () in
                    completion()
                })
            } else {
                self.defaultFormattedAddress = "No address given."
            }
        })
    }
    
    func fetchAddressFromDatabaseWith(addressID: String, completion: @escaping () -> ()) {
        let addressDatabaseReference = FIRDatabase.database().reference(withPath: "addresses/\(addressID)")
        
        addressDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let addressDictionary = snapshot.value as! [String: Any]
                self.defaultFormattedAddress = addressDictionary["formattedAddress"] as! String
            } else {
                self.defaultFormattedAddress = "No address given."
                return
            }
            completion()
        })
    }
    
    func initWithUserUID(userUID: String, completion: @escaping (() -> ())) {
        
        self.userUID = userUID
        let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID)")
        
        userDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let userRawDataDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.email = userRawDataDictionary["email"] as! String
            self.name = userRawDataDictionary["name"] as! String
            self.phoneNumber = userRawDataDictionary["phoneNumber"] as! String
            
            if userRawDataDictionary["profileImage"] as? String != nil {
                self.profileImage = (userRawDataDictionary["profileImage"] as! String) //MARK: - (TBD FEATURE) CONVERT STRING TO URL AND DOWNLOAD IMAGE
            }
            
            if userRawDataDictionary["currentOrders"] as? [String] != nil {
                self.currentOrders = userRawDataDictionary["currentOrders"] as! [String]
            }
            
            if userRawDataDictionary["completedOrders"] as? [String] != nil {
                self.completedOrders = userRawDataDictionary["completedOrders"] as! [String]
            }
            
            self.addressIDArray = userRawDataDictionary["address"] as! [String]
            
            completion()
        })
    }
}
