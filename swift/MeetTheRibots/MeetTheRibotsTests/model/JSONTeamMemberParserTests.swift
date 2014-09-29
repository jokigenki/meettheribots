//
//  JSONTeamMemberParserTests.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import XCTest
import UIKit

class JSONTeamMemberParserTests: XCTestCase {
    
    var target:JSONTeamMemberParser = JSONTeamMemberParser()
    
    override func setUp() {
        super.setUp()
        initTestData()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func initTestData () {
        var data = [String: AnyObject]()
        data[TeamMemberFields.ID.toRaw()] = "myId"
        data[TeamMemberFields.GIVEN_NAME.toRaw()] = "test"
        data[TeamMemberFields.FAMILY_NAME.toRaw()] = "mcTest"
        data[TeamMemberFields.NICKNAME.toRaw()] = "the tester"
        data[TeamMemberFields.ROLE.toRaw()] = "high roller"
        data[TeamMemberFields.LOCATION.toRaw()] = "at home"
        data[TeamMemberFields.TWITTER.toRaw()] = "twits"
        data[TeamMemberFields.EMAIL.toRaw()] = "a@b.c"
        data[TeamMemberFields.FAV_SWEET.toRaw()] = "dude"
        data[TeamMemberFields.FAV_SEASON.toRaw()] = "2"
        data[TeamMemberFields.DESCRIPTION.toRaw()] = "just a guy"
        data[TeamMemberFields.HEXCOLOUR.toRaw()] = "#FF0000"
        target.workingData = data
        target.workingTeamMember = TeamMember("myId")
    }
    
    // MARK: parse
    func testParseReturnsNilWithNil () {
        XCTAssertNil(target.parse(nil))
    }
    
    func testParseReturnsNilWithEmptyData () {
        XCTAssertNil(target.parse([String: AnyObject]()))
    }
    
    func testParseReturnsNilWithMissingID () {
        target.workingData![TeamMemberFields.ID.toRaw()] = nil
        target.workingTeamMember = TeamMember("")
        XCTAssertNil(target.parse(target.workingData!))
    }
    
    func testParseReturnsNilWithMissingGivenName () {
        target.workingData![TeamMemberFields.GIVEN_NAME.toRaw()] = nil
        target.workingTeamMember = TeamMember("")
        XCTAssertNil(target.parse(target.workingData!))
    }
    
    func testParseReturnsNilWithMissingFamilyName () {
        target.workingData![TeamMemberFields.FAMILY_NAME.toRaw()] = nil
        target.workingTeamMember = TeamMember("")
        XCTAssertNil(target.parse(target.workingData!))
    }
    
    func testParseReturnsTeamMemberWithOnlyRequiredData () {
        
        XCTAssertNotNil(target.parse(target.workingData!))
    }
    
    // MARK: parseString
    
    func testParseStringReturnsNilIfNoWorkingData () {
        target.workingData = nil
        target.workingTeamMember = nil
        XCTAssertNil(target.parseString(TeamMemberFields.GIVEN_NAME.toRaw()))
    }
    
    func testParseStringReturnsNilIfNoString () {
        target.workingData = [:]
        target.workingTeamMember = TeamMember("")
        XCTAssertNil(target.parseString(TeamMemberFields.GIVEN_NAME.toRaw()))
    }
    
    func testParseStringReturnsValueIfKeySupplied () {
        var value = target.parseString(TeamMemberFields.GIVEN_NAME.toRaw())
        XCTAssertNotNil(value)
    }
    
    func testParseStringReturnsCorrectValueIfSupplied () {
        var value = target.parseString(TeamMemberFields.GIVEN_NAME.toRaw())!
        XCTAssertEqual(value, "test")
    }

    // MARK: parseId
    
    func testParseIdReturnsNilIfNoId () {
        target.workingData = [:];
        XCTAssertNil(target.parseId())
    }
    
    func testParseIdSetsCorrectValueIfSupplied () {
        if let id = target.parseId() {
            XCTAssertEqual(id, "myId")
        } else {
            XCTFail("id did not match")
        }
    }
    
    // MARK: parseGivenName
    func testParseGivenNameReturnsNilParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseGivenName()
        XCTAssertNil(parser)
    }
    
    func testParseGivenNameSetsCorrectValueIfSupplied () {
        var parser = target.parseGivenName()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.givenName, "test")
        }
    }

    // MARK: parseFamilyName
    func testParseFamilyNameReturnsNilParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseFamilyName()
        XCTAssertNil(parser)
    }
    
    func testParseFamilyNameSetsCorrectValueIfSupplied () {
        var parser = target.parseFamilyName()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.familyName, "mcTest")
        }
    }
    
    // MARK: parseNickname
    func testParseNicknameReturnsParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseNickname()
        XCTAssertNotNil(parser)
    }
    
    func testParseNicknameSetsCorrectValueIfSupplied () {
        var parser = target.parseNickname()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.nickName!, "the tester")
        }
    }
    
    // MARK: parseRole
    func testParseRoleReturnsParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseRole()
        XCTAssertNotNil(parser)
    }
    
    func testParseRoleSetsCorrectValueIfSupplied () {
        var parser = target.parseRole()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.role!, "high roller")
        }
    }
    
    // MARK: parseLocation
    func testParseLocationReturnsParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseRole()
        XCTAssertNotNil(parser)
    }
    
    func testParseLocationSetsCorrectValueIfSupplied () {
        var parser = target.parseLocation()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.location!, "at home")
        }
    }
    
    // MARK: parseTwitter
    func testParseTwitterReturnsParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseTwitter()
        XCTAssertNotNil(parser)
    }
    
    func testParseTwitterSetsCorrectValueIfSupplied () {
        var parser = target.parseTwitter()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.twitter!, "twits")
        }
    }
    
    // MARK: parseEmail
    func testParseEmailReturnsParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseEmail()
        XCTAssertNotNil(parser)
    }
    
    func testParseEmailSetsCorrectValueIfSupplied () {
        var parser = target.parseEmail()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.email!, "a@b.c")
        }
    }
    
    // MARK: parseSweet
    func testParseSweetReturnsParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseSweet()
        XCTAssertNotNil(parser)
    }
    
    func testParseSweetSetsCorrectValueIfSupplied () {
        var parser = target.parseSweet()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.favSweet!, "dude")
        }
    }
    
    // MARK: parseSeason
    func testParseSeasonReturnsParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseSeason()
        XCTAssertNotNil(parser)
    }
    
    func testParseSeasonSetsCorrectValueIfSupplied () {
        var parser = target.parseSeason()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.favSeason!, "2")
        }
    }
    
    // MARK: parseDescription
    func testParseDescriptionReturnsParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseDescription()
        XCTAssertNotNil(parser)
    }
    
    func testParseDescriptionSetsCorrectValueIfSupplied () {
        var parser = target.parseDescription()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.description!, "just a guy")
        }
    }
    
    // MARK: parseHexColour
    func testParseHexColourReturnsParserIfNoValue () {
        target.workingData = [:]
        var parser = target.parseHexColour()
        XCTAssertNotNil(parser)
    }
    
    func testParseHexColourSetsCorrectValueIfSupplied () {
        var parser = target.parseHexColour()
        var teamMember = parser?.workingTeamMember
        if (teamMember != nil) {
            XCTAssertEqual(teamMember!.hexColour!, UIColor.redColor())
        }
    }
}