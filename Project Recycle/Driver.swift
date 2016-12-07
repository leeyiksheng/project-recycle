//
//  Driver.swift
//  Project Recycle
//
//  Created by Students on 11/29/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//
import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit
class Driver{
    
    var name: String
    var email: String
    var phoneNumber: String
    var profileImage: String
    var assignedOrderUIDArray: [String]
    var completedOrderUIDArray: [String]
    var driverUID: String
    
    init() {
        name = ""
        email = ""
        phoneNumber = ""
        profileImage = ""
        assignedOrderUIDArray = []
        completedOrderUIDArray = []
        driverUID = ""
    }
    
    convenience init(driverUID: String) {
        self.init()
        
        let driverDatabaseReference = FIRDatabase.database().reference(withPath: "drivers/\(driverUID)")
        
        driverDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let driverRawDataDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.name = driverRawDataDictionary["name"] as! String
            self.email = driverRawDataDictionary["email"] as! String
            self.phoneNumber = driverRawDataDictionary["phoneNumber"] as! String
            self.profileImage = driverRawDataDictionary["profileImage"] as! String  //: MARK - (TBD FEATURE) CONVERT TO URL AND DOWNLOAD THEN ASSIGN AS UIIMAGE
            self.driverUID = driverRawDataDictionary["driverID"] as! String
            
            if driverRawDataDictionary["assignedOrders"] == nil {
                self.assignedOrderUIDArray = []
            } else {
                self.assignedOrderUIDArray = driverRawDataDictionary["assignedOrders"] as! [String]
            }
            
            if driverRawDataDictionary["completedOrders"] == nil {
                self.completedOrderUIDArray = []
            } else {
                self.completedOrderUIDArray = driverRawDataDictionary["completedOrders"] as! [String]
            }
            
        })
    }
}
