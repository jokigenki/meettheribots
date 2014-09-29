//
//  StringExtensionTests.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 29/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import XCTest

class StringExtensionTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCanGetCharacterUsingSubscript () {
        let s = "0123abcd"
        let c1 = s[0]
        let c2 = s[4]
        XCTAssertEqual("0", c1, "value was \(c1) not 0")
        XCTAssertEqual("a", c2, "value was \(c2) not a")
    }
    
    func testUnicode () {
        var s = "0123456789ABCDEF"
        
        let c = countElements(s)
        for i in 0..<c {
            let p = advance(s.unicodeScalars.startIndex, i)
            let v = (Int)(s.unicodeScalars[p].value)
            println(v)
        }
    }
    
    func testCheckUnicodescalars () {
        
        let s1 = "ab".unicodeScalars
        let s2 = "AB".unicodeScalars
        let s1b = advance(s1.startIndex, 1)
        println(s1[s1b].value)
        println(s2[s2.startIndex].value)
    }
    
    func testCanGetRangeUsingSubscript () {
        let s = "0123abcd"
        let r1 = s[0..<3]
        let r2 = s[3..<7]
        
        XCTAssertEqual("012", r1, "range was \(r1) not 012")
        XCTAssertEqual("3abc", r2, "range was \(r2) not 3abcd")
    }
    
    func testHexStringReturnsColourWithIncorrectLength () {
        let s = "#1234567"
        let (r, g, b) = s.toHexInts();
        
        XCTAssertEqual(18, r, "")
        XCTAssertEqual(52, g, "")
        XCTAssertEqual(86, b, "")
    }
    
    func testHexStringReturnsColorIfCorrectWithHash () {
        let s = "#123456"
        let (r, g, b) = s.toHexInts();
        
        XCTAssertEqual(18, r, "")
        XCTAssertEqual(52, g, "")
        XCTAssertEqual(86, b, "")
    }
    
    func testHexStringReturnsColorIfCorrectWith0x () {
        let s = "0x561234"
        let (r, g, b) = s.toHexInts();
        
        XCTAssertEqual(86, r, "")
        XCTAssertEqual(18, g, "")
        XCTAssertEqual(52, b, "")
    }
    
    
    func testHexStringReturnsColorIfIncorrectWith0x () {
        let s = "0x56123467"
        let (r, g, b) = s.toHexInts();
        
        XCTAssertEqual(86, r, "")
        XCTAssertEqual(18, g, "")
        XCTAssertEqual(52, b, "")
    }
    
    func testHexStringReturnsColorIfIncorrect () {
        let s = "56123467"
        let (r, g, b) = s.toHexInts();
        
        XCTAssertEqual(86, r, "")
        XCTAssertEqual(18, g, "")
        XCTAssertEqual(52, b, "")
    }
    
    func testHexStringReturnsColorIfCorrect () {
        let s = "561234"
        let (r, g, b) = s.toHexInts();
        
        XCTAssertEqual(86, r, "")
        XCTAssertEqual(18, g, "")
        XCTAssertEqual(52, b, "")
    }
}