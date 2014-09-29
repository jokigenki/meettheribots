//
//  DataConnection.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 26/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class DataConnection {
    
    var task: NSURLSessionDataTask?
    var urlString: String!
    var callback: (DataConnection)->Void?
    var errorCallback: (DataConnection)->Void?
    lazy var data = NSMutableData()
    var jsonDictionary: [String: AnyObject]?
    var jsonArray: Array<AnyObject>?
    var image: UIImage?
    
    init(urlString: String, callback: (DataConnection)->Void, errorCallback: (DataConnection)->Void) {
        self.urlString = urlString
        self.callback = callback
        self.errorCallback = errorCallback
    }

    func start () {
        if (urlString == nil) { return }
        
        task?.cancel()
        task = nil

        println("Start connection on \(self.urlString)")
        let url: NSURL = NSURL(string: self.urlString)
        let session = NSURLSession.sharedSession()
        self.task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                // TODO: better error handling
                println("connection error: \(error.localizedDescription) for url: \(self.urlString)")
                self.errorCallback(self)
            } else {
                self.parseJSONData(data)
                self.callback(self)
            }
        })
        self.task!.resume()
    }
    
    func parseJSONData (data: NSData) {
        var jsonErrorOptional: NSError?
        let jsonOptional: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
        
        if let json = jsonOptional as? [String: AnyObject] {
            jsonDictionary = json
        } else if let json = jsonOptional as? Array<AnyObject> {
            jsonArray = json
        } else {
            self.image = UIImage(data: data)
        }
    }
}