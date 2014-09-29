//
//  DetailHeaderViewController.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 28/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class DetailHeaderViewController: UIViewController, DetailDataDisplay {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nicknameLabel: UITextView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    
    var updateObserver: NSObjectProtocol?
    var data: GridDataItem?
    
    @IBAction func onDismissPressed (AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(Events.CLOSE_DETAIL_VIEW.toRaw(), object: nil)
    }
    
    func setData (data: GridDataItem) {
        self.data = data
        
        nameLabel.text = data.getFullLabel()
        
        if let nickname = data.getNickName() {
            nicknameLabel.text = nickname
        } else {
            nicknameLabel.text = ""
        }
        
        if let email = data.getEmail() {
            emailLabel.text = email
        } else {
            emailLabel.text = ""
        }
        
        if let location = data.getLocation() {
            locationLabel.text = location
        } else {
            locationLabel.text = ""
        }
        
        let hexColour = data.getHexColour()
        view.backgroundColor = hexColour
        
        if data is Studio {
            imageView.backgroundColor = UIColor.clearColor()
        } else {
            imageView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func setImage (image: UIImage) {
        imageView.image = image
    }
    
    func getView() -> UIView {
        return view
    }
}