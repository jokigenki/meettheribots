//
//  MainGridViewController.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class MainGridViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let model: Model!
    
    // observers
    var modelObserver: NSObjectProtocol!
    var imageObserver: NSObjectProtocol!
    var detailView: DetailViewController!
    
    // MARK: - LifeCycle
    
    required init (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        model = Model()
    }
    
    deinit {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(modelObserver, name: Events.MODEL_UPDATED.toRaw(), object: nil)
        nc.removeObserver(imageObserver, name: Events.IMAGE_LOADED.toRaw(), object: nil)
        modelObserver = nil
        imageObserver = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nc = NSNotificationCenter.defaultCenter()
        let mq = NSOperationQueue.mainQueue()
        modelObserver = nc.addObserverForName(Events.MODEL_UPDATED.toRaw(), object: nil, queue: mq, usingBlock: { note in
            self.collectionView!.reloadData()
        })
        imageObserver = nc.addObserverForName(Events.IMAGE_LOADED.toRaw(), object: nil, queue: mq, usingBlock: { note in
            
            let userInfo = note.userInfo as [String: String]
            if let url = userInfo["key"] {
                self.onImageLoaded(url)
            }
        })
        
        initDetailView()
    }
    
    func initDetailView () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        detailView = storyboard.instantiateViewControllerWithIdentifier(StoryboardIDs.DETAIL_VIEW.toRaw()) as? DetailViewController;
        detailView.model = model
        view.addSubview(detailView.view)
        
        var frame = detailView.view.frame
        frame.origin.x = 1024
        detailView.view.frame = frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
            
            if indexPath.item == 0 {
                detailView.displayStudio()
            } else {
                detailView.displayTeamMember(indexPath.item - 1)
            }
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            if (model.team == nil) { return 0 }
            return model.team!.getNumberOfMembers() + 1
    }
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryboardIDs.MAIN_GRID_CELL.toRaw(), forIndexPath: indexPath) as GridCellView
            
            if indexPath.item == 0 {
                initCellForStudio(cell)
            } else {
                initCellForTeamMember(cell, index: indexPath.item - 1)
            }
            return cell
    }
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            
            let reusableView:GridViewHeader = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: StoryboardIDs.HEADER_VIEW.toRaw(), forIndexPath: indexPath) as GridViewHeader
            
            return reusableView
    }
    
    func initCellForStudio (cell: GridCellView) {
        if model.studio != nil {
            cell.setData(model.studio!)
            cell.imageView.image = UIImage(named: "logo_small_blue")
        }
    }
    
    func initCellForTeamMember (cell: GridCellView, index: Int) {
        if let teamMember = model.team?.getMemberForIndex(index) {
            cell.setData(teamMember)
            addImageForCell(cell, data: teamMember)
        }
    }
    
    func addImageForCell (cell: GridCellView, data: GridDataItem) {
        cell.imageView.image = UIImage(named: "placeholder")
        if let imageURL = data.getImageURL() {
            if let image = model.imageProxy.getImage(imageURL) {
                cell.imageView.image = image
            }
        }
    }
    
    func onImageLoaded (url: String) {
        // TODO: it's wasteful to reload everything just to replace the image
        // find the cell using the url in the note, and update just that cell
        self.collectionView!.reloadData()
    }
}