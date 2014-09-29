//
//  TeamTests.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class TeamTests: XCTestCase {
    
    let target = Team()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // init
    func testCanAccessMembers () {
        let members = target.getMembers()
        XCTAssertNotNil(members, "members is nil")
    }
    
    // MARK: - addMember
    func testCannotAddNilMember () {
        XCTAssertEqual(0, target.getNumberOfMembers(), "# members is not 0")
        target.addMember(nil)
        XCTAssertEqual(0, target.getNumberOfMembers(), "# members is not 0")
    }
    
    func testCanAddMember () {
        XCTAssertEqual(0, target.getNumberOfMembers(), "# members is not 0")
        target.addMember(TeamMember("a"))
        XCTAssertEqual(1, target.getNumberOfMembers(), "# members is not 1")
    }
    
    func testCanAddMembers () {
        XCTAssertEqual(0, target.getNumberOfMembers(), "# members is not 0")
        var member1 = TeamMember("a")
        member1.id = "one"
        var member2 = TeamMember("b")
        member2.id = "two"
        target.addMember(member1)
        target.addMember(member2)
        XCTAssertEqual(2, target.getNumberOfMembers(), "# members is not 2")
    }
    
    func testAddingMemberWithSameIdDoesNotAddANewMember () {
        let member1 = TeamMember("test")
        let member2 = TeamMember("test")
        
        target.addMember(member1)
        target.addMember(member2)
        
        XCTAssertEqual(1, target.getNumberOfMembers(), "# members is not 1")
    }
    
    func testAddingMemberWithSameIdUpdatesData () {
        let member1 = TeamMember("test")
        member1.givenName = "bob"
        let member2 = TeamMember("test")
        member2.givenName = "dave"
        
        target.addMember(member1)
        target.addMember(member2)

        let member = target.getMembers()[0]
        
        XCTAssertEqual("dave", member.givenName, "name was not updated")
    }
    
    // MARK: - replaceMember
    func testReplacingMissingMemberDoesNotAddMember () {
        let member1 = TeamMember("test")
        target.replaceMemberUsingId(member1)
        
        XCTAssertEqual(0, target.getNumberOfMembers(), "# members is not 0")
    }
    
    func testReplacingMemberWithSameIdDoesNotAddANewMember () {
        let member1 = TeamMember("test")
        let member2 = TeamMember("test")
        
        target.addMember(member1)
        target.replaceMemberUsingId(member2)
        
        XCTAssertEqual(1, target.getNumberOfMembers(), "# members is not 1")
    }
    
    func testReplacingMemberWithSameIdUpdatesData () {
        let member1 = TeamMember("test")
        member1.givenName = "bob"
        let member2 = TeamMember("test")
        member2.givenName = "dave"
        
        target.addMember(member1)
        target.replaceMemberUsingId(member2)
        
        let member = target.getMembers()[0]
        
        XCTAssertEqual("dave", member.givenName, "name was not updated")
    }
    
    // MARK: - getMembers
    func testCanGetMembers () {
        target.addMember(TeamMember("test"))
        XCTAssertEqual(1, target.getMembers().count, "could not get members")
    }
    
    // MARK: - getNumberOfMembers
    func testCanGetNumberMembers () {
        target.addMember(TeamMember("test"))
        XCTAssertEqual(target.getMembers().count, target.getNumberOfMembers(), "number of members does not match")
    }
    
    // MARK: - getMemberForIndex
    func testCanGetMemberForIndex () {
        
        var memberIds = ["juan", "tulisa", "freda", "ford"]
        var members = [TeamMember]()
        for index in 0..<memberIds.count {
            let m = TeamMember(memberIds[index])
            target.addMember(m)
        }
        
        for index in 0..<memberIds.count {
            if let m = target.getMemberForIndex(index) {
                XCTAssertEqual(m.id, memberIds[index], "name for \(index) did not match")
            } else {
                XCTFail("member for \(index) was nil")
            }
        }
    }
}