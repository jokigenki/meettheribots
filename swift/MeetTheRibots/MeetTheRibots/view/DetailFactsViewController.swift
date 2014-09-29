//
//  DetailFactsViewController.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 28/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class DetailFactsViewController: UIViewController, DetailDataDisplay {
    
    @IBOutlet var factsView: UITextView!
    
    func setData (data: GridDataItem) {
        
        if let member = data as? TeamMember {
            populateFactsView(member)
        } else {
            factsView.text = ""
        }
        
        view.backgroundColor = data.getHexColour().getDarker(0.8)
    }
    
    func populateFactsView (member: TeamMember) {
        
        var factsText = ""
        if let role = member.role {
            factsText = "Role: \(role)\r"
        }
        if let favSweet = member.favSweet {
            factsText += "Favourite Sweet: \(favSweet) \u{1F36C}\r"
        }
        if let favSeason = member.favSeason {
            let season = getSeason(favSeason.lowercaseString)
            factsText += "Favourite Season: \(favSeason)\(season)\r"
        }
        
        factsView.setTextWithLineSpacing(factsText, spacing: 16)
    }
    
    func getSeason (season: String) ->String {
        switch (season) {
            case "spring":
                return " \u{1F33C}"
            case "summer":
                return " \u{2600}"
            case "autumn":
                return " \u{1F342}"
            case "winter":
                return " \u{2744}"
        default:
            return ""
        }
    }
    
    func getView() -> UIView {
        return view
    }
}