//
//  DetailDataDisplay.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 28/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

protocol DetailDataDisplay {
    
    func setData (data: GridDataItem)
    func getView () -> UIView
}