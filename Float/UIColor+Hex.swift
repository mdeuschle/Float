//
//  UIColor+Hex.swift
//  Float
//
//  Created by Matt Deuschle on 1/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func colorWithRGBHex(hex24: UInt) -> UIColor {
        return UIColor(
            red:    (CGFloat)((hex24 & 0xFF0000) >> 16) / 255.0,
            green:  (CGFloat)((hex24 & 0x00FF00) >> 8) / 255.0,
            blue:   (CGFloat)((hex24 & 0x0000FF) >> 0) / 255.0,
            alpha:  1.0)
    }

    class func darkPrimaryColor() -> UIColor {
        return colorWithRGBHex(hex24: 0x455A64)
    }
    class func primaryColor() -> UIColor {
        return colorWithRGBHex(hex24: 0x607D8B)
    }
    class func lightPrimaryColor() -> UIColor {
        return colorWithRGBHex(hex24: 0xCFD8DB)
    }
    class func accentColor() -> UIColor {
        return colorWithRGBHex(hex24: 0x54BDD5)
    }
    class func pimaryTextColor() -> UIColor {
        return colorWithRGBHex(hex24: 0x212121)
    }
    class func secondaryTextColor() -> UIColor {
        return colorWithRGBHex(hex24: 0x757575)
    }
    class func dividerColor() -> UIColor {
        return colorWithRGBHex(hex24: 0xBDBDBD)
    }
}


