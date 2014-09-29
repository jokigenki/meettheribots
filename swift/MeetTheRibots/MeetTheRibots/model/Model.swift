//
//  Model.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 26/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class Model {
    
    var apiProxy: APIProxy!
    var imageProxy: ImageProxy!
    
    var teamObserver: NSObjectProtocol!
    var studioObserver: NSObjectProtocol!
    var teamMemberObserver: NSObjectProtocol!
    
    var team: Team?
    var studio: Studio?
    
    init() {
        initProxies()
        initObservers()
        initData()
    }
    
    func initProxies() {
        apiProxy = APIProxy(endPoint: Config.END_POINT.toRaw())
        imageProxy = ImageProxy() // TEST
    }
    
    func initObservers () {
        
        let nc = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        teamObserver = nc.addObserverForName(Events.GOT_TEAM.toRaw(), object: nil, queue: mainQueue, usingBlock: { note in
            if let userInfo = note.userInfo as? [String: Team!] {
                let team = userInfo["\(Team.self)"]
                self.onGotTeam(team!)
            }
        })
        
        studioObserver = nc.addObserverForName(Events.GOT_STUDIO.toRaw(), object: nil, queue: mainQueue, usingBlock: { note in
            if let userInfo = note.userInfo as? [String: Studio!] {
                let studio = userInfo["\(Studio.self)"]
                self.onGotStudio(studio!)
            }
        })
        
        teamMemberObserver = nc.addObserverForName(Events.GOT_TEAM_MEMBER.toRaw(), object: nil, queue: mainQueue, usingBlock: { note in
            if let userInfo = note.userInfo as? [String: TeamMember!] {
                let teamMember = userInfo["\(TeamMember.self)"]
                self.onGotTeamMember(teamMember!)
            }
        })
    }
    
    func removeObservers () {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(teamObserver, name: Events.GOT_TEAM.toRaw(), object: nil)
        nc.removeObserver(studioObserver, name: Events.GOT_STUDIO.toRaw(), object: nil)
        nc.removeObserver(teamMemberObserver, name: Events.GOT_TEAM_MEMBER.toRaw(), object: nil)
        
        teamObserver = nil
        studioObserver = nil
        teamMemberObserver = nil
    }
    
    func initData () {
        apiProxy.getTeam()
        apiProxy.getStudio()
    }
    
    func onGotTeam(team: Team) {
        self.team = team
        dispatchModelUpdated()
    }
    
    func onGotStudio(studio: Studio) {
        self.studio = studio
        dispatchModelUpdated()
    }
    
    func onGotTeamMember(teamMember: TeamMember) {
        self.team?.addMember(teamMember)
        dispatchModelUpdated()
    }
    
    func dispatchModelUpdated () {
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(Events.MODEL_UPDATED.toRaw(), object: nil)
    }
}