//
//  Team.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class Team {

    private var _members: [TeamMember]!
    
    init () {
        _members = [TeamMember]()
    }
    
    func addMember (member: TeamMember?) {
        if (member == nil) { return }
        
        var replaced = replaceMemberUsingId(member!)
        if (!replaced) { _members.append(member!) }
    }
    
    func replaceMemberUsingId (member: TeamMember) -> Bool {
        for index in 0..<_members.count {
            let check = _members[index]
            if (check.id == member.id) {
                _members.removeAtIndex(index)
                _members.insert(member, atIndex: index)
                return true
            }
        }
    
        return false
    }
    
    func getMembers () -> [TeamMember] {
        return _members
    }
    
    func getNumberOfMembers () -> Int {
        return _members.count
    }
    
    // TODO: test
    func getMemberForIndex (index: Int) ->TeamMember? {
        if (index < _members.count && index > -1) { return _members[index] }
        return nil
    }
}