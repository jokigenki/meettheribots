//
//  UIColorExtension.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(_ red: Int, _ green: Int, _ blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init((netHex >> 16) & 0xff, (netHex >> 8) & 0xff, netHex & 0xff)
    }
    
    convenience init(hexString: String) {
       
        let (r, g, b) = hexString.toHexInts()
        self.init(r, g, b)
    }
    
    class func getRandom () ->UIColor {
        let r = Int(rand()) % 255
        let g = Int(rand()) % 255
        let b = Int(rand()) % 255
        return UIColor(r, g, b)
    }
    
    func getDarker (value: CGFloat) ->UIColor {
        
        var colors = CGColorGetComponents( self.CGColor )
        let r = Int(colors[0] * 255 * value)
        let g = Int(colors[1] * 255 * value)
        let b = Int(colors[2] * 255 * value)
        return UIColor (r, g, b)
    }
}