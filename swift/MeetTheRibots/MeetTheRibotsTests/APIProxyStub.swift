//
//  APIProxyStub.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 25/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation

class APIProxyStub: APIProxy
{
    var parseTeamCount = 0;
    var parseTeamMemberCount = 0;
    var parseStudioCount = 0;

    var getTeamCount = 0
    var getStudioCount = 0
    var getTeamMemberId: String?

    init() {
        super.init(endPoint: "")
    }
    
    override func getTeam() {
        getTeamCount++
        super.getTeam()
    }
    
    override func getStudio() {
        getStudioCount++
        super.getStudio()
    }
    
    override func getTeamMember (id: String) {
        getTeamMemberId = id
        startConnection(id, callback: onGotTeamMember)
    }
    
    override func parseTeam(json: Array<AnyObject>?) -> Team {
        parseTeamCount++
        return super.parseTeam(json)
    }
    
    override func parseTeamMember(json: [String: AnyObject]?) -> TeamMember? {
        parseTeamMemberCount++
        return super.parseTeamMember(json)
    }
    
    override func parseStudio(json: [String: AnyObject]?) -> Studio? {
        parseStudioCount++
        return super.parseStudio(json)
    }
    
    override func startConnection(requestPath: String, callback: (DataConnection)->Void) {
        let dataConnection = DataConnectionStub(urlString: requestPath, callback: callback, errorCallback: onError)
        connections[requestPath] = dataConnection
        dataConnection.start()
    }
}