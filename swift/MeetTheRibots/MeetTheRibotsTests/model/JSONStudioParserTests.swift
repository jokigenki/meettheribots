//
//  JSONStudioParserTests.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import XCTest

class JSONStudioParserTests: XCTestCase {
    
    let target = JSONStudioParser()
    
    override func setUp() {
        super.setUp()
        initTestData()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func initTestData () {
        var data = [String: AnyObject]()
        data[StudioFields.ADDRESS_NUMBER.toRaw()] = "63A"
        data[StudioFields.STREET.toRaw()] = "Ship Street"
        data[StudioFields.CITY.toRaw()] = "Brighton"
        data[StudioFields.COUNTY.toRaw()] = "East Sussex"
        data[StudioFields.POSTCODE.toRaw()] = "BN1 1AE"
        data[StudioFields.COUNTRY.toRaw()] = "UK"
        data[StudioFields.PHOTOS.toRaw()] = ["https://dl.dropbox.com/u/6740094/ribot/DSCN0364.JPG",
            "https://dl.dropbox.com/u/6740094/ribot/IMG_20120525_155047.jpg"]
        target.workingData = data
        target.workingStudio = Studio()
    }
    
    func assertStudioIsEmpty (studio: Studio) {
        XCTAssertNil(studio.addressNumber)
        XCTAssertNil(studio.street)
        XCTAssertNil(studio.city)
        XCTAssertNil(studio.county)
        XCTAssertNil(studio.postcode)
        XCTAssertNil(studio.country)
        XCTAssertEqual(0, studio.photos.count)
    }
    
    func assertStudioIsComplete (studio: Studio) {
        XCTAssertEqual("63A", studio.addressNumber)
        XCTAssertEqual("Ship Street", studio.street)
        XCTAssertEqual("Brighton", studio.city)
        XCTAssertEqual("East Sussex", studio.county)
        XCTAssertEqual("BN1 1AE", studio.postcode)
        XCTAssertEqual("UK", studio.country)
        XCTAssertEqual(2, studio.photos.count)
    }
    
    // MARK: parse
    func testParseReturnsEmptyStudioWithNil () {
        let studio = target.parse(nil)
        assertStudioIsEmpty(studio)
    }
    
    func testParseReturnsEmptyStudioWithEmptyData () {
        let studio = target.parse([String: AnyObject]())
        assertStudioIsEmpty(studio)
    }
    
    func testParseReturnsEmptyStudioWithMissingAddressNumber () {
        target.workingData![StudioFields.ADDRESS_NUMBER.toRaw()] = nil
        let studio = target.parse(target.workingData!)
        assertStudioIsEmpty(studio)
    }
    
    func testParseReturnsEmptyStudioWithMissingStreet () {
        target.workingData![StudioFields.STREET.toRaw()] = nil
        let studio = target.parse(target.workingData!)
        assertStudioIsEmpty(studio)
    }
    
    func testParseReturnsEmptyStudioWithMissingCity () {
        target.workingData![StudioFields.CITY.toRaw()] = nil
        let studio = target.parse(target.workingData!)
        assertStudioIsEmpty(studio)
    }
    
    func testParseReturnsEmptyStudioWithMissingCounty () {
        target.workingData![StudioFields.COUNTY.toRaw()] = nil
        let studio = target.parse(target.workingData!)
        assertStudioIsEmpty(studio)
    }
    
    func testParseReturnsEmptyStudioWithMissingPostcode () {
        target.workingData![StudioFields.POSTCODE.toRaw()] = nil
        let studio = target.parse(target.workingData!)
        assertStudioIsEmpty(studio)
    }
    
    func testParseReturnsEmptyStudioWithMissingCountry () {
        target.workingData![StudioFields.COUNTRY.toRaw()] = nil
        let studio = target.parse(target.workingData!)
        assertStudioIsEmpty(studio)
    }
    
    func testParseReturnsCompletedStudioWithCorrectData () {
        let studio = target.parse(target.workingData!)
        assertStudioIsComplete(studio)
    }
}