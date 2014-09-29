//
//  DataConnectionStub.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 26/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation

class DataConnectionStub: DataConnection
{
    override init(urlString: String, callback: (DataConnection) -> Void, errorCallback: (DataConnection) -> Void) {
        super.init(urlString: urlString, callback: callback, errorCallback: errorCallback)
    }
    
    override func start() {
        
        let path = NSBundle(forClass: self.dynamicType).pathForResource(urlString!, ofType: "json")
        let jsonData = NSData.dataWithContentsOfFile(path!, options: .DataReadingMappedIfSafe, error: nil)
        
        parseJSONData(jsonData)
        callback(self)
    }
}