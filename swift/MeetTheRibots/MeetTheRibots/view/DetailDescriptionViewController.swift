//
//  DetailDescriptionViewController.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 28/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class DetailDescriptionViewController: UIViewController, DetailDataDisplay {
    
    @IBOutlet var descriptionView: UITextView!
    
    func setData (data: GridDataItem) {
        
        if let member = data as? TeamMember {
            populateText (member.description)
        } else {
            descriptionView.text = ""
        }
        
        view.backgroundColor = data.getHexColour().getDarker(0.9)
    }
    
    func getView() -> UIView {
        return view
    }
    
    func populateText (description: String?) {
        if description == nil { descriptionView.text = "" }
        else {
            descriptionView.setTextWithLineSpacing(description!, spacing: 14)
        }
    }
}