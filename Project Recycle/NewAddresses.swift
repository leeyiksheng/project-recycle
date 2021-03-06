//
//  NewAddresses.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 12/7/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class NewAddresses {
    
    var formattedAddress = ""
    var contact = ""
    var name = ""
    var userUID = ""
    var addressID = ""
    var noAddressString = false
    
    init() {
        formattedAddress = ""
        contact = ""
        name = ""
        userUID = ""
        addressID = ""
        noAddressString = false
    }
    
    convenience init(UID: (String), address: (String), receiverName: (String), receiverContact: (String)) {
        self.init()
        formattedAddress = address
        contact = receiverContact
        name = receiverName
        userUID = UID
    }
    
    init(withAddressID addressID: String) {
        let addressDatabaseReference = FIRDatabase.database().reference(withPath: "addresses/\(addressID)")
        addressDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value != nil {
                let addressDictionary = snapshot.value as! [String: String]
                
                if addressDictionary["formattedAddress"] != nil {
                    self.formattedAddress = addressDictionary["formattedAddress"]!
                } else {
                    print("Error: formattedAddress is nil.")
                    return
                }
                
                if addressDictionary["receiverContact"] != nil {
                    self.contact = addressDictionary["receiverContact"]!
                } else {
                    print("Error: receiverContact is nil.")
                    return
                }
                
                if addressDictionary["receiverName"] != nil {
                    self.name = addressDictionary["receiverName"]!
                } else {
                    print("Error: receiverName is nil.")
                    return
                }
                
                if addressDictionary["userID"] != nil {
                    self.userUID = addressDictionary["userID"]!
                } else {
                    print("Error: userID is nil.")
                    return
                }
                
                if addressDictionary["addressID"] != nil {
                    self.addressID = addressDictionary["addressID"]!
                } else {
                    print("Error: addressID is nil.")
                    return
                }
                
                let addressInitializationCompletionNotification = Notification(name: Notification.Name(rawValue: "addressInitializationCompletionNotification"))
                NotificationCenter.default.post(addressInitializationCompletionNotification)
            } else {
                print("Error: Address snapshot for \(addressID) is nil.")
                return
            }
        })
    }
    
    
    func deleteAddress() {
        let addressDatabaseReference = FIRDatabase.database().reference().child("addresses").child(self.addressID)
        let userDatabaseReference = FIRDatabase.database().reference().child("users").child(self.userUID)
        let userDatabaseReferenceID = FIRDatabase.database().reference().child("users").child(self.userUID).child("addressID")
        
       addressDatabaseReference.removeValue()
        
        fetchUserAddressUIDsFromDatabaseWith(databaseReference: userDatabaseReferenceID, completion: {(uidArray) in
            let deletedUidAddressesArray = uidArray.filter { $0 != self.addressID }
            
            if deletedUidAddressesArray.count == 0 {
                self.noAddressString = true
            } else {
                self.noAddressString = false
            }
            
            let userDatabaseUpdate = ["addressID": deletedUidAddressesArray]
            userDatabaseReference.updateChildValues(userDatabaseUpdate)
        })
    }
    
    func submitAddress() {
        let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(self.userUID)")
        let addressDatabaseReference = FIRDatabase.database().reference(withPath: "addresses")
        let addressUID = addressDatabaseReference.childByAutoId().key
        let address = [
            "formattedAddress": self.formattedAddress,
            "receiverContact": self.contact,
            "receiverName": self.name,
            "userID": userUID,
            "addressID": addressUID
            ] as [String : Any]
        let userAddressUIDDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID)/addressID")
        
        fetchUserAddressUIDsFromDatabaseWith(databaseReference: userAddressUIDDatabaseReference, completion: { (uidArray) in
            var addressUIDArray = uidArray
            addressUIDArray.append(addressUID)
            
            let addressDatabaseUpdate = [addressUID: address]
            let userDatabaseUpdate = ["addressID": addressUIDArray]
            addressDatabaseReference.updateChildValues(addressDatabaseUpdate)
            userDatabaseReference.updateChildValues(userDatabaseUpdate)
        })
    }
    
    private func fetchUserAddressUIDsFromDatabaseWith(databaseReference: FIRDatabaseReference, completion: @escaping (_ uidArray: [String]) -> ()) {
        databaseReference.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            guard let addressUIDArray = snapshot.value as? [String] else {
                let addressUIDArray : [String] = []
                completion(addressUIDArray)
                return
            }
            completion(addressUIDArray)
        })
    }
    

    
    
    
}
