//
//  ImageProxyTests.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 29/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import XCTest
import UIKit

class ImageProxyTests: XCTestCase {
    
    let target = ImageProxy()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCanAddImageToCache () {
        let img = UIImage(named:"placeholder")
        target.addImageToCache("test", image: img)
        
        XCTAssertNotNil(target.imageCache["test"], "image was not in cache")
    }
    
    func testCanGetImageFromCache () {
        let img = UIImage(named:"placeholder")
        target.addImageToCache("test", image: img)
        
        XCTAssertNotNil(target.getImageFromCache("test"), "image was not in cache")
    }
    
    func testCanGetALocalImage () {
        let img = target.getLocalImage("local://placeholder")
         XCTAssertNotNil(img, "image was not in cache")
    }
    
    func testGetImageReturnsLocalImage () {
        XCTAssertNotNil(target.getImage("local://placeholder"), "image was not in cache")
    }

    func testGetImageReturnsCachedImage () {
        let img = UIImage(named:"placeholder")
        target.addImageToCache("test", image: img)
        XCTAssertNotNil(target.getImage("test"), "image was not in cache")
    }
    
    // TODO: test async image caching
    
}