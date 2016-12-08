//
//  GeneralRecylables.swift
//  Project Recycle
//
//  Created by NEXTAcademy on 12/2/16.
//  Copyright © 2016 Lee Yik Sheng. All rights reserved.
//

import Foundation
import UIKit

struct GeneralRecylables
{
    let category : String
    let synopsis : String
    let materialName: String
    let matImage : UIImage

}

extension UIColor
{
    static func candyGreen() -> UIColor
    {
        return UIColor(red:67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    }
}
