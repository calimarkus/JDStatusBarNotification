//
//  StatusBarNotification.swift
//  JDStatusBarNotificationExample
//
//  Created by Markus on 22.06.14.
//  Copyright (c) 2014 Markus. All rights reserved.
//

import Foundation
import UIKit

@objc
public class StatusBarNotification : NSObject
{
    var dismissTimer: Timer? = nil
    var progress: Double = 0.0

    var activeStyle: StatusBarStyle
    var defaultStyle: StatusBarStyle
    var userStyles: [String: StatusBarStyle] = [:]

    var overlayWindow: UIWindow? = nil
    var progressView: UIView? = nil
    var topBar: StatusBarView? = nil

    // ---------------------------------- Singleton ------------------------------------------ //

    class func sharedInstance() -> StatusBarNotification
    {
        enum Shared
        {
            static let instance = StatusBarNotification()
        }
        return Shared.instance
    }

    // -------------------------------- Class methods ---------------------------------------- //

    // Presentation
    @objc
    public class func showWithStatus(_ status: String) -> StatusBarView
    {
        return showWithStatus(status, dismissAfter: nil, styleName: nil)
    }

    public class func showWithStatus(_ status: String, dismissAfter: TimeInterval? = nil, styleName: String? = nil) -> StatusBarView
    {
        return StatusBarView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
    }

    // Dismissal
    public class func dismiss()
    {
        dismissAnimated(animated: true)
    }

    public class func dismissAnimated(animated: Bool)
    {
        sharedInstance().dismissAnimated(animated: true)
    }

    public class func dismissAfter(delay: TimeInterval)
    {
        sharedInstance().setDismissTimer(interval: delay)
    }

    // Styles
    public class func setDefaultStyle(prepare: (_ style: StatusBarStyle) -> StatusBarStyle) {}
    public class func addStyleNamed(identifier: String, prepare: (_ style: StatusBarStyle) -> StatusBarStyle) {}

    // progress & activity
    public class func showProgress(progress: Float) {}
    public class func showActivityIndicator(show: Bool, indicatorStyle: UIActivityIndicatorView.Style) {}

    // State
    public class func isVisible() -> Bool
    {
        return false
    }

    // ---------------------------------- Implementation ------------------------------------ //

    override init()
    {
        defaultStyle = StatusBarStyle.statusBarStyleForPreset(.Default)
        activeStyle = defaultStyle
        for styleName in StatusBarStyle.allDefaultBarStyles() {
            userStyles[styleName.rawValue] = StatusBarStyle.statusBarStyleForPreset(styleName)
        }
        super.init()

        // register for orientation changes
        weak var weakself = self
        NotificationCenter.default.addObserver(forName: UIApplication.willChangeStatusBarFrameNotification,
                                               object: nil,
                                               queue: nil)
        { notif in
            weakself?.willChangeStatusBarFrame(notification: notif)
        }
    }

    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }

    // dismissing
    func setDismissTimer(interval: TimeInterval)
    {
        let fireDate = Date(timeIntervalSinceNow: interval)

        dismissTimer?.invalidate()
        let newTimer = Timer(fire: fireDate, interval: 0, repeats: false, block: { _ in
            self.dismissAnimated(animated: true)
        })
        RunLoop.current.add(newTimer, forMode: .common)
        dismissTimer = newTimer
    }

    func dismissAnimated(animated: Bool)
    {
        dismissTimer?.invalidate()
        dismissTimer = nil

        guard let overlayWindow = self.overlayWindow else { return }
        guard let topBar = self.topBar else { return }

        // check animation type
        let animationsEnabled = (activeStyle.animationType != StatusBarStyle.AnimationType.None)
        let shouldAnimate = animated && animationsEnabled

        // animate out
        UIView.animate(withDuration: shouldAnimate ? 0.4 : 0.0, animations: {
            if self.activeStyle.animationType == StatusBarStyle.AnimationType.Fade
            {
                topBar.alpha = 0.0
            }
            else
            {
                topBar.transform = CGAffineTransform(translationX: 0, y: -topBar.frame.size.height)
            }
        }, completion: { _ in
            overlayWindow.removeFromSuperview()
            overlayWindow.isHidden = true
            overlayWindow.rootViewController = nil
            self.overlayWindow = nil
            self.progressView = nil
            self.topBar = nil
        })
    }

    func addStyleNamed(identifier: String, prepare: (_ style: StatusBarStyle) -> StatusBarStyle) -> String
    {
        userStyles[identifier] = prepare(defaultStyle)
        return identifier
    }

    // Rotation
    func updateWindowTransform()
    {
        guard let overlayWindow = overlayWindow else { return }

        let window = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first
        if let w = window
        {
            overlayWindow.transform = w.transform
            overlayWindow.frame = w.frame
        }
    }

    func updateTopBarFrameWithStatusBarFrame(rect: CGRect)
    {
        guard let topBar = topBar else { return }

        let width: CGFloat = max(rect.size.width, rect.size.height)
        let height: CGFloat = min(rect.size.width, rect.size.height)

        // on ios7 fix position, if statusBar has double height
        var yPos: CGFloat = 0
        if Float(UIDevice.current.systemVersion) ?? 0.0 >= 7.0, height > 20.0
        {
            yPos = -height / 2.0
        }

        topBar.frame = CGRect(x: 0, y: yPos, width: width, height: height)
    }

    func willChangeStatusBarFrame(notification: Notification)
    {
        let barFrameValue: NSValue = notification.userInfo?[UIApplication.statusBarFrameUserInfoKey] as! NSValue
        UIView.animate(withDuration: 0.5)
        {
            self.updateWindowTransform()
            self.updateTopBarFrameWithStatusBarFrame(rect: barFrameValue.cgRectValue)

            // update progress with current value
            let progress = self.progress
            self.progress = progress
        }
    }
}
