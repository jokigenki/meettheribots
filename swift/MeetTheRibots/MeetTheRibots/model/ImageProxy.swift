//
//  ImageProxy.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 28/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class ImageProxy {
    
    var imageCache = [String: UIImage]()
    var connectionCache = [String: DataConnection]()
    func getImageFromCache (key: String) -> UIImage? {
        return imageCache[key]
    }
    
    func addImageToCache (key: String, image: UIImage) {
        imageCache[key] = image
    }
    
    func getImage (url: String) -> UIImage? {
        
        if let cachedImage = getImageFromCache(url) {
            return cachedImage
        }
        else if let localImage = getLocalImage(url) {
            addImageToCache(url, image: localImage)
            return localImage
        }
        else if let cachedConnection  = connectionCache[url] {
            // image is already loading, so wait
        }
        else {
            let connection = DataConnection(urlString: url, onGotImage, onImageError)
            connection.start()
            connectionCache[url] = connection
        }
        
        return nil
    }
    
    func getLocalImage (url: String) -> UIImage? {
        var comps = url.componentsSeparatedByString("local://")
        if (comps.count > 1) { return UIImage(named:comps[1]) }
        return nil
    }
    
    func onGotImage (connection: DataConnection) {
        connectionCache.removeValueForKey(connection.urlString)
        
        if let image = connection.image {
            addImageToCache(connection.urlString, image: image)
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(Events.IMAGE_LOADED.toRaw(), object: nil, userInfo: ["key": connection.urlString])
        }
    }
    
    func onImageError (connection: DataConnection) {
        connectionCache.removeValueForKey(connection.urlString)
    }
}