//
//  ImageViewController.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 29/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController: UIViewController {
    
    var image: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (image != nil) {
            imageView.image = image
        }
    }
    
    @IBAction func onDismissPressed (AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(Events.CLOSE_IMAGE_VIEW.toRaw(), object: nil)
        
        dismissViewControllerAnimated(true, completion: {})
    }
    
    func setImage ( image: UIImage) {
        if (imageView == nil) { self.image = image }
        else { imageView.image = image }
    }
}