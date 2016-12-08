//
//  CurrentOrder.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 02/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class CurrentRecycleOrder: RecycleOrder {
    
    var processedTimestamp: TimeInterval
    var assignedDriver: Driver
    
    override init() {
        self.processedTimestamp = 0
        self.assignedDriver = Driver()
        super.init()
    }
    
    convenience init(currentOrderWithOrderUID orderUID: String) {
        self.init()
        
        let ordersDatabaseRef = FIRDatabase.database().reference(withPath: "orders/recycle-main/current/\(orderUID)")
        
        fetchRawCurrentOrderDataFromDatabaseWith(databaseReference: ordersDatabaseRef, completion: { (rawOrderDataDictionary) -> () in
            self.creationTimestamp = rawOrderDataDictionary["orderCreatedOn"] as! TimeInterval
            self.processedTimestamp = rawOrderDataDictionary["orderProcessedOn"] as! TimeInterval
            
            let driverUID = rawOrderDataDictionary["assignedDriver"] as! String
            self.assignedDriver = Driver.init(driverUID: driverUID)
            
            let orderCategories = rawOrderDataDictionary["orderCategories"] as! [String: Bool]
            self.populateRecycleMaterialsBooleanChecks(categories: orderCategories)
            
            self.createOrderImagesWithMainRecycleCategories()
            
            self.receiverName = rawOrderDataDictionary["receiverName"] as! String
            self.receiverContact = rawOrderDataDictionary["receiverContact"] as! String
            self.receiverFormattedAddress = rawOrderDataDictionary["receiverFormattedAddress"] as! String
            
            self.orderUID = rawOrderDataDictionary["orderID"] as! String
            
            self.userUID = rawOrderDataDictionary["userID"] as! String
            
            let dataFetchCompletionNotification = Notification(name: Notification.Name(rawValue: "DataFetchCompletionNotification"), object: nil, userInfo: nil)
            NotificationCenter.default.post(dataFetchCompletionNotification)
        })
    }
    
    private func fetchRawCurrentOrderDataFromDatabaseWith(databaseReference: FIRDatabaseReference, completion: @escaping (_ dataDictionary: [String: AnyObject]) -> ()) {
        databaseReference.observe(FIRDataEventType.childChanged, with: { (snapshot) in
            guard let rawOrderDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Could not retrieve data from database. Please check whether you are online or the database reference is valid.")
                return
            }
            completion(rawOrderDataDictionary)
        })
    }
    
    private func populateRecycleMaterialsBooleanChecks(categories: [String: Bool]) {
        if categories["hasAluminium"]! {
            hasAluminium = true
        }
        
        if categories["hasGlass"]! {
            hasGlass = true
        }
        
        if categories["hasPaper"]! {
            hasPaper = true
        }
        
        if categories["hasPlastic"]! {
            hasPlastic = true
        }
    }
}
