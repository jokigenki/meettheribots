//
//  JSONTeamParserTests.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import XCTest

class JSONTeamParserTests: XCTestCase {
    
    let target = JSONTeamParser()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParseReturnsTeamWithNilData () {
        XCTAssertNotNil(target.parse(nil), "team was nil")
    }
    
    func testParseReturnsTeamWithEmptyData () {
        let data = [AnyObject]()
        XCTAssertNotNil(target.parse(data), "team was nil")
    }
    
    func testParseTestJSONReturnTeamCorrectNumberOfMembers () {
        var data = [AnyObject]()
        for index in 0..<4 {
            let member = ["id":"test\(index)", "firstName":"Test", "lastName":"McTest"]
            data.append(member)
        }
        
        var team = target.parse(data)
        
        XCTAssertEqual(4, team.getNumberOfMembers(), "incorrect number of members")
    }
    
    func testParseTestJSONDoesNotIncludeInvalidMembers () {
        var data = [AnyObject]()
        for index in 0..<4 {
            let member = ["id":"test\(index)", "firstName":"Test", "lastName":"McTest"]
            data.append(member)
        }
        
        let badMember = ["id":"baddy", "lastName":"Von Badguy"]
        data.append(badMember)
        
        var team = target.parse(data)
        
        XCTAssertEqual(4, team.getNumberOfMembers(), "incorrect number of members")
    }
}