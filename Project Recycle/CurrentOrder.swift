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

class CurrentOrder: Order {
    
    var processedTimestamp: Int
    var assignedDriver: Driver
    
    override init() {
        self.processedTimestamp = 0
        self.assignedDriver = Driver()
        super.init()
    }
    
    func initWithOrderUID(orderUID: String, completion: @escaping (() -> ())) {
        let ordersDatabaseRef = FIRDatabase.database().reference(withPath: "orders/recycle-main/current/\(orderUID)")
        ordersDatabaseRef.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawCurrentOrdersDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.customerAddressDictionary = rawCurrentOrdersDictionary["address"] as! [String: String]
            self.customerFormattedAddress = self.customerAddressDictionary["formattedAddress"]!
            
            self.estimatedPrice = rawCurrentOrdersDictionary["estimatedPrice"] as! Double
            self.estimatedWeight = rawCurrentOrdersDictionary["estimatedWeight"] as! Double
            
            self.orderCategories = rawCurrentOrdersDictionary["orderCategories"] as! [String]
            self.creationTimestamp = rawCurrentOrdersDictionary["orderCreatedOn"] as! TimeInterval
            
            let driverUID = rawCurrentOrdersDictionary["assignedDriver"] as! String
            self.assignedDriver.initWithDriverUID(driverUID: driverUID)
            
            print("ordersDatabaseRef data fetch for order \(orderUID) completed.")
            
            completion()
        })
    }
}
