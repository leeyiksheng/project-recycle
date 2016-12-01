//
//  OrderItem.swift
//  Project Recycle
//
//  Created by Lee Yik Sheng on 01/12/2016.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import Foundation
import UIKit

class OrderItem {
    var orderImages: [UIImage]
    var timestamp: String
    var estimatedPrice: String
    var assignedDriver: DriverDetails
    var isCompleted: Bool
    
    init(orderImages: [UIImage], timestamp: String, estimatedPrice: String, assignedDriver: DriverDetails, isCompleted: Bool) {
        self.orderImages = orderImages
        self.timestamp = timestamp
        self.estimatedPrice = estimatedPrice
        self.assignedDriver = assignedDriver
        self.isCompleted = isCompleted
    }
}
