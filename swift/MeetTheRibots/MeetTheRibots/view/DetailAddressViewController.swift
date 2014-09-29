//
//  DetailAddressViewController.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 28/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailAddressViewController: UIViewController, DetailDataDisplay {
    
    @IBOutlet var addressView: UITextView!
    @IBOutlet var mapView: MKMapView!
    
    var geoCoder: CLGeocoder?
    
    func setData (data: GridDataItem) {
        
        if let studio = data as? Studio {
            populateText(studio)
            doMap(studio)
        } else {
            addressView.text = ""
        }
        
        view.backgroundColor = data.getHexColour().getDarker(0.9)
    }
    
    func getView() -> UIView {
        return view
    }
    
    func populateText (studio: Studio) {
        var addressText = "\(studio.addressNumber) \(studio.street)\r\(studio.city)\r\(studio.postcode)\r\(studio.county)\r\(studio.country)"
        addressView.setTextWithLineSpacing(addressText, spacing: 14)
    }
    
    func doMap (studio: Studio) {
        
        var lm = CLLocationManager()
        lm.requestAlwaysAuthorization()
        
        // init the map with a sensible zoom amount. coords are for center of brighton
        if (geoCoder == nil) { geoCoder = CLGeocoder() }
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.837418,longitude: -0.1061897), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: false)
        
        // find the location, and zoom into it
        geoCoder!.geocodeAddressString(studio.postcode, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                let mkPlacemark = MKPlacemark(placemark: placemark)
                var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mkPlacemark.coordinate, fromEyeCoordinate: mkPlacemark.coordinate, eyeAltitude: 2000)
                self.mapView.setCamera(mapCamera, animated: true)
                self.mapView.addAnnotation(mkPlacemark)
            }
        })
        
    }
}
