//
//  JSONStudioParser.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation

class JSONStudioParser {
    
    var workingData: Dictionary<String, AnyObject>?
    var workingStudio: Studio!
    
    init () {
    }
    
    func parse (json: Dictionary<String, AnyObject>?) -> Studio {
        workingData = json
        workingStudio = Studio()
        var parser =
            parseAddressNumber()?.parseStreet()?.parseCity()?.parseCounty()?.parsePostcode()?.parseCountry()?.parsePhotos()
        
        if (parser == nil) { return Studio() }
        return workingStudio
    }
    
    func parseString(key: String) -> String? {
        if (workingData? == nil) { return nil }
        if (workingData![key] == nil) { return nil }
        var value = workingData![key]! as String
        return value
    }
    
    func parseStringArray(key: String) -> [String] {
        var target = [String]()
        if (workingData? == nil) { return target }
        if (workingData![key] == nil) { return target }
        var array = workingData![key]! as Array<AnyObject>
        
        for item in array {
            if let string = item as? String {
                target.append(string)
            }
        }
        
        return target
    }
    
    func parseAddressNumber () -> JSONStudioParser? {
        if let value = parseString(StudioFields.ADDRESS_NUMBER.toRaw()) {
            workingStudio?.addressNumber = value
            return self
        }
        
        return nil
    }
    
    func parseStreet () -> JSONStudioParser? {
        if let value = parseString(StudioFields.STREET.toRaw()) {
            workingStudio?.street = value
            return self
        }
        return nil
    }
    
    func parseCity () -> JSONStudioParser? {
        if let value = parseString(StudioFields.CITY.toRaw()) {
            workingStudio?.city = value
            return self
        }
        return nil
    }
    
    
    func parseCounty () -> JSONStudioParser? {
        if let value = parseString(StudioFields.COUNTY.toRaw()) {
            workingStudio?.county = value
            return self
        }
        return nil
    }
    
    func parsePostcode () -> JSONStudioParser? {
        if let value = parseString(StudioFields.POSTCODE.toRaw()) {
            workingStudio?.postcode = value
            return self
        }
        return nil
    }
    
    func parseCountry () -> JSONStudioParser? {
        if let value = parseString(StudioFields.COUNTRY.toRaw()) {
            workingStudio?.country = value
            return self
        }
        return nil
    }
    
    func parsePhotos () -> JSONStudioParser? {
        workingStudio?.photos = parseStringArray(StudioFields.PHOTOS.toRaw())
        return self
    }
}