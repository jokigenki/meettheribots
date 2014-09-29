//
//  DetailViewController.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 29/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var model: Model!
    
    // observers
    var modelObserver: NSObjectProtocol!
    var imageObserver: NSObjectProtocol!
    var detailDataUpdateObserver: NSObjectProtocol?
    var detailDismissObserver: NSObjectProtocol?
    
    // data
    var currentData: GridDataItem?
    var currentDisplayViews: [DetailDataDisplay]?
    var teamMemberDisplayViews: [DetailDataDisplay]?
    var studioDisplayViews: [DetailDataDisplay]?
    
    // details
    var detailScrollView: UIScrollView?
    var detailHeader: DetailHeaderViewController?
    var detailDescription: DetailDescriptionViewController?
    var detailFacts: DetailFactsViewController?
    var detailTwitter: DetailTwitterViewController?
    var detailAddress: DetailAddressViewController?
    var detailPhotos: DetailPhotosViewController?
    
    required init (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        initDetailViews()
    }
    
    func initImageObserver (callback: (url: String)->Void) {
        let nc = NSNotificationCenter.defaultCenter()
        let mq = NSOperationQueue.mainQueue()
        imageObserver = nc.addObserverForName(Events.IMAGE_LOADED.toRaw(), object: nil, queue: mq, usingBlock: { note in
            
            let userInfo = note.userInfo as [String: String]
            if let url = userInfo["key"] {
                callback(url: url)
            }
        })
    }
    
    func removeImageObserver () {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(imageObserver, name: Events.IMAGE_LOADED.toRaw(), object: nil)
    }
    
    func initDetailViews () {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        
        if (detailScrollView == nil) {
            detailScrollView = UIScrollView()
            var frame = self.view.frame
            frame.origin.x = 0
            frame.origin.y = 0
            detailScrollView!.frame = frame
            detailScrollView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleTopMargin
            detailScrollView!.contentSize = CGSize(width: self.view.frame.width, height: 1024)
            self.view.addSubview(detailScrollView!)
        }
        
        if (detailHeader == nil) {
            detailHeader = storyboard.instantiateViewControllerWithIdentifier(StoryboardIDs.DETAIL_HEADER.toRaw()) as? DetailHeaderViewController;
            addView(detailHeader!.view, startX: 1024, startY: 0, height: 374)
        }
        
        if (detailDescription == nil) {
            detailDescription = storyboard.instantiateViewControllerWithIdentifier(StoryboardIDs.DETAIL_DESCRIPTION.toRaw()) as? DetailDescriptionViewController;
            addView(detailDescription!.view, startX: 1024, startY: 374, height: 260)
        }
        
        if (detailFacts == nil) {
            detailFacts = storyboard.instantiateViewControllerWithIdentifier(StoryboardIDs.DETAIL_FACTS.toRaw()) as?DetailFactsViewController;
            addView(detailFacts!.view, startX: 1024, startY: 634, height: 195)
        }
        
        if (detailAddress == nil) {
            detailAddress = storyboard.instantiateViewControllerWithIdentifier(StoryboardIDs.DETAIL_ADDRESS.toRaw()) as?DetailAddressViewController;
            addView(detailAddress!.view, startX: 1024, startY:
                374, height: 260)
        }
        
        if (detailPhotos == nil) {
            detailPhotos = storyboard.instantiateViewControllerWithIdentifier(StoryboardIDs.DETAIL_PHOTOS.toRaw()) as?DetailPhotosViewController;
            let frame = detailAddress!.view.frame
            addView(detailPhotos!.view, startX: 1024, startY: 634, height: 195)
            detailPhotos!.model = model
        }
        
        if (detailTwitter == nil) {
            detailTwitter = storyboard.instantiateViewControllerWithIdentifier(StoryboardIDs.DETAIL_TWITTER.toRaw()) as?DetailTwitterViewController;
            addView(detailTwitter!.view, startX: 1024, startY: 829, height: 195)
        }
        
        teamMemberDisplayViews = [detailHeader!, detailDescription!, detailFacts!, detailTwitter!]
        studioDisplayViews = [detailHeader!, detailAddress!, detailPhotos!, detailTwitter!]
    }
    
    func addView (view: UIView, startX: CGFloat, startY: CGFloat, height: CGFloat) {
        var frame = view.frame
        frame.origin.x = startX
        frame.origin.y = startY
        frame.size.height = height
        view.frame = frame
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth // prevent view from scaling to height
        
        self.detailScrollView!.addSubview(view)
    }
    
    // MARK: - display methods
    func displayStudio() {
        initImageObserver(handleStudioImage)
        displayViews(model.studio!, displays: studioDisplayViews!, dismissStudio)
    }
    
    func displayTeamMember (index: Int) {
        if let teamMember = model.team!.getMemberForIndex(index) {
            
            initImageObserver(handleTeamMemberImage)
            
            displayViews(teamMember, displays: teamMemberDisplayViews!, dismissTeamMember)
            
            model.apiProxy.getTeamMember(teamMember.id)
            
            let nc = NSNotificationCenter.defaultCenter()
            let mq = NSOperationQueue.mainQueue()
            
            detailDataUpdateObserver = nc.addObserverForName(Events.GOT_TEAM_MEMBER.toRaw(), object: nil, queue: mq, usingBlock: {note in
                let userInfo = note.userInfo as [String: TeamMember!]
                if let teamMember = userInfo["\(TeamMember.self)"] {
                    self.updateDetailViewData(teamMember)
                }
            })
        }
    }
    
    func removeDetailDataObserver() {
        if (detailDataUpdateObserver != nil) {
            let nc = NSNotificationCenter.defaultCenter()
            nc.removeObserver(detailDataUpdateObserver!, name: Events.GOT_TEAM_MEMBER.toRaw(), object: nil)
            detailDataUpdateObserver = nil
        }
    }
    
    func dismissStudio () {
        hideViews(studioDisplayViews!)
    }
    
    func dismissTeamMember () {
        hideViews(teamMemberDisplayViews!)
    }
    
    func displayViews (data: GridDataItem, displays: [DetailDataDisplay], dismissCallback: () ->Void) {
        
        if (detailHeader == nil) { initDetailViews() }
        if (currentDisplayViews != nil) { return }
        currentDisplayViews = displays
        currentData = data
        
        detailDismissObserver = addDetailDismissObserver(dismissCallback)
        animateViews(displays, fromX: self.view.frame.width, toX: 0, animIn: true)
        
        updateDetailViewData(data)
        
        setHeaderImage(data)
    }
    
    func setHeaderImage (data: GridDataItem) {
        
        var image = UIImage(named:"placeholder")
        if data is Studio {
            image = UIImage(named:"logo_small_white")
        } else {
            if let imageURL = data.getImageURL() {
                if let cachedImage = model.imageProxy.getImage(imageURL) {
                    image = cachedImage
                }
            }
        }
        
        detailHeader!.setImage(image)
    }
    
    func updateDetailViewData (data: GridDataItem) {
        
        if (currentDisplayViews == nil) { return }
        for display in currentDisplayViews! {
            display.setData(data)
        }
        
        removeDetailDataObserver()
    }
    
    func hideViews (displays: [DetailDataDisplay]) {
        
        removeImageObserver()
        removeDetailDataObserver()
        currentDisplayViews = nil
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(detailDismissObserver!, name: Events.CLOSE_DETAIL_VIEW.toRaw(), object: nil)
        detailDismissObserver = nil
        
        animateViews(displays, fromX: -1, toX: 1024, animIn: false)
    }
    
    func addDetailDismissObserver (callback: ()->Void) -> NSObjectProtocol {
        let nc = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        let observer = nc.addObserverForName(Events.CLOSE_DETAIL_VIEW.toRaw(), object: nil, queue: mainQueue, usingBlock: {note in
            callback()
        })
        
        return observer
    }
    
    func animateViews (displays: [DetailDataDisplay], fromX: CGFloat, toX:CGFloat, animIn: Bool) {
        
        var startDuration: NSTimeInterval = animIn ? 0.5 : 0.2
        
        animateView(self.view, fromX: fromX, toX: toX, duration: startDuration, delay: 0.5 - startDuration)
        
        for display in displays {
            let delay: NSTimeInterval = 0.5 - startDuration
            animateView(display.getView(), fromX: fromX, toX: toX, duration: startDuration, delay: delay)
            startDuration += animIn ? -0.1 : 0.1
        }
    }
    
    func animateView (view: UIView, fromX: CGFloat, toX: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval) {
        
        if (fromX > -1) {
            var frame = view.frame
            frame.origin.x = fromX
            view.frame = frame
        }
        
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            var frame = view.frame
            frame.origin.x = toX
            view.frame = frame
            }, completion: { finished in
                // animation complete
        })
    }
    
    func handleStudioImage (url: String) {
        detailPhotos?.collectionView?.reloadData()
    }
    
    func handleTeamMemberImage (url: String) {
        if let imageURL = currentData?.getImageURL() {
            if let image = model!.imageProxy.getImage(imageURL) {
                detailHeader!.setImage(image)
            }
        }
    }
}