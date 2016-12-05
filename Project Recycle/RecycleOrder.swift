//
//  Order.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 01/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class RecycleOrder {
    var creationTimestamp: TimeInterval
    var receiverFormattedAddress: String
    var orderImages: [UIImage]
    var hasPaper: Bool
    var hasPlastic: Bool
    var hasGlass: Bool
    var hasAluminium: Bool
    var receiverName: String
    var receiverContact: String
    var userUID: String
    
    init() {
        self.creationTimestamp = 0
        self.receiverFormattedAddress = ""
        self.orderImages = []
        self.hasAluminium = false
        self.hasPlastic = false
        self.hasPaper = false
        self.hasGlass = false
        self.receiverName = ""
        self.receiverContact = ""
        self.userUID = ""
    }
    
    convenience init(orderWithUserUID userUID: String, hasAluminium: Bool, hasGlass: Bool, hasPaper: Bool, hasPlastic: Bool) {
        self.init()
        
        let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID)")
        
        self.userUID = userUID
        self.hasAluminium = hasAluminium
        self.hasGlass = hasGlass
        self.hasPaper = hasPaper
        self.hasPlastic = hasPlastic
        
        fetchUserAddressFromDatabaseWith(databaseReference: userDatabaseReference, completion: { (address) in
            receiverFormattedAddress = address
        })
        fetchUserContactFromDatabaseWith(databaseReference: userDatabaseReference, completion: { (contact) in
            receiverContact = contact
        })
        fetchUserNameFromDatabaseWith(databaseReference: userDatabaseReference, completion: { (name) in
            receiverName = name
        })
        
        createOrderImagesWithMainRecycleCategories()
    }
    
    convenience init(orderWithOrderUID orderUID: String, type: String, completion: @escaping (() -> ())) {
        self.init()
        
        let orderDatabaseReference = FIRDatabase.database().reference(withPath: "orders/\(type)/\(orderUID)")
        
        orderDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawOrderDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Database snapshot was empty, check order UID & type")
                return
            }
            
            self.creationTimestamp = rawOrderDataDictionary["orderCreatedOn"] as! TimeInterval
            
            //MARK: - (TBD FEATURE) CONVERT TO URL & DOWNLOAD
            self.orderImages = []
            
            completion()
        })
    }
    
    func submitOrderWithDefaults() {
        let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID)")
        let orderDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/processing")
        let orderUID = orderDatabaseReference.childByAutoId().key
        
        let order = [
            "formattedAddress": receiverFormattedAddress,
            "orderCategories": [
                "aluminium": hasAluminium,
                "glass": hasGlass,
                "paper": hasPaper,
                "plastic": hasPlastic
            ],
            "orderCreatedOn": Date.timeIntervalSinceReferenceDate,
            "receiverContact": receiverContact,
            "receiverName": receiverName,
            "userID": userUID
            ] as [String : Any]
        
        let orderDatabaseUpdate = [orderUID: order]
        let userDatabaseUpdate = ["processingOrders": orderUID]
        
        orderDatabaseReference.updateChildValues(orderDatabaseUpdate)
        userDatabaseReference.updateChildValues(userDatabaseUpdate)
    }
    
    func submitOrderWithCustomOptions(customAddress: String, customContact: String, customName: String) {
        let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID)")
        let orderDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/processing")
        let orderUID = orderDatabaseReference.childByAutoId().key
        
        receiverFormattedAddress = customAddress
        receiverName = customName
        receiverContact = customContact
        
        let order = [
            "formattedAddress": receiverFormattedAddress,
            "orderCategories": [
                "aluminium": hasAluminium,
                "glass": hasGlass,
                "paper": hasPaper,
                "plastic": hasPlastic
            ],
            "orderCreatedOn": Date.timeIntervalSinceReferenceDate,
            "receiverContact": receiverContact,
            "receiverName": receiverName,
            "userID": userUID
            ] as [String : Any]
        
        let orderDatabaseUpdate = [orderUID: order]
        let userDatabaseUpdate = ["processingOrders": orderUID]
        
        orderDatabaseReference.updateChildValues(orderDatabaseUpdate)
        userDatabaseReference.updateChildValues(userDatabaseUpdate)
    }
    
    private func fetchUserAddressFromDatabaseWith(databaseReference: FIRDatabaseReference, completion: (_ address: String) -> ()) {
        guard let userAddress = databaseReference.child("address").value(forKey: "formattedAddress") as? String else {
            print("Error: User address not found on database. Please check whether you are online or the user UID is valid.")
            return
        }
        completion(userAddress)
    }
    
    private func fetchUserContactFromDatabaseWith(databaseReference: FIRDatabaseReference, completion: (_ address: String) -> ()) {
        guard let userContact = databaseReference.value(forKey: "phoneNumber") as? String else {
            print("Error: User contact not found on database. Please check whether you are online or the user UID is valid.")
            return
        }
        completion(userContact)
    }
    
    private func fetchUserNameFromDatabaseWith(databaseReference: FIRDatabaseReference, completion: (_ address: String) -> ()) {
        guard let userName = databaseReference.value(forKey: "name") as? String else {
            print("Error: User name not found on database. Please check whether you are online or the user UID is valid.")
            return
        }
        completion(userName)
    }
    
    func createOrderImagesWithMainRecycleCategories() {
        if hasAluminium {
            guard let image = UIImage.init(named: "recycle-aluminium") else { return }
            orderImages.append(image)
        }
        
        if hasGlass {
            guard let image = UIImage.init(named: "recycle-glass") else { return }
            orderImages.append(image)
        }
        
        if hasPaper {
            guard let image = UIImage.init(named: "recycle-paper") else { return }
            orderImages.append(image)
        }
        
        if hasPlastic {
            guard let image = UIImage.init(named: "recycle-plastic") else { return }
            orderImages.append(image)
        }
    }
    
    private func createOrderImagesWithImageArray(imageArray: [UIImage]) {
        // to be done when item categories have been determined
        print("This feature hasn't been implemented yet.")
    }
}
