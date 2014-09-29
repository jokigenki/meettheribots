//
//  ModelStub.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation

class ModelStub: Model {
    
    var initDataCount = 0
    var initProxiesCount = 0
    var initObserversCount = 0
    var dispatchModelUpdatedCount = 0
    
    override func initProxies() {
        initProxiesCount++
        super.initProxies()
    }
    
    override func initData() {
        initDataCount++
        super.initData()
    }
    
    override func initObservers() {
        initObserversCount++
        super.initObservers()
    }
    
    override func dispatchModelUpdated() {
        dispatchModelUpdatedCount++
        super.dispatchModelUpdated()
    }
}