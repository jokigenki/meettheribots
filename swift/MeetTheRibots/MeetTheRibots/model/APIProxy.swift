//
//  APIProxy.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation

public class APIProxy
{    
    var connections: [String: DataConnection]!
    var endPoint: String!
    
    init (endPoint: String) {
        self.endPoint = endPoint
        connections = [String: DataConnection]()
    }
    
    func startConnection(requestPath: String, callback: (DataConnection)->Void) {
        let urlPath: String = "\(endPoint)\(requestPath)"
        let dataConnection = DataConnection(urlString: urlPath, callback: callback, errorCallback: onError)
        connections[urlPath] = dataConnection
        dataConnection.start()
    }
    
    // MARK: Team
    func getTeam () {
        startConnection("team", callback: onGotTeam)
    }
    
    func onError (connection: DataConnection) {
        connections.removeValueForKey(connection.urlString)
        // TODO: better error reporting
    }
    
    func onGotTeam (connection: DataConnection) {
        connections.removeValueForKey(connection.urlString)
        let team = parseTeam(connection.jsonArray)
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(Events.GOT_TEAM.toRaw(), object: nil, userInfo: ["\(Team.self)": team])
    }
    
    func parseTeam (json:Array<AnyObject>?) -> Team {
        let parser = JSONTeamParser()
        return parser.parse(json)
    }
    
    // MARK: Team Member
    func getTeamMember (id: String) {
        startConnection("team/\(id)", callback: onGotTeamMember)
    }
    
    func onGotTeamMember (connection: DataConnection) {
        connections.removeValueForKey(connection.urlString)
        if let teamMember = parseTeamMember(connection.jsonDictionary) {
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(Events.GOT_TEAM_MEMBER.toRaw(), object: nil, userInfo: ["\(TeamMember.self)": teamMember])
        }
    }
    
    func parseTeamMember (json: Dictionary<String, AnyObject>?) -> TeamMember? {
        let parser = JSONTeamMemberParser()
        return parser.parse(json)
    }
    
    // MARK: Studio
    func getStudio () {
        startConnection("studio", callback: onGotStudio)
    }
    
    func onGotStudio (connection: DataConnection) {
        connections.removeValueForKey(connection.urlString)
        if let studio = parseStudio(connection.jsonDictionary) {
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(Events.GOT_STUDIO.toRaw(), object: nil, userInfo: ["\(Studio.self)": studio])
        }
    }
    
    func parseStudio (json: [String: AnyObject]?) -> Studio? {
        let parser = JSONStudioParser()
        return parser.parse(json)
    }
}