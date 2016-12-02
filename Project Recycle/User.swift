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
    
    var firstAddressLine : String
    var secondAddressLine : String
    var thirdAddressLine : String
    var postcode : String
    var city : String
    var state : String
    var formattedAddress: String
    
    init() {
        self.name = ""
        self.email = ""
        self.phoneNumber = ""
        self.profileImage = ""
        self.currentOrders = []
        self.completedOrders = []
        self.userUID = ""
        
        self.firstAddressLine = ""
        self.secondAddressLine = ""
        self.thirdAddressLine = ""
        self.postcode = ""
        self.city = ""
        self.state = ""
        self.formattedAddress = ""
    }
    
    func initWithCurrentUser() {
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
            self.phoneNumber = userRawDataDictionary["phoneNumber"] as! String
            self.profileImage = userRawDataDictionary["profileImage"] as! String //MARK: - (TBD FEATURE) CONVERT STRING TO URL AND DOWNLOAD IMAGE
            self.currentOrders = userRawDataDictionary["currentOrders"] as! [String]
            self.completedOrders = userRawDataDictionary["completedOrders"] as! [String]
            
            let addressDictionary = userRawDataDictionary["address"] as! [String: String]
            self.firstAddressLine = addressDictionary["firstLine"]!
            
            if addressDictionary["secondLine"] != nil {
                self.secondAddressLine = addressDictionary["secondLine"]!
            }
            
            if addressDictionary["thirdLine"] != nil {
                self.thirdAddressLine = addressDictionary["thirdLine"]!
            }
            
            self.postcode = addressDictionary["postcode"]!
            self.city = addressDictionary["city"]!
            self.state = addressDictionary["state"]!
            self.formattedAddress = addressDictionary["formattedAddress"]!
        })
    }
    
    func initWithUserUID(userUID: String) {
        
        self.userUID = userUID
        let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID)")
        
        userDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let userRawDataDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.email = userRawDataDictionary["email"] as! String
            self.name = userRawDataDictionary["name"] as! String
            self.phoneNumber = userRawDataDictionary["phoneNumber"] as! String
            self.profileImage = userRawDataDictionary["profileImage"] as! String //MARK: - (TBD FEATURE) CONVERT STRING TO URL AND DOWNLOAD IMAGE
            self.currentOrders = userRawDataDictionary["currentOrders"] as! [String]
            self.completedOrders = userRawDataDictionary["completedOrders"] as! [String]
            
            let addressDictionary = userRawDataDictionary["address"] as! [String: String]
            self.firstAddressLine = addressDictionary["firstLine"]!
            
            if addressDictionary["secondLine"] != nil {
                self.secondAddressLine = addressDictionary["secondLine"]!
            }
            
            if addressDictionary["thirdLine"] != nil {
                self.thirdAddressLine = addressDictionary["thirdLine"]!
            }
            
            self.postcode = addressDictionary["postcode"]!
            self.city = addressDictionary["city"]!
            self.state = addressDictionary["state"]!
            self.formattedAddress = addressDictionary["formattedAddress"]!
        })
    }
}
