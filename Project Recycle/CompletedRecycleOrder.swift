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
    var orderValue = 0.0

    override init() {
        self.assignedDriver = Driver()
        self.processedTimestamp = 0
        self.completionTimestamp = 0
        self.orderValue = 0.0

        super.init()
    }

    convenience init(withOrderUID: String) {
        self.init()

        let ordersDatabaseRef = FIRDatabase.database().reference(withPath: "orders/recycle-main/completed/\(withOrderUID)")

        fetchRawCompletedOrderDataFromDatabaseWith(databaseReference: ordersDatabaseRef, completion: { (rawOrderDataDictionary) -> () in
            self.creationTimestamp = rawOrderDataDictionary["orderCreatedOn"] as! TimeInterval
            self.processedTimestamp = rawOrderDataDictionary["orderProcessedOn"] as! TimeInterval
            self.completionTimestamp = rawOrderDataDictionary["orderCompletedOn"] as! TimeInterval

            let driverUID = rawOrderDataDictionary["assignedDriver"] as! String
            self.orderValue = rawOrderDataDictionary["orderValue"] as! Double
            self.assignedDriver = Driver.init(driverUID: driverUID)

            self.receiverName = rawOrderDataDictionary["receiverName"] as! String
            self.receiverContact = rawOrderDataDictionary["receiverContact"] as! String
            self.receiverFormattedAddress = rawOrderDataDictionary["receiverFormattedAddress"] as! String
            
            self.userUID = rawOrderDataDictionary["userID"] as! String
            self.orderUID = rawOrderDataDictionary["orderID"] as! String

            print("ordersDatabaseRef data fetch for order \(withOrderUID) completed.")
        })
    }

    private func fetchRawCompletedOrderDataFromDatabaseWith(databaseReference: FIRDatabaseReference, completion: @escaping (_ dataDictionary: [String: AnyObject]) -> ()) {
        databaseReference.observe(FIRDataEventType.childChanged, with: { (snapshot) in
            guard let rawOrderDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Could not retrieve data from database. Please check whether you are online or the database reference is valid.")
                return
            }
            completion(rawOrderDataDictionary)
        })
    }
}
