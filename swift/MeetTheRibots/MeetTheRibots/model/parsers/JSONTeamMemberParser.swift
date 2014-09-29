//
//  JSONTeamMemberParser.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class JSONTeamMemberParser {
    
    var workingData: Dictionary<String, AnyObject>?
    var workingTeamMember: TeamMember?
    
    init() {
    }
    
    func parse (json: Dictionary<String, AnyObject>?) -> TeamMember? {
        if (json == nil) { return nil }
        workingData = json
        if let id = parseId() {
        workingTeamMember = TeamMember(id)
        var parser = parseGivenName()?.parseFamilyName()?.parseNickname()?.parseRole()?.parseLocation()?.parseTwitter()?.parseEmail()?.parseSweet()?.parseSeason()?.parseDescription()?.parseHexColour()
            
            if (parser == nil) { return nil }
        } else {
            return nil
        }
        
        
        return workingTeamMember;
    }
    
    func parseString(key: String) -> String? {
        if (workingData? == nil) { return nil }
        if (workingData![key] == nil) { return nil }
        var value = workingData![key]! as String
        return value
    }
    
    func parseId() -> String? {
        if let value = parseString(TeamMemberFields.ID.toRaw())
        {
            return value
        }
        
        return nil
    }
    
    func parseGivenName () -> JSONTeamMemberParser? {
        if let value = parseString(TeamMemberFields.GIVEN_NAME.toRaw()) {
            workingTeamMember?.givenName = value
            return self
        }
        
        return nil
    }
    
    func parseFamilyName () -> JSONTeamMemberParser? {
        if let value = parseString(TeamMemberFields.FAMILY_NAME.toRaw()) {
            workingTeamMember?.familyName = value
            return self
        }
    
        return nil
    }

    func parseNickname () -> JSONTeamMemberParser? {
        workingTeamMember?.nickName = parseString(TeamMemberFields.NICKNAME.toRaw())
        return self
    }
    
    func parseRole () -> JSONTeamMemberParser? {
        workingTeamMember?.role = parseString(TeamMemberFields.ROLE.toRaw())
        return self
    }
    
    func parseLocation () -> JSONTeamMemberParser? {
        workingTeamMember?.location = parseString(TeamMemberFields.LOCATION.toRaw())
        return self
    }
    
    func parseTwitter () -> JSONTeamMemberParser? {
        workingTeamMember?.twitter = parseString(TeamMemberFields.TWITTER.toRaw())
        return self
    }
    
    func parseEmail () -> JSONTeamMemberParser? {
        workingTeamMember?.email = parseString(TeamMemberFields.EMAIL.toRaw())
        return self
    }
    
    func parseSweet () -> JSONTeamMemberParser? {
        workingTeamMember?.favSweet = parseString(TeamMemberFields.FAV_SWEET.toRaw())
        return self
    }
    
    func parseSeason () -> JSONTeamMemberParser? {
        workingTeamMember?.favSeason = parseString(TeamMemberFields.FAV_SEASON.toRaw())
        return self
    }
    
    func parseDescription () -> JSONTeamMemberParser? {
        workingTeamMember?.description = parseString(TeamMemberFields.DESCRIPTION.toRaw())
        return self
    }
    
    func parseHexColour () -> JSONTeamMemberParser? {
        if (workingData? == nil) { return nil }
        if (workingData![TeamMemberFields.HEXCOLOUR.toRaw()] == nil) { return self }
        var value = workingData![TeamMemberFields.HEXCOLOUR.toRaw()]! as String
        workingTeamMember?.hexColour = UIColor(hexString: value)
        return self
    }
}