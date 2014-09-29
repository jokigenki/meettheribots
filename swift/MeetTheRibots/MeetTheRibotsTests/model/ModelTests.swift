//
//  ModelTests.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import XCTest

class ModelTests: XCTestCase {
    
    let target = ModelStub()
    let stubbedProxy = APIProxyStub()
    
    override func setUp() {
        super.setUp()
    
        target.apiProxy = stubbedProxy
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: init
    
    func testInitCallsInitProxy () {
        XCTAssertEqual(1, target.initProxiesCount, "initProxy wasn't called, or was called multiple times")
    }

    func testInitCallsInitData () {
        XCTAssertEqual(1, target.initDataCount, "initData wasn't called, or was called multiple times")
    }

    func testInitCallsInitObservers () {
        XCTAssertEqual(1, target.initObserversCount, "initObservers wasn't called, or was called multiple times")
    }
    
    // MARK: deinit
    
    // MARK: initProxy
    func testInitProxyInitsProxy () {
        target.apiProxy = nil
        target.imageProxy = nil
        target.initProxies()
        XCTAssertNotNil(target.apiProxy, "apiPoxy was not init'd")
        XCTAssertNotNil(target.imageProxy, "imageProxy was not init'd")
    }
    
    // MARK: initObservers
    func testInitProxyInitsObservers () {
        target.teamObserver = nil
        target.studioObserver = nil
        target.teamMemberObserver = nil
        
        target.initObservers()
        
        XCTAssertNotNil(target.teamObserver, "team observer was nil")
        XCTAssertNotNil(target.studioObserver, "studio observer was nil")
        XCTAssertNotNil(target.teamMemberObserver, "team member observer was nil")
    }
    
    // MARK: removeObservers
    func testRemoveObserversNilsObservers () {
        XCTAssertNotNil(target.teamObserver, "team observer was nil")
        XCTAssertNotNil(target.studioObserver, "studio observer was nil")
        XCTAssertNotNil(target.teamMemberObserver, "team member observer was nil")
        
        target.removeObservers()
        
        XCTAssertNil(target.teamObserver, "team observer was not nil")
        XCTAssertNil(target.studioObserver, "studio observer was not nil")
        XCTAssertNil(target.teamMemberObserver, "team member observer was not nil")
    }
    
    // MARK: initData
    func testInitDataCallsGetTeam () {
        stubbedProxy.getTeamCount = 0
        target.initData()
        XCTAssertEqual(1, stubbedProxy.getTeamCount, "getTeam was not called, or called multiple times")
    }

    func testInitDataCallsGetStudio () {
        stubbedProxy.getStudioCount = 0
        target.initData()
        XCTAssertEqual(1, stubbedProxy.getStudioCount, "getStudio was not called, or called multiple times")
    }
    
    // MARK: - onGotTeam
    func testOnGotTeamSetsTeam () {
        target.team = nil;
        let team = Team()
        target.onGotTeam(team)
        
        XCTAssertNotNil(target.team, "team was not set")
    }
    
    func testOnGotTeamDispatchesModelUpdated () {
        target.dispatchModelUpdatedCount = 0
        let team = Team()
        target.onGotTeam(team)
        
        XCTAssertEqual(1, target.dispatchModelUpdatedCount, "dispatch model was not called")
    }
    
    // MARK: - onGotStudio
    func testOnGotStudioSetsStudio () {
        target.studio = nil;
        let studio = Studio()
        target.onGotStudio(studio)
        
        XCTAssertNotNil(target.studio, "studio was not set")
    }
    
    func testOnGotStudioDispatchesModelUpdated () {
        target.dispatchModelUpdatedCount = 0
        let studio = Studio()
        target.onGotStudio(studio)
        
        XCTAssertEqual(1, target.dispatchModelUpdatedCount, "dispatch model was not called")
    }
    
    // MARK: - onGotTeamMember
    func testOnGotTeamMemberAddsTeamMemberToTeam () {
        let team = Team()
        target.team = team
        
        let member = TeamMember("")
        target.onGotTeamMember(member)
        
        XCTAssertEqual(1, team.getNumberOfMembers(), "member was not added")
    }
    
    func testOnGotTeamMemberDispatchesModelUpdated () {
        target.dispatchModelUpdatedCount = 0
        let team = Team()
        target.team = team
        
        let member = TeamMember("")
        target.onGotTeamMember(member)  
        
        XCTAssertEqual(1, target.dispatchModelUpdatedCount, "dispatch model was not called")
    }
}