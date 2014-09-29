//
//  GridDataItem.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

protocol GridDataItem {
    func getShortLabel () -> String
    func getFullLabel () -> String
    func getEmail () -> String?
    func getNickName () -> String?
    func getImageURL () -> String?
    func getHexColour () -> UIColor
    func getTwitter () -> String?
    func getLocation () -> String?
}