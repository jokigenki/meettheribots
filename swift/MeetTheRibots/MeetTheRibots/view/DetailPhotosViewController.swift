//
//  DetailPhotosViewController.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 28/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class DetailPhotosViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource, DetailDataDisplay {
    
    var photos: [String]!
    var model: Model?
    
    required init (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        photos = [String]()
    }
    
    func setData(data: GridDataItem) {
        
        if let studio = data as? Studio {
            setPhotos(studio.photos)
        }
        collectionView?.backgroundColor = data.getHexColour().getDarker(0.8)
    }
    
    func getView() -> UIView {
        return view
    }
    
    func setPhotos (photos: [String]) {
        self.photos = photos
        self.collectionView!.reloadData()
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        let imageKey = photos[indexPath.item]
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(Events.DISPLAY_IMAGE.toRaw(), object: nil, userInfo: ["key": imageKey])
    }
    
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryboardIDs.PHOTO_CELL.toRaw(), forIndexPath: indexPath) as PhotoCellView
        
            let url = photos[indexPath.item]
            let image = model?.imageProxy.getImage(url)
            cell.imageView.image = image
            
            return cell
    }
}