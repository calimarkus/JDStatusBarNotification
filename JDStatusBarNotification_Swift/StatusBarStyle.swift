//
//  JDStatusBarStyle.swift
//  JDStatusBarNotification
//
//  Created by Markus on 04.06.14.
//  Copyright (c) 2014 Markus. All rights reserved.
//

import Foundation
import UIKit

class StatusBarStyle {
    
    enum BarStylePreset:String {
        case Error   = "JDStatusBarStyleError"    // red on white
        case Warning = "JDStatusBarStyleWarning"  // black on yellow
        case Success = "JDStatusBarStyleSuccess"  // green on light grey
        case Matrix  = "JDStatusBarStyleMatrix"   // green on black with monospace font
        case Default = "JDStatusBarStyleDefault"  // black on white
        case Dark    = "JDStatusBarStyleDark"     // bright grey on black
    }
    
    enum AnimationType {
        case None    /// Notification won't animate
        case Move    /// Notification will move in from the top, and move out again to the top
        case Bounce  /// Notification will fall down from the top and bounce a little bit
        case Fade    /// Notification will fade in and fade out
    }
    
    enum ProgressBarPosition {
        case Bottom /// progress bar will be at the bottom of the status bar
        case Center /// progress bar will be at the center of the status bar
        case Top    /// progress bar will be at the top of the status bar
        case Below  /// progress bar will be below the status bar (the prograss bar won't move with the statusbar in this case)
        case NavBar /// progress bar will be below the navigation bar (the prograss bar won't move with the statusbar in this case)
    }
    
    /// The background color of the notification bar
    var barColor :UIColor
    
    /// The text color of the notification label
    var textColor :UIColor
    
    /// The text shadow of the notification label
    var textShadow :NSShadow?
    
    /// The font of the notification label
    var font :UIFont
    
    /// A correction of the vertical label position in points.
    var textVerticalPositionAdjustment :Double
    
    /// The animation, that is used to present the notification. Default: Move
    var animationType :AnimationType
    
    /// The background color of the progress bar (on top of the notification bar)
    var progressBarColor :UIColor
    
    /// The height of the progress bar.
    var progressBarHeight :Double
    
    /// The position of the progress bar. Default: Bottom
    var progressBarPosition :ProgressBarPosition
    
    init() {
        barColor = UIColor.whiteColor()
        textColor = UIColor.grayColor()
        font = UIFont.systemFontOfSize(12)
        textVerticalPositionAdjustment = 0.0
        animationType = .Move
        progressBarColor = UIColor.greenColor()
        progressBarHeight = 1.0
        progressBarPosition = .Bottom
    }
    
    class func allDefaultBarStyles() -> Array<BarStylePreset> {
        return [.Error, .Warning, .Success, .Matrix, .Dark];
    }
    
    class func statusBarStyleForPreset(presetName: BarStylePreset) -> StatusBarStyle {

        let style = StatusBarStyle()
        
        switch presetName {
        case .Error:
            style.barColor = UIColor(red: 0.588, green: 0.118, blue: 0.0, alpha: 1.0)
            style.textColor = UIColor.whiteColor()
            style.progressBarColor = UIColor.redColor()
            style.progressBarHeight = 2.0;
        case .Warning:
            style.barColor = UIColor(red: 0.9, green: 0.734, blue: 0.034, alpha: 1.0)
            style.textColor = UIColor.darkGrayColor()
            style.progressBarColor = style.textColor
            style.progressBarHeight = 2.0;
        case .Success:
            style.barColor = UIColor(red: 0.588, green: 0.797, blue: 0.0, alpha: 1.0)
            style.textColor = UIColor.whiteColor()
            style.progressBarColor = UIColor(red: 0.106, green: 0.594, blue: 0.319, alpha: 1.0)
            style.progressBarHeight = 1.0+1.0/Double(UIScreen.mainScreen().scale);
        case .Dark:
            style.barColor = UIColor(red: 0.05, green: 0.078, blue: 0.12, alpha: 1.0)
            style.textColor = UIColor(white:0.95, alpha:1.0)
            style.progressBarHeight = 1.0+1.0/Double(UIScreen.mainScreen().scale);
        case .Matrix:
            style.barColor = UIColor.blackColor()
            style.textColor = UIColor.greenColor()
            style.font = UIFont(name:"Courier-Bold", size:14.0)
            style.progressBarColor = UIColor.greenColor();
            style.progressBarHeight = 2.0;
        default:
            break
        }
        
        return style;
    }
        
}


