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
    var creationTimestamp: Int
    var userID: String
    var orderImages: [UIImage]
    var addressDictionary: [String: String]
    var orderCategories: [String]
    var formattedAddress: String
    
    init() {
        self.creationTimestamp = 0
        self.userID = ""
        self.orderImages = []
        self.addressDictionary = ["":""]
        self.orderCategories = []
        self.formattedAddress = ""
    }
}
