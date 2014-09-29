//
//  StudioTests.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import XCTest

class StudioTests: XCTestCase {
    
    let target = Studio()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testConstructorCreatesPhotos () {
        XCTAssertNotNil(target.photos, "photos array was not created")
    }
}