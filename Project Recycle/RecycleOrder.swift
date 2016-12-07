//
//  RecycleOrder.swift
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
    var orderUID: String
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
        self.orderUID = ""
    }
    convenience init(orderWithUserUID userUID: String, hasAluminium: Bool, hasGlass: Bool, hasPaper: Bool, hasPlastic: Bool) {
        self.init()
        let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID)")
        self.userUID = userUID
        self.hasAluminium = hasAluminium
        self.hasGlass = hasGlass
        self.hasPaper = hasPaper
        self.hasPlastic = hasPlastic
        fetchUserDataFromDatabaseWith(databaseReference: userDatabaseReference, completion: { (address, name, contact) in
            self.receiverFormattedAddress = address
            self.receiverName = name
            self.receiverContact = contact
            let fetchingCompletionNotification = Notification(name: Notification.Name(rawValue: "UserDataFetchingCompletion"), object: nil, userInfo: nil)
            NotificationCenter.default.post(fetchingCompletionNotification)
        })
        createOrderImagesWithMainRecycleCategories()
    }
    convenience init(orderWithOrderUID orderUID: String) {
        self.init()
        fetchOrderDataFromDatabaseWith(orderUID: orderUID, completion: { (rawOrderDataDictionary) -> () in
            self.userUID = rawOrderDataDictionary["userID"] as! String
            self.receiverFormattedAddress = rawOrderDataDictionary["formattedAddress"] as! String
            self.receiverName = rawOrderDataDictionary["receiverName"] as! String
            self.receiverContact = rawOrderDataDictionary["receiverContact"] as! String
            
            let categoryDictionary = rawOrderDataDictionary["orderCategories"] as! [String: Bool]
            
            if categoryDictionary["aluminium"]! {
                self.hasAluminium = true
            }
            
            if categoryDictionary["glass"]! {
                self.hasGlass = true
            }
            
            if categoryDictionary["paper"]! {
                self.hasPaper = true
            }
            
            if categoryDictionary["plastic"]! {
                self.hasPlastic = true
            }
            
            self.createOrderImagesWithMainRecycleCategories()
            
            self.creationTimestamp = rawOrderDataDictionary["orderCreatedOn"] as! TimeInterval
        })
    }
    
    func fetchOrderDataFromDatabaseWith(orderUID: String, completion: @escaping (_ rawDataDictionary: [String: AnyObject]) -> ()) {
        let orderDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/processing/\(orderUID)")
        
        orderDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawOrderDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Database snapshot was empty, check whether order ID is valid.")
                return
            }
            
            completion(rawOrderDataDictionary)
        })
    }
    func submitOrder() {
        let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID)")
        let orderDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/processing")
        let orderUID = orderDatabaseReference.childByAutoId().key
        
        self.orderUID = orderUID
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
            "userID": userUID,
            "orderID": orderUID
            ] as [String : Any]
        let userOrderUIDDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID)/processingOrders")
        
        fetchUserOrderUIDsFromDatabaseWith(databaseReference: userOrderUIDDatabaseReference, completion: { (uidArray) in
            var orderUIDArray = uidArray
            orderUIDArray.append(orderUID)
            
            let orderDatabaseUpdate = [orderUID: order]
            let userDatabaseUpdate = ["processingOrders": orderUIDArray]
            orderDatabaseReference.updateChildValues(orderDatabaseUpdate)
            userDatabaseReference.updateChildValues(userDatabaseUpdate)
        })
    }
    
    private func fetchUserOrderUIDsFromDatabaseWith(databaseReference: FIRDatabaseReference, completion: @escaping (_ uidArray: [String]) -> ()) {
        databaseReference.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            guard let orderUIDArray = snapshot.value as? [String] else {
                let orderUIDArray : [String] = []
                completion(orderUIDArray)
                return
            }
            completion(orderUIDArray)
        })
    }
    private func fetchUserDataFromDatabaseWith(databaseReference: FIRDatabaseReference, completion: @escaping (_ address: String,_ name: String,_ contact: String) -> ()) {
        databaseReference.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let userDataDictionary = snapshot.value as! [String: AnyObject]
            let addressDictionary = userDataDictionary["address"] as! [String: AnyObject]
            let formattedAddress = addressDictionary["formattedAddress"] as! String
            let name = userDataDictionary["name"] as! String
            let contact = userDataDictionary["phoneNumber"] as! String
            completion(formattedAddress, name, contact)
        })
    }
    func createOrderImagesWithMainRecycleCategories() {
        if hasAluminium {
            guard let image = UIImage.init(named: "Aluminium") else { return }
            orderImages.append(image)
        }
        if hasGlass {
            guard let image = UIImage.init(named: "Glass") else { return }
            orderImages.append(image)
        }
        if hasPaper {
            guard let image = UIImage.init(named: "Paper") else { return }
            orderImages.append(image)
        }
        if hasPlastic {
            guard let image = UIImage.init(named: "Plastic") else { return }
            orderImages.append(image)
        }
    }
    private func createOrderImagesWithImageArray(imageArray: [UIImage]) {
        // to be done when item categories have been determined
        print("This feature hasn't been implemented yet.")
    }
}
