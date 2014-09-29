//
//  Studio.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class Studio: GridDataItem {
    
    var addressNumber: String!
    var street: String!
    var city: String!
    var county: String!
    var postcode: String!
    var country: String!
    var photos: [String]!
    
    init () {
        photos = [String]()
    }
    
    func getShortLabel() -> String {
        return "ribot"
    }
    
    func getFullLabel() -> String {
        return "ribot"
    }
    
    func getImageURL() -> String? {
        return "local://logo_small_blue"
    }
    
    func getHexColour() -> UIColor {
        return UIColor(18, 162, 216)
    }
    
    func getNickName() -> String? {
        return "A digital studio for mobile, tablet, TV & beyond..."
    }
    
    func getEmail () -> String? {
        return "contact@ribot.co.uk"
    }
    
    func getTwitter() -> String? {
        return "@ribot"
    }
    
    func getLocation() -> String? {
        return "\(city), \(country)"
    }
}