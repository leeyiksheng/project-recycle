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
    var assignedDriver: String // change to driver class
    var estimatedPrice: Double
    var estimatedWeight: Double
    
    override init() {
        super.init()
        self.processedTimestamp = 0
        self.assignedDriver = ""
        self.estimatedPrice = 0.0
        self.estimatedWeight = 0.0
    }
    
    func fetchCurrentOrdersRawData(orderUID: String) {
        let ordersDatabaseRef = FIRDatabase.database().reference(withPath: "orders/recycle-main/current/\(orderUID)")
        ordersDatabaseRef.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawCurrentOrdersDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.addressDictionary = rawCurrentOrdersDictionary["address"] as! [String: String]
            self.formattedAddress = self.addressDictionary["formattedAddress"]!
            
            self.estimatedPrice = rawCurrentOrdersDictionary["estimatedPrice"] as! Double
            self.estimatedWeight = rawCurrentOrdersDictionary["estimatedWeight"] as! Double
            
            self.orderCategories = rawCurrentOrdersDictionary["orderCategories"] as! [String]
            self.creationTimestamp = rawCurrentOrdersDictionary["orderCreatedOn"] as! Int
            
            print("ordersDatabaseRef data fetch for order \(orderUID) completed.")
        })
    }
    
    func fetchCompletedOrdersRawData(orderUID: String) {
        let ordersDatabaseRef = FIRDatabase.database().reference(withPath: "orders/recycle-main/completed/\(orderUID)")
        
        ordersDatabaseRef.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawCompletedOrdersDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.addressDictionary = rawCompletedOrdersDictionary["address"] as! [String: String]
            self.formattedAddress = self.addressDictionary["formattedAddress"]!
            
            self.estimatedPrice =
        })
    }
}
