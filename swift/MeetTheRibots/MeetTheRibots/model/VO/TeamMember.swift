//
//  TeamMember.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class TeamMember: GridDataItem {
    
    var id: String!
    var givenName: String!
    var familyName: String!
    var nickName: String?
    var location: String?
    var role: String?
    var hexColour: UIColor?
    var twitter: String?
    var email: String?
    var favSweet: String?
    var favSeason: String?
    var description: String?
    
    init(_ id: String) {
        self.id = id
    }
    
    func getShortLabel() -> String {
        return givenName
    }
    
    func getFullLabel() -> String {
        return "\(givenName) \(familyName)"
    }
    
    func getImageURL() -> String? {
        return "\(Config.END_POINT.toRaw())team/\(id)/ribotar"
    }
    
    func getHexColour() -> UIColor {
        if (hexColour == nil) { return UIColor.magentaColor() }//hexColour = UIColor.getRandom() }
        return hexColour!
    }
    
    func getNickName() -> String? {
        return nickName
    }
    
    func getEmail() -> String? {
        return email
    }
    
    func getTwitter() -> String? {
        return twitter
    }
    
    func getLocation() -> String? {
        return location
    }
}