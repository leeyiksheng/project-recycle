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
    
    var userUID: String?
    var orderUID: String?
    var addressUID: String?
    
    var receiverFormattedAddress: String?
    var receiverName: String?
    var receiverContact: String?
    
    var hasPaper: Bool?
    var hasPlastic: Bool?
    var hasGlass: Bool?
    var hasAluminium: Bool?
    
    var creationTimestamp: TimeInterval?
    var processedTimestamp: TimeInterval?
    var completionTimestamp: TimeInterval?
    
    var assignedDriver: Driver?
    var orderValue: Double?
    var keywords: String = "" 

    init(orderWithUserUID userUID: String, addressID: String, hasAluminium: Bool, hasGlass: Bool, hasPaper: Bool, hasPlastic: Bool) {
        self.userUID = userUID
        self.addressUID = addressID
        
        self.hasAluminium = hasAluminium
        self.hasGlass = hasGlass
        self.hasPaper = hasPaper
        self.hasPlastic = hasPlastic
        
        fetchAddressDataFromDatabaseWith(addressID: addressID, completion: { () -> () in
            let orderInitializationCompletionNotification = Notification(name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(name: orderInitializationCompletionNotification.name, object: self)
        })
    }

    init(processingOrderWithOrderUID orderUID: String) {
        let orderDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/processing/\(orderUID)")
        
        orderDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawOrderDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Database snapshot is empty, check whether order ID is valid.")
                return
            }
            
            guard let userUID = rawOrderDataDictionary["userID"] as? String else {
                print("Error: UserID in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.userUID = userUID
            self.keywords.append(" " + userUID)
            
            guard let orderUID = rawOrderDataDictionary["orderID"] as? String else {
                print("Error: UserID in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.orderUID = orderUID
            self.keywords.append(" " + orderUID)
            
            if rawOrderDataDictionary["addressID"] as? String != nil {
                self.addressUID = rawOrderDataDictionary["addressID"] as? String
                self.keywords.append(" " + self.addressUID!)
            } else {
                self.addressUID = "No address ID provided."
            }
            
            guard let formattedAddress = rawOrderDataDictionary["formattedAddress"] as? String else {
                print("Error: formattedAddress dictionary in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverFormattedAddress = formattedAddress
            self.keywords.append(" " + formattedAddress)
            
            guard let receiverName = rawOrderDataDictionary["receiverName"] as? String else {
                print("Error: receiverName in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverName = receiverName
            self.keywords.append(" " + receiverName)
            
            guard let receiverContact = rawOrderDataDictionary["receiverContact"] as? String else {
                print("Error: receiverContact in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverContact = receiverContact
            self.keywords.append(" " + receiverContact)

            guard let categoryDictionary = rawOrderDataDictionary["orderCategories"] as? [String: Bool] else {
                print("Error: orderCategories in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }

            if categoryDictionary["aluminium"]! {
                self.hasAluminium = true
                self.keywords.append(" " + "aluminium")
            } else {
                self.hasAluminium = false
            }

            if categoryDictionary["glass"]! {
                self.hasGlass = true
                self.keywords.append(" " + "glass")
            } else {
                self.hasGlass = false
            }

            if categoryDictionary["paper"]! {
                self.hasPaper = true
                self.keywords.append(" " + "paper")
            } else {
                self.hasPaper = false
            }

            if categoryDictionary["plastic"]! {
                self.hasPlastic = true
                self.keywords.append(" " + "plastic")
            } else {
                self.hasPlastic = false
            }

            guard let creationTimestamp = rawOrderDataDictionary["orderCreatedOn"] as? TimeInterval else {
                print("Error: creationTimestamp in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.creationTimestamp = creationTimestamp
            self.keywords.append(" " + self.createFormattedDateWith(timeInterval: self.creationTimestamp!))
            
            if rawOrderDataDictionary["orderProcessedOn"] != nil {
                self.processedTimestamp = rawOrderDataDictionary["orderProcessedOn"] as? TimeInterval
                self.keywords.append(" " + self.createFormattedDateWith(timeInterval: self.processedTimestamp!))
            } else {
                print("Warning: processedTimestamp in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
            }
            
            if rawOrderDataDictionary["orderCompletedOn"] != nil {
                self.completionTimestamp = rawOrderDataDictionary["orderCompletedOn"] as? TimeInterval
                self.keywords.append(" " + self.createFormattedDateWith(timeInterval: self.completionTimestamp!))
            } else {
                print("Warning: completionTimestamp in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
            }
            
            if rawOrderDataDictionary["orderValue"] != nil {
                self.orderValue = rawOrderDataDictionary["orderValue"] as? Double
                self.keywords.append(" " + "\(self.orderValue)")
            } else {
                print("Warning: orderValue in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
            }
            
            if rawOrderDataDictionary["driverAssigned"] != nil {
                let driverUID = rawOrderDataDictionary["driverAssigned"] as! String
                self.assignedDriver = Driver.init(driverUID: driverUID)
                self.keywords.append(" " + "\(self.assignedDriver!.name)")
                let orderInitializationCompletionNotification = Notification(name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil, userInfo: nil)
                NotificationCenter.default.post(orderInitializationCompletionNotification)
            } else {
                print("Warning: driverID in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
                let orderInitializationCompletionNotification = Notification(name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil, userInfo: nil)
                NotificationCenter.default.post(orderInitializationCompletionNotification)
            }
        })
    }
    
    init(processedOrderWithOrderUID orderUID: String) {
        let orderDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/current/\(orderUID)")
        
        orderDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawOrderDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Database snapshot is empty, check whether order ID is valid.")
                return
            }
            
            guard let userUID = rawOrderDataDictionary["userID"] as? String else {
                print("Error: UserID in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.userUID = userUID
            self.keywords.append(" " + userUID)
            
            guard let orderUID = rawOrderDataDictionary["orderID"] as? String else {
                print("Error: UserID in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.orderUID = orderUID
            self.keywords.append(" " + orderUID)
            
            if rawOrderDataDictionary["addressID"] as? String != nil {
                self.addressUID = rawOrderDataDictionary["addressID"] as? String
                self.keywords.append(" " + self.addressUID!)
            } else {
                self.addressUID = "No address ID provided."
            }
            
            guard let formattedAddress = rawOrderDataDictionary["formattedAddress"] as? String else {
                print("Error: formattedAddress dictionary in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverFormattedAddress = formattedAddress
            self.keywords.append(" " + formattedAddress)
            
            guard let receiverName = rawOrderDataDictionary["receiverName"] as? String else {
                print("Error: receiverName in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverName = receiverName
            self.keywords.append(" " + receiverName)
            
            guard let receiverContact = rawOrderDataDictionary["receiverContact"] as? String else {
                print("Error: receiverContact in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverContact = receiverContact
            self.keywords.append(" " + receiverContact)
            
            guard let categoryDictionary = rawOrderDataDictionary["orderCategories"] as? [String: Bool] else {
                print("Error: orderCategories in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            
            if categoryDictionary["aluminium"]! {
                self.hasAluminium = true
                self.keywords.append(" " + "aluminium")
            } else {
                self.hasAluminium = false
            }
            
            if categoryDictionary["glass"]! {
                self.hasGlass = true
                self.keywords.append(" " + "glass")
            } else {
                self.hasGlass = false
            }
            
            if categoryDictionary["paper"]! {
                self.hasPaper = true
                self.keywords.append(" " + "paper")
            } else {
                self.hasPaper = false
            }
            
            if categoryDictionary["plastic"]! {
                self.hasPlastic = true
                self.keywords.append(" " + "plastic")
            } else {
                self.hasPlastic = false
            }
            
            guard let creationTimestamp = rawOrderDataDictionary["orderCreatedOn"] as? TimeInterval else {
                print("Error: creationTimestamp in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.creationTimestamp = creationTimestamp
            self.keywords.append(" " + self.createFormattedDateWith(timeInterval: self.creationTimestamp!))
            
            if rawOrderDataDictionary["orderProcessedOn"] != nil {
                self.processedTimestamp = rawOrderDataDictionary["orderProcessedOn"] as? TimeInterval
                self.keywords.append(" " + self.createFormattedDateWith(timeInterval: self.processedTimestamp!))
            } else {
                print("Warning: processedTimestamp in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
            }
            
            if rawOrderDataDictionary["orderCompletedOn"] != nil {
                self.completionTimestamp = rawOrderDataDictionary["orderCompletedOn"] as? TimeInterval
                self.keywords.append(" " + self.createFormattedDateWith(timeInterval: self.completionTimestamp!))
            } else {
                print("Warning: completionTimestamp in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
            }
            
            if rawOrderDataDictionary["orderValue"] != nil {
                self.orderValue = rawOrderDataDictionary["orderValue"] as? Double
                self.keywords.append(" " + "\(self.orderValue)")
            } else {
                print("Warning: orderValue in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
            }
            
            if rawOrderDataDictionary["driverAssigned"] != nil {
                let driverUID = rawOrderDataDictionary["driverAssigned"] as! String
                self.assignedDriver = Driver.init(driverUID: driverUID)
                self.keywords.append(" " + "\(self.assignedDriver!.name)")
                let orderInitializationCompletionNotification = Notification(name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil, userInfo: nil)
                NotificationCenter.default.post(orderInitializationCompletionNotification)
            } else {
                print("Warning: driverID in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
                let orderInitializationCompletionNotification = Notification(name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil, userInfo: nil)
                NotificationCenter.default.post(orderInitializationCompletionNotification)
            }
        })
    }
    
    init(completedOrderWithOrderUID orderUID: String) {
        let orderDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/completed/\(orderUID)")
        
        orderDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawOrderDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Database snapshot is empty, check whether order ID is valid.")
                return
            }
            
            guard let userUID = rawOrderDataDictionary["userID"] as? String else {
                print("Error: UserID in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.userUID = userUID
            self.keywords.append(" " + userUID)
            
            guard let orderUID = rawOrderDataDictionary["orderID"] as? String else {
                print("Error: UserID in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.orderUID = orderUID
            self.keywords.append(" " + orderUID)
            
            if rawOrderDataDictionary["addressID"] as? String != nil {
                self.addressUID = rawOrderDataDictionary["addressID"] as? String
                self.keywords.append(" " + self.addressUID!)
            } else {
                self.addressUID = "No address ID provided."
            }
            
            guard let formattedAddress = rawOrderDataDictionary["formattedAddress"] as? String else {
                print("Error: formattedAddress dictionary in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverFormattedAddress = formattedAddress
            self.keywords.append(" " + formattedAddress)
            
            guard let receiverName = rawOrderDataDictionary["receiverName"] as? String else {
                print("Error: receiverName in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverName = receiverName
            self.keywords.append(" " + receiverName)
            
            guard let receiverContact = rawOrderDataDictionary["receiverContact"] as? String else {
                print("Error: receiverContact in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverContact = receiverContact
            self.keywords.append(" " + receiverContact)
            
            guard let categoryDictionary = rawOrderDataDictionary["orderCategories"] as? [String: Bool] else {
                print("Error: orderCategories in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            
            if categoryDictionary["aluminium"]! {
                self.hasAluminium = true
                self.keywords.append(" " + "aluminium")
            } else {
                self.hasAluminium = false
            }
            
            if categoryDictionary["glass"]! {
                self.hasGlass = true
                self.keywords.append(" " + "glass")
            } else {
                self.hasGlass = false
            }
            
            if categoryDictionary["paper"]! {
                self.hasPaper = true
                self.keywords.append(" " + "paper")
            } else {
                self.hasPaper = false
            }
            
            if categoryDictionary["plastic"]! {
                self.hasPlastic = true
                self.keywords.append(" " + "plastic")
            } else {
                self.hasPlastic = false
            }
            
            guard let creationTimestamp = rawOrderDataDictionary["orderCreatedOn"] as? TimeInterval else {
                print("Error: creationTimestamp in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.creationTimestamp = creationTimestamp
            self.keywords.append(" " + self.createFormattedDateWith(timeInterval: self.creationTimestamp!))
            
            if rawOrderDataDictionary["orderProcessedOn"] != nil {
                self.processedTimestamp = rawOrderDataDictionary["orderProcessedOn"] as? TimeInterval
                self.keywords.append(" " + self.createFormattedDateWith(timeInterval: self.processedTimestamp!))
            } else {
                print("Warning: processedTimestamp in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
            }
            
            if rawOrderDataDictionary["orderCompletedOn"] != nil {
                self.completionTimestamp = rawOrderDataDictionary["orderCompletedOn"] as? TimeInterval
                self.keywords.append(" " + self.createFormattedDateWith(timeInterval: self.completionTimestamp!))
            } else {
                print("Warning: completionTimestamp in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
            }
            
            if rawOrderDataDictionary["orderValue"] != nil {
                self.orderValue = rawOrderDataDictionary["orderValue"] as? Double
                self.keywords.append(" " + "\(self.orderValue)")
            } else {
                print("Warning: orderValue in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
            }
            
            if rawOrderDataDictionary["driverAssigned"] != nil {
                let driverUID = rawOrderDataDictionary["driverAssigned"] as! String
                self.assignedDriver = Driver.init(driverUID: driverUID)
                self.keywords.append(" " + "\(self.assignedDriver!.name)")
                let orderInitializationCompletionNotification = Notification(name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil, userInfo: nil)
                NotificationCenter.default.post(orderInitializationCompletionNotification)
            } else {
                print("Warning: driverID in database snapshot is nil. If unintentional, please check for download interruption or database corruption.")
                let orderInitializationCompletionNotification = Notification(name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil, userInfo: nil)
                NotificationCenter.default.post(orderInitializationCompletionNotification)
            }
        })
    }
    
    func fetchAddressDataFromDatabaseWith(addressID: String, completion: @escaping () -> ()) {
        let addressDatabaseReference = FIRDatabase.database().reference(withPath: "addresses/\(addressID)")
        
        addressDatabaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let addressDictionary = snapshot.value as? [String: Any] else {
                print("Error: Database snapshot is empty, check whether address ID is valid.")
                return
            }
            
            guard let formattedAddress = addressDictionary["formattedAddress"] as? String else {
                print("Error: formattedAddress in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverFormattedAddress = formattedAddress
            
            guard let receiverName = addressDictionary["receiverName"] as? String else {
                print("Error: receiverName in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverName = receiverName
            
            guard let receiverContact = addressDictionary["receiverContact"] as? String else {
                print("Error: receiverContact in database snapshot is nil, please check for download interruption or database corruption.")
                return
            }
            self.receiverContact = receiverContact
            
            completion()
        })
    }
    
    func observeDriverIntializationCompletionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDriverIntializationCompletionNotification), name: Notification.Name(rawValue: "DriverIntializationCompletionNotification"), object: nil)
    }
    
    @objc func handleDriverIntializationCompletionNotification(_ notification: Notification) {
        let orderInitializationCompletionNotification = Notification(name: Notification.Name(rawValue: "OrderInitializationCompletionNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(orderInitializationCompletionNotification)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "DriverIntializationCompletionNotification"), object: nil)
    }

    func submitOrder() {
        let userDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID!)")
        let orderDatabaseReference = FIRDatabase.database().reference(withPath: "orders/recycle-main/processing")
        
        let orderUID = orderDatabaseReference.childByAutoId().key
        self.orderUID = orderUID

        let order = [
            "addressID" : addressUID!,
            "formattedAddress": receiverFormattedAddress!,
            "orderCategories": [
                "aluminium": hasAluminium!,
                "glass": hasGlass!,
                "paper": hasPaper!,
                "plastic": hasPlastic!
            ],
            "orderCreatedOn": Date.timeIntervalSinceReferenceDate,
            "receiverContact": receiverContact!,
            "receiverName": receiverName!,
            "userID": userUID!,
            "orderID": orderUID
            ] as [String : Any]
            
        let userOrderUIDDatabaseReference = FIRDatabase.database().reference(withPath: "users/\(userUID!)/processingOrders")

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
    
    private func createFormattedDateWith(timeInterval: Double) -> String {
        let dateInTimeInterval = Date.init(timeIntervalSinceReferenceDate: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: dateInTimeInterval)
    }
}
