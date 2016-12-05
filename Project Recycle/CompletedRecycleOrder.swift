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

class CompletedRecycleOrder: RecycleOrder {
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

    convenience init(withOrderUID: String, completion: @escaping (() -> ())) {
        self.init()
        
        let ordersDatabaseRef = FIRDatabase.database().reference(withPath: "orders/recycle-main/completed/\(withOrderUID)")
        
        ordersDatabaseRef.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawCompletedOrdersDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.creationTimestamp = rawCompletedOrdersDictionary["orderCreatedOn"] as! TimeInterval
            self.processedTimestamp = rawCompletedOrdersDictionary["orderProcessedOn"] as! TimeInterval
            self.completionTimestamp = rawCompletedOrdersDictionary["orderCompletedOn"] as! TimeInterval
            
            let driverUID = rawCompletedOrdersDictionary["driverAssigned"] as! String
            self.assignedDriver.initWithDriverUID(driverUID: driverUID)
            
            self.actualWeight = rawCompletedOrdersDictionary["actualWeight"] as! Double
            self.actualPrice = rawCompletedOrdersDictionary["actualPrice"] as! Double
            

            print("ordersDatabaseRef data fetch for order \(withOrderUID) completed.")
            completion()
        })
    }
}
