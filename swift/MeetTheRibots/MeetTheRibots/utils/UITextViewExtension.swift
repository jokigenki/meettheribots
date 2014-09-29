//
//  UITextViewExtension.swift
//  MeetTheRibots
//
//  Created by Owen Bennett on 29/09/2014.
//  Copyright (c) 2014 Ribot. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {

    // setting line spacing while retaining colour and size
    func setTextWithLineSpacing (string: String, spacing: CGFloat) {
        let colour = textColor
        let size = font.pointSize
        
        var style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        let attributes = [NSParagraphStyleAttributeName : style]
        attributedText = NSAttributedString(string: string, attributes:attributes)
        var sizedFont = font.fontWithSize(size)
        font = sizedFont
        textColor = colour
    }
}