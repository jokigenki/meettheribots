//
//  GridCell.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 27/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

class GridCellView: UICollectionViewCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var data: GridDataItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData (data: GridDataItem) {
        self.data = data
        
        label.text = data.getShortLabel()
        label.backgroundColor = data.getHexColour()
    }
}