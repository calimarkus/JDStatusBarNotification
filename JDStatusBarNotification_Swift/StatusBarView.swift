//
//  StatusBarView.swift
//  JDStatusBarNotificationExample
//
//  Created by Markus on 04.06.14.
//  Copyright (c) 2014 Markus. All rights reserved.
//

import Foundation
import UIKit

@objc
public class StatusBarView: UIView {
    public var textLabel: UILabel
    public var activityIndicatorView: UIActivityIndicatorView

    public var textVerticalPositionAdjustment: CGFloat {
        didSet { self.setNeedsLayout() }
    }

    override init(frame: CGRect) {
        textLabel = UILabel()
        activityIndicatorView = .init(style: .medium)
        textVerticalPositionAdjustment = 0.0
        super.init(frame: frame)
        setupLabel()
        setupActivityIndicator()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLabel() {
        textLabel.backgroundColor = .clear
        textLabel.baselineAdjustment = .alignCenters
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.clipsToBounds = true
        addSubview(textLabel)
    }

    func setupActivityIndicator() {
        activityIndicatorView.transform = .init(scaleX: 0.7, y: 0.7)
        activityIndicatorView.hidesWhenStopped = true
        addSubview(activityIndicatorView)
    }

    public override func layoutSubviews() {
        // label
        var labelRect = bounds
        labelRect.origin.x = 0
        labelRect.origin.y = 1+textVerticalPositionAdjustment
        labelRect.size.height -= 1
        textLabel.frame = labelRect

        // activity indicator
        if !activityIndicatorView.isHidden {
            let textSize = currentTextSize()
            let availableSpaceHalf = ((bounds.size.width - textSize.width)/2.0)
            var indicatorFrame = activityIndicatorView.frame
            indicatorFrame.origin.x = availableSpaceHalf - indicatorFrame.size.width - 8.0
            indicatorFrame.origin.y = (1+(bounds.size.height - indicatorFrame.size.height)/2.0)
            activityIndicatorView.frame = indicatorFrame.integral
        }
    }

    func currentTextSize() -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [.font: textLabel.font!]
        return textLabel.text?.size(withAttributes: attributes) ?? .zero
    }
}
