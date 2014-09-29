//
//  DetailTwitterViewController.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 28/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class DetailTwitterViewController: UIViewController, DetailDataDisplay {
    
    @IBOutlet var twitterNameView: UILabel!
    @IBOutlet var tweetView: UITextView!
    
    func setData (data: GridDataItem) {
        
        if let twitter = data.getTwitter() {
            twitterNameView.text = getTwitterName(twitter)
            populateTweets(twitter)
        } else {
            twitterNameView.text = "no twitter!"
            tweetView.text = ""
        }
        
        view.backgroundColor = data.getHexColour().getDarker(0.7)
    }
    
    func getView() -> UIView {
        return view
    }
    
    func getTwitterName (twitter: String) -> String{
        if twitter.componentsSeparatedByString("@").count == 1 { return "@\(twitter)" }
        return twitter
    }
    
    func populateTweets (username: String) {
        tweetView.text = ""
        // TODO: populate tweets from timeline, requires auth
    }
}