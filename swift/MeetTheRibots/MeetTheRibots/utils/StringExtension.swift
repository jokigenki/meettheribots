//
//  StringExtension.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation

extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    subscript (r: Range<Int>) -> String {
        var start = advance(startIndex, r.startIndex)
            var end = advance(startIndex, r.endIndex)
            return substringWithRange(Range(start: start, end: end))
    }
    
    func toHexInts () -> (r: Int, g: Int, b: Int) {
        
        var cString:String = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString[1..<7]
        }
        else if (cString.hasPrefix("0X")) {
            cString = cString[2..<8]
        }
        else {
            cString = cString[0..<6]
        }
        
        var r = cString[0..<2].hexToInt()
        var g = cString[2..<4].hexToInt()
        var b = cString[4..<6].hexToInt()
        
        return (r: r, g: g, b: b)
    }

    func hexToInt () -> Int {
        let s = self.uppercaseString
        var total: Int = 0
        let c = countElements(s)
        for i in 0..<c {
            let m = Double((c - (i + 1)))
            let power = Int(pow(16.0, m))
            let p = advance(s.unicodeScalars.startIndex, i)
            let v = (Int)(s.unicodeScalars[p].value)
            total += String.hexValueForUnicode(v) * power
        }
        
        return total
    }
    
    static func hexValueForUnicode (v: Int) -> Int {
        if v > 47 && v < 58 { return v - 48 } // 0-9
        else if v > 64 && v < 71 { return v - 55 } // A-F
        else { return 0 }
    }
}