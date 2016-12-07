//
//  CategoriesChosen.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 12/6/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import Foundation
class CategoriesChosen {
    var hasPaper: Bool = false
    var hasPlastic: Bool = false
    var hasGlass: Bool = false
    var hasAluminium: Bool = false
    
    convenience init(hasAluminium: Bool, hasGlass: Bool, hasPaper: Bool, hasPlastic: Bool) {
        self.init()
        self.hasAluminium = hasAluminium
        self.hasGlass = hasGlass
        self.hasPaper = hasPaper
        self.hasPlastic = hasPlastic
    }
}
