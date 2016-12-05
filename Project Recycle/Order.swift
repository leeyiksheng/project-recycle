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

class Order {
    var creationTimestamp: TimeInterval
    var customerFormattedAddress: String
    var orderImages: [UIImage]
    var customerAddressDictionary: [String: String]
    var orderCategories: [String]
    var estimatedPrice: Double
    var estimatedWeight: Double
    
    init() {
        self.creationTimestamp = 0
        self.customerFormattedAddress = ""
        self.orderImages = []
        self.customerAddressDictionary = ["":""]
        self.orderCategories = []
        self.estimatedPrice = 0.0
        self.estimatedWeight = 0.0
    }
    
    func initWithOrderUIDAndOrderType(orderUID: String, type: String, completion: @escaping (() -> ())) {
        let orderDatabaseReference = FIRDatabase.database().reference(withPath: "orders/\(type)/\(orderUID)")
        
        orderDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let rawOrderDataDictionary = snapshot.value as? [String: AnyObject] else {
                print("Error: Database snapshot was empty, check order UID & type")
                return
            }
            
            self.creationTimestamp = rawOrderDataDictionary["orderCreatedOn"] as! TimeInterval
            self.customerFormattedAddress = rawOrderDataDictionary["address"]?["formattedAddress"] as! String
            
            //MARK: - (TBD FEATURE) CONVERT TO URL & DOWNLOAD
            self.orderImages = []
            
            self.customerAddressDictionary = rawOrderDataDictionary["address"] as! [String: String]
            self.orderCategories = rawOrderDataDictionary["orderCategories"] as! [String]
            self.estimatedPrice = rawOrderDataDictionary["estimatedPrice"] as! Double
            self.estimatedWeight = rawOrderDataDictionary["estimatedWeight"] as! Double
            
            completion()
        })
    }
    
    func setCreationTimestampToCurrentTime() {
        self.creationTimestamp = Date.timeIntervalSinceReferenceDate
    }
    
    func createOrderImagesWithMainRecycleCategories() {
        for category: String in orderCategories {
            switch category {
                case "paper":
                    guard let image = UIImage.init(named: "recycle-paper") else { return }
                    orderImages.append(image)
                case "plastic":
                    guard let image = UIImage.init(named: "recycle-plastic") else { return }
                    orderImages.append(image)
                case "aluminium":
                    guard let image = UIImage.init(named: "recycle-aluminium") else { return }
                    orderImages.append(image)
                case "glass":
                    guard let image = UIImage.init(named: "recycle-glass") else { return }
                    orderImages.append(image)
            default:
                    print("Error: Category not found.")
                    return
            }
        }
    }
    
    func createOrderImagesWithImageArray(imageArray: [UIImage]) {
        // to be done when item categories have been determined
        print("This feature hasn't been implemented yet.")
    }
}
