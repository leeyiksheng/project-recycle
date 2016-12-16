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
    @nonobjc static let darkGreen = UIColor(r: 0, g: 100, b: 0)
    
    //theme
    @nonobjc static let forestGreen = UIColor(r: 34, g: 139, b: 34)
    @nonobjc static let limeGreen = UIColor(r: 50, g: 205, b: 50)
    @nonobjc static let paleGreen = UIColor(r: 100, g: 251, b: 100)
    //texts
    @nonobjc static let textDarkGray = UIColor(r: 169, g: 169, b: 169)
    @nonobjc static let textLightGray = UIColor(r: 192, g: 192, b: 192)
    @nonobjc static let viewLightGray = UIColor(r: 245, g: 245, b: 245)
    
}

extension UILabel {
    
    
    func smallTitleFonts() {
        self.font = UIFont(name: "SanFranciscoText-Semibold", size: 14)
        self.textColor = UIColor.textDarkGray
    }
    
    func mediumTitleFonts(){
        self.font = UIFont(name: "SanFranciscoText-Semibold", size: 16)
        self.textColor = UIColor.forestGreen
        
    }
    
    func largeTitleFonts() {
        self.font = UIFont(name: "SanFranciscoText-Semibold", size: 18)
        self.textColor = UIColor.textDarkGray
    }
    
    func toolbarLabelTitle() {
        self.font = UIFont(name: "SanFranciscoText-Semibold", size: 18)
        self.textColor = UIColor.black
    }
    
}

extension UITextField {
    
    func userInputFonts() {
        self.font = UIFont(name: "SanFranciscoText-Semibold", size: 14)
    }
}

extension UITextView {
    func userTypedFonts() {
        self.font = UIFont(name: "SanFranciscoText-Semibold", size: 14)
    }
}

extension UIButton {
    
    func buttonFonts() {
        self.titleLabel?.font = UIFont(name: "SanFranciscoText-Semibold", size: 18)
    }
    
    func smallButtonFonts() {
        self.titleLabel?.font = UIFont(name: "SanFranciscoText-Light", size: 14)
        
    }
}

extension UINavigationController {
    
    func navigationBarAttributes() {
        self.navigationBar.tintColor = UIColor.textLightGray
        self.navigationBar.barTintColor = UIColor.viewLightGray
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.textLightGray]
        self.navigationBar.titleTextAttributes = titleDict as! [String : Any]
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SanFranciscoText-Semibold", size: 18)!]
        
    }
    
}

extension UINavigationItem {
    
    func navigationItemAttributes() {
        self.leftBarButtonItem?.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "SanFranciscoText-Semibold", size: 18)!], for: .normal)
        self.rightBarButtonItem?.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "SanFranciscoText-Semibold", size: 18)!], for: .normal)
    }
}

extension UIBarButtonItem {
    func buttonFonts() {
        self.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "SanFranciscoText-Semibold", size: 18)!], for: .normal)
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

extension CAGradientLayer {
    
    
    func mainPageBackground() {
        let darkGreen = UIColor(r: 0, g: 100, b: 0).cgColor
        let forestGreen = UIColor(r: 34, g: 139, b: 34).cgColor
        let limeGreen = UIColor(r: 50, g: 205, b: 50).cgColor
        let paleGreen = UIColor(r: 100, g: 251, b: 100).cgColor
//        self.locations = [0.0, 0.15, 0.35, 0.6]
        self.startPoint = CGPoint(x: 1, y: 1)
        self.endPoint = CGPoint(x: 0, y: 0)
        self.colors = [darkGreen, forestGreen, limeGreen, paleGreen]
        
        
        
        
    }
    
    
}
