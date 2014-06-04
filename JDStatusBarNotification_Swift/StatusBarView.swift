//
//  StatusBarView.swift
//  JDStatusBarNotificationExample
//
//  Created by Markus on 04.06.14.
//  Copyright (c) 2014 Markus. All rights reserved.
//

import Foundation
import UIKit


class StatusBarView : UIView {
    
    var textLabel :UILabel
    var activityIndicatorView :UIActivityIndicatorView
    
    var textVerticalPositionAdjustment :CGFloat {
    didSet{ self.setNeedsLayout() }
    }
    
    init(frame: CGRect) {
        textLabel = UILabel()
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        textVerticalPositionAdjustment = 0.0;
        super.init(frame: frame)
        setupLabel()
        setupActivityIndicator()
    }

    func setupLabel() {
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.baselineAdjustment = .AlignCenters
        textLabel.textAlignment = .Center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.clipsToBounds = true
        addSubview(textLabel)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.transform = CGAffineTransformMakeScale(0.7, 0.7)
        activityIndicatorView.hidesWhenStopped = true
        addSubview(activityIndicatorView)
    }
    
    override func layoutSubviews() {
        
        // label
        var labelRect = bounds
        labelRect.origin.x = 0
        labelRect.origin.y = 1+textVerticalPositionAdjustment
        labelRect.size.height -= 1
        self.textLabel.frame = labelRect
        
        // activity indicator
        if !activityIndicatorView.hidden {
            let textSize = currentTextSize()
            let availableSpaceHalf = ((self.bounds.size.width - textSize.width)/2.0)
            var indicatorFrame = activityIndicatorView.frame
            indicatorFrame.origin.x = availableSpaceHalf - indicatorFrame.size.width - 8.0
            indicatorFrame.origin.y = (1+(self.bounds.size.height - indicatorFrame.size.height)/2.0)
            activityIndicatorView.frame = CGRectIntegral(indicatorFrame)
        }
    }
    
    func currentTextSize() -> CGSize {
        var attributes = [NSFontAttributeName:textLabel.font]
        return textLabel.text.bridgeToObjectiveC().sizeWithAttributes(attributes)
    }
}
