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
    
    var name : String
    var email : String
    var phoneNumber : String
    var profileImage : String
    
    init() {
        name = ""
        email = ""
        phoneNumber = ""
        profileImage = ""
    }
    
    func initWithDriverUID(driverUID: String) {
        let driverDatabaseReference = FIRDatabase.database().reference(withPath: "drivers/\(driverUID)")
        
        driverDatabaseReference.observe(FIRDataEventType.value, with: { (snapshot) in
            guard let driverRawDataDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            self.name = driverRawDataDictionary["name"] as! String
            self.email = driverRawDataDictionary["email"] as! String
            self.phoneNumber = driverRawDataDictionary["phoneNumber"] as! String
            self.profileImage = driverRawDataDictionary["profileImage"] as! String  //: MARK - (TBD FEATURE) CONVERT TO URL AND DOWNLOAD THEN ASSIGN AS UIIMAGE
        })
    }
}
