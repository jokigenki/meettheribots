//
//  JSONTeamParser.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation

class JSONTeamParser {
    
    init() {
    }
    
    func parse (data: Array<AnyObject>?) -> Team {
        let team = Team()
        
        if (data == nil) { return team }
        
        let parser = JSONTeamMemberParser()
        
        for obj:AnyObject in data! {
            if let dict = obj as? Dictionary<String, AnyObject> {
                if let member = parser.parse(dict) {
                    team.addMember(member)
                }
            }
        }
        
        return team
    }
}