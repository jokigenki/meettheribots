//
//  APIProxyTests.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class APIProxyTests: XCTestCase {
    
    let stubbedTarget = APIProxyStub()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - vars
    func testEndPointIsSetByConstructor() {
        let target = APIProxy(endPoint: "test endpoint")
        XCTAssertEqual("test endpoint", target.endPoint, "end point is not set by constructor")
    }
    
    func testCanSetEndPoint() {
        stubbedTarget.endPoint = "blah"
        XCTAssertEqual("blah", stubbedTarget.endPoint, "could not set end point")
    }
    
    func testCanGetTeam () {
        stubbedTarget.getTeam()
    }
    
    // MARK: - Team
    // MARK: getTeam
    func testGetTeamReturnsData() {
        runAsyncTest("On Got Team", timeout: 2, event: Events.GOT_TEAM, method: stubbedTarget.getTeam, callback: assertTeamNotNil, completion: nil)
    }
    
    func assertTeamNotNil (note: NSNotification) {
        
        let userInfo = note.userInfo as [String: Team!]
        let team = userInfo["\(Team.self)"]
        XCTAssertNotNil(team, "team was nil");
    }
    
    func testGetTeamReturnsCorrectNumberOfTeamMembers () {
        runAsyncTest("On Got Team", timeout: 2, event: Events.GOT_TEAM, method: stubbedTarget.getTeam, callback: assertTeamHasCorrectNumberOfMembers, completion: nil)
    }

    func assertTeamHasCorrectNumberOfMembers (note: NSNotification) {
        
        let userInfo = note.userInfo as [String: Team!]
        let team = userInfo["\(Team.self)"]
        XCTAssertEqual(14, team!.getNumberOfMembers());
    }

    // MARK: onGotTeam
    func testOnGotTeamDispatchesEventWithTeamObject () {
        let expectation = expectationWithDescription("OnGotTeam did not dispatch event")
        
        let nc = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        var observer = nc.addObserverForName(Events.GOT_TEAM.toRaw(), object: nil, queue: mainQueue) { note in
            
            let userInfo = note.userInfo as [String: Team!]
            let team = userInfo["\(Team.self)"]
            XCTAssertNotNil(team, "team was nil")
            expectation.fulfill()
        }
        
        let connection = DataConnection(urlString: "", callback: stubbedTarget.onGotTeam, errorCallback: stubbedTarget.onError )
        stubbedTarget.onGotTeam(connection)
        
        waitForExpectationsWithTimeout(2, handler: { error in
            nc.removeObserver(observer, name: Events.GOT_TEAM.toRaw(), object: nil)
        })
    }
    
    func testOnGotTeamCallsParseTeam () {
        stubbedTarget.parseTeamCount = 0
        let connection = DataConnection(urlString: "", callback: stubbedTarget.onGotTeam, errorCallback: stubbedTarget.onError)
        stubbedTarget.onGotTeam(connection)
        
        XCTAssertEqual(1, stubbedTarget.parseTeamCount, "onGotTeam did not call parse team")
    }
    
    // MARK: parseTeam
    // other tests are under getTeam to test whole stack
    func testParseTeamReturnsTeamWithNilInput () {
        XCTAssertNotNil(stubbedTarget.parseTeam(nil), "parse team did not return Team with nil input")
    }
    
    func testParseTeamReturnsTeamWithDictionaryInput () {
        let data = [AnyObject]()
        XCTAssertNotNil(stubbedTarget.parseTeam(data), "parse team returned nil instead of Team")
    }
    
    // MARK: - Team Member
    // MARK: getTeamMember
    func testGetTeamMemberReturnsData() {
        let expectation = expectationWithDescription("async test complete")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        var observer = notificationCenter.addObserverForName(Events.GOT_TEAM_MEMBER.toRaw(), object: nil, queue: mainQueue) { note in
            
            expectation.fulfill()
            let userInfo = note.userInfo as [String: TeamMember!]
            let teamMember = userInfo["\(TeamMember.self)"]
            XCTAssertNotNil(teamMember, "team member was nil");
        }
        
        stubbedTarget.getTeamMember("antony")
        
        waitForExpectationsWithTimeout(2, handler: { error in
            notificationCenter.removeObserver(observer, name: Events.GOT_TEAM_MEMBER.toRaw(), object: nil)
        })
    }
    
    // MARK: onGotTeamMember
    func testOnGotTeamMemberDispatchesEventWithTeamMemberObject () {
        let expectation = expectationWithDescription("OnGotTeamMember did not dispatch event")
        
        let nc = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        var observer = nc.addObserverForName(Events.GOT_TEAM_MEMBER.toRaw(), object: nil, queue: mainQueue) { note in
            
            let userInfo = note.userInfo as [String: TeamMember!]
            let teamMember = userInfo["\(TeamMember.self)"]
            XCTAssertNotNil(teamMember, "teamMember was nil")
            expectation.fulfill()
        }
        
        let connection = DataConnection(urlString: "antony", callback: stubbedTarget.onGotTeamMember, errorCallback: stubbedTarget.onError)
        connection.jsonDictionary = ["id":"test", "firstName":"Test", "lastName":"McTest"]
        stubbedTarget.onGotTeamMember(connection)
        
        waitForExpectationsWithTimeout(2, handler: { error in
            nc.removeObserver(observer, name: Events.GOT_TEAM_MEMBER.toRaw(), object: nil)
        })
    }

    func testOnGotTeamMemberCallsParseTeamMember () {
        stubbedTarget.parseTeamMemberCount = 0
        let connection = DataConnection(urlString: "", callback: stubbedTarget.onGotTeamMember, errorCallback: stubbedTarget.onError)
        stubbedTarget.onGotTeamMember(connection)
        
        XCTAssertEqual(1, stubbedTarget.parseTeamMemberCount, "onGotTeam did not call parse team")
    }
    
    // MARK: parseTeamMember
    // other tests are under getTeamMember to test whole stack
    func testParseTeamMemberReturnsNilWithNilInput () {
        XCTAssertNil(stubbedTarget.parseTeamMember(nil), "parse team member did not return nil for nil input")
    }
    
    func testParseTeamMemberReturnsTeamMemberWithInput () {
        let data = ["id":"test", "firstName": "test", "lastName": "mcTest"]
        XCTAssertNotNil(stubbedTarget.parseTeamMember(data), "parse team member returned nil with empty input")
    }
    
    
    // MARK: - Studio
    // MARK: getStudio
    func testGetStudioReturnsData() {
        runAsyncTest("On Got Studio", timeout: 2, event: Events.GOT_STUDIO, method: stubbedTarget.getStudio, callback: assertStudioNotNil, completion: nil)
    }
    
    func assertStudioNotNil (note: NSNotification) {
        
        let userInfo = note.userInfo as [String: Studio!]
        let studio = userInfo["\(Studio.self)"]
        XCTAssertNotNil(studio, "studio was nil");
    }
    
    // MARK: onGotStudio
    func testOnGotStudioDispatchesEventWithStudioObject () {
        let expectation = expectationWithDescription("OnGotStudio did not dispatch event")
        
        let nc = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        var observer = nc.addObserverForName(Events.GOT_STUDIO.toRaw(), object: nil, queue: mainQueue) { note in
            
            let userInfo = note.userInfo as [String: Studio!]
            let studio = userInfo["\(Studio.self)"]
            XCTAssertNotNil(studio, "studio was nil")
            expectation.fulfill()
        }
        
        let connection = DataConnection(urlString: "", callback: stubbedTarget.onGotStudio, errorCallback: stubbedTarget.onError)
        stubbedTarget.onGotStudio(connection)
        
        waitForExpectationsWithTimeout(2, handler: { error in
            nc.removeObserver(observer, name: Events.GOT_STUDIO.toRaw(), object: nil)
        })
    }
    
    func testOnGotStudioCallsParseStudio () {
        stubbedTarget.parseStudioCount = 0
        let connection = DataConnection(urlString: "", callback: stubbedTarget.onGotStudio, errorCallback: stubbedTarget.onError)
        stubbedTarget.onGotStudio(connection)
        
        XCTAssertEqual(1, stubbedTarget.parseStudioCount, "onGotStudio did not call parse studio")
    }
    
    // MARK: parseTeam
    // other tests are under getTeam to test whole stack
    func testParseStudioReturnsStudioWithNilInput () {
        XCTAssertNotNil(stubbedTarget.parseStudio(nil), "parse studio did not return Studio with nil input")
    }
    
    func testParseStudioReturnsStudioWithDictionaryInput () {
        let data = ["addressNumber":"63A", "street": "Ship Street", "city": "Brighton", "county":"East Sussex", "postcode":"BN1 1AE", "country":"UK"]
        XCTAssertNotNil(stubbedTarget.parseStudio(data), "parse studio returned nil instead of Studio")
    }
    
    // async helper
    func runAsyncTest (description: String, timeout: NSTimeInterval, event: Events, method: (() -> Void)?, callback: ((note: NSNotification) -> Void)?, completion: (() -> Void)?) {
        let expectation = expectationWithDescription("async test complete")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        var observer = notificationCenter.addObserverForName(event.toRaw(), object: nil, queue: mainQueue) { note in
            
            expectation.fulfill()
            callback?(note: note)
        }
        
        method?()
        
        waitForExpectationsWithTimeout(timeout, handler: { error in
            notificationCenter.removeObserver(observer, name: event.toRaw(), object: nil)
            completion?()
        })
    }
}