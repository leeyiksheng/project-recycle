//
//  CompletedOrder.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 02/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class CompletedOrder: Order {
    var assignedDriver: Driver
    var processedTimestamp: TimeInterval
    var completionTimestamp: TimeInterval
    var actualPrice: Double
    var actualWeight: Double
    
    override init() {
        self.assignedDriver = Driver()
        self.processedTimestamp = 0
        self.completionTimestamp = 0
        self.actualPrice = 0.0
        self.actualWeight = 0.0
        
        super.init()
    }
    
    func initWithOrderUID(orderUID: String) {
        let ordersDatabaseRef = FIRDatabase.database().reference(withPath: "orders/recycle-main/completed/\(orderUID)")
        
        ordersDatabaseRef.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawCompletedOrdersDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.customerAddressDictionary = rawCompletedOrdersDictionary["address"] as! [String: String]
            self.customerFormattedAddress = self.customerAddressDictionary["formattedAddress"]!
            
            self.estimatedPrice = rawCompletedOrdersDictionary["estimatedPrice"] as! Double
            self.estimatedWeight = rawCompletedOrdersDictionary["estimatedWeight"] as! Double
            
            self.orderCategories = rawCompletedOrdersDictionary["orderCategories"] as! [String]
            
            self.creationTimestamp = rawCompletedOrdersDictionary["orderCreatedOn"] as! TimeInterval
            self.processedTimestamp = rawCompletedOrdersDictionary["orderProcessedOn"] as! TimeInterval
            self.completionTimestamp = rawCompletedOrdersDictionary["orderCompletedOn"] as! TimeInterval
            
            let driverUID = rawCompletedOrdersDictionary["driverAssigned"] as! String
            self.assignedDriver.initWithDriverUID(driverUID: driverUID)
            
            self.actualWeight = rawCompletedOrdersDictionary["actualWeight"] as! Double
            self.actualPrice = rawCompletedOrdersDictionary["actualPrice"] as! Double
            
            print("ordersDatabaseRef data fetch for order \(orderUID) completed.")
        })
    }
}
