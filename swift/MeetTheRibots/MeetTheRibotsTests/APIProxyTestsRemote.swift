//
//  APIProxyTestsRemote.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import XCTest

class APIProxyTestsRemote: XCTestCase {
    
    let target = APIProxy(endPoint: Config.END_POINT.toRaw())
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCanGetTeam () {
        runAsyncTest("On Got Team", timeout: 5, event: Events.GOT_TEAM, method: target.getTeam, callback: assertHasTeam, completion: nil)
    }
    
    func assertHasTeam (note: NSNotification) {
        let userInfo = note.userInfo as [String: Team!]
        let team = userInfo["\(Team.self)"]
        XCTAssertNotNil(team);
    }
    
    func testCanGetStudio () {
        runAsyncTest("On Got Studio", timeout: 5, event: Events.GOT_STUDIO, method: target.getStudio, callback: assertHasStudio, completion: nil)
    }
    
    func assertHasStudio (note: NSNotification) {
        let userInfo = note.userInfo as [String: Studio]
        let studio = userInfo["\(Studio.self)"]
        XCTAssertNotNil(studio);
    }
    
    func testCanGetTeamMember () {
        let expectation = expectationWithDescription("async test complete")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        var observer = notificationCenter.addObserverForName(Events.GOT_TEAM_MEMBER.toRaw(), object: nil, queue: mainQueue) { note in
            
            expectation.fulfill()
            let userInfo = note.userInfo as [String: TeamMember!]
            if let tm = userInfo["\(TeamMember.self)"] {
                self.assertValuesAreCorrect(tm)
            } else {
                XCTFail("team member was nil")
            }
        }
        
        target.getTeamMember("antony")
        
        waitForExpectationsWithTimeout(10, handler: { error in
            notificationCenter.removeObserver(observer, name: Events.GOT_TEAM_MEMBER.toRaw(), object: nil)
        })
    }
    
    func assertValuesAreCorrect (tm: TeamMember) {
        XCTAssertEqual(tm.givenName, "Antony")
        XCTAssertEqual(tm.familyName, "Ribot")
        XCTAssertEqual(tm.nickName!, "The ShowPig™")
        XCTAssertEqual(tm.location!, "Brighton, UK")
        XCTAssertEqual(tm.role!, "Co-founder and glue")
        XCTAssertNotNil(tm.hexColour)
        XCTAssertEqual(tm.twitter!, "ribotmaximus")
        XCTAssertEqual(tm.email!, "antony@ribot.co.uk")
        XCTAssertEqual(tm.favSweet!, "Dusty Milk Bottles")
        XCTAssertEqual(tm.favSeason!, "Autumn")
        XCTAssertEqual(tm.description!, "Co-founder of ribot, Antony is inspired by human behaviour, natural systems and good food. When not thinking about what's for dinner, Antony loves to ponder the possibilities of the latest phones, tablets and tech; imagining what's just over the horizon and shaping the team ribot vision.")
        XCTAssertEqual(tm.id, "antony")
    }
    
    // MARK: - async helper
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