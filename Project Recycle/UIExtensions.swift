//
//  UIExtensions.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 12/1/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    @nonobjc static let forestGreen = UIColor(r: 34, g: 139, b: 34)
    @nonobjc static let viewLightGray = UIColor(r: 240, g: 240, b: 240)
    
}

extension UIButton {
    
    func buttonAttributes() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 15
    }
    
}

extension UIImageView {
    
    func roundShape() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.contentMode = .scaleAspectFill
        self.backgroundColor = UIColor.forestGreen
    }

    
}

extension UILabel {
    
    func labelAttributes() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.boldSystemFont(ofSize: 16)
        self.textColor = UIColor(r: 169, g: 169, b: 169)
        self.textAlignment = .center
    }
}
