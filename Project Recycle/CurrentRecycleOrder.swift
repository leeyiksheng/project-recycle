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
    
    convenience init(withOrderUID: String, completion: @escaping ((_ currentOrder: CurrentRecycleOrder) -> ())) {
        self.init()
        
        let ordersDatabaseRef = FIRDatabase.database().reference(withPath: "orders/recycle-main/current/\(withOrderUID)")
        ordersDatabaseRef.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawCurrentOrdersDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.creationTimestamp = rawCurrentOrdersDictionary["orderCreatedOn"] as! TimeInterval
            self.processedTimestamp = rawCurrentOrdersDictionary["orderProcessedOn"] as! TimeInterval
            
            let driverUID = rawCurrentOrdersDictionary["assignedDriver"] as! String
            self.assignedDriver.initWithDriverUID(driverUID: driverUID)
            
            print("ordersDatabaseRef data fetch for order \(withOrderUID) completed.")
            
            completion(self)
        })
    }
    
    private func fetchRawCurrentOrderDataFromDatabaseWith(databaseReference: FIRDatabaseReference, completion: () -> ()) {
        databaseReference.observe(FIRDataEventType.childChanged, with: { (snapshot) in
            guard let rawOrderDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Could not retrieve data from database. Please check whether you are online or the database reference is valid.")
                return
            }
            
            self.creationTimestamp = rawOrderDataDictionary["orderCreatedOn"] as! TimeInterval
            self.processedTimestamp = rawOrderDataDictionary["orderProcessedOn"] as! TimeInterval
            
            let driverUID = rawOrderDataDictionary["assignedDriver"] as! String
            self.assignedDriver.initWithDriverUID(driverUID: driverUID)
            
            
            
        })
        
        completion()
    }
}
