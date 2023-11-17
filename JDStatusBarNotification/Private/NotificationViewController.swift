//
//  NotificationViewController.swift
//  JDStatusBarNotification
//
//  Created by Markus on 11/12/23.
//  Copyright © 2023 Markus. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationViewControllerDelegate: NSObject {
  func didDismissStatusBar()
}

class NotificationViewController: UIViewController, NotificationViewDelegate {
  typealias DismissCompletion = () -> Void

  private var forceDismissalOnTouchesEnded = false
  private var dismissTimer: Timer?
  private var dismissCompletionBlock: DismissCompletion?
  private var animator: JDSBNotificationAnimator
  private var panInitialY: CGFloat = 0.0
  private var panMaxY: CGFloat = 0.0

  private(set) var statusBarView: NotificationView
  weak var delegate: NotificationViewControllerDelegate?
  weak var jdsb_window: UIWindow?

  init() {
    let statusBarView = NotificationView()
    self.statusBarView = statusBarView
    self.animator = JDSBNotificationAnimator(statusBarView: statusBarView)
    super.init(nibName: nil, bundle: nil)

    statusBarView.delegate = self
    statusBarView.panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognized(_:)))
    statusBarView.longPressGestureRecognizer.addTarget(self, action: #selector(longPressGestureRecognized(_:)))

  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()
    view.backgroundColor = .clear
    view.addSubview(statusBarView)
  }

  // MARK: - Presentation

  @discardableResult
  func present(withStyle style: StatusBarNotificationStyle, completion: (() -> Void)?) -> NotificationView {
    let view = statusBarView

    // reset text, progress & activity
    view.title = nil
    view.subtitle = nil
    view.progressBarPercentage = 0.0
    view.displaysActivityIndicator = false

    // set style
    view.style = style

    // reset dismiss timer & completion
    dismissTimer?.invalidate()
    dismissTimer = nil
    dismissCompletionBlock = nil

    // animate in
    animator.animateIn(for: 0.4, completion: completion)

    return view
  }

  // MARK: - NotificationViewDelegate

  func didUpdateStyle() {
    relayoutWindowAndStatusBarView()
  }

  // MARK: - Layouting

  func relayoutWindowAndStatusBarView() {
    guard let jdsbWindow = jdsb_window else { return }

    // Match main window transform & frame
    if let window = DiscoveryHelper.discoverMainWindow(ignoring: jdsbWindow) {
      jdsbWindow.transform = window.transform
      jdsbWindow.frame = window.frame
    }

    // Resize statusBarView
    let view = statusBarView
    let safeAreaInset = jdsbWindow.safeAreaInsets.top
    let heightIncludingNavBar = safeAreaInset + contentHeight(for: view.style, with: safeAreaInset)
    view.transform = CGAffineTransform.identity
    view.frame = CGRect(x: 0, y: 0, width: jdsbWindow.frame.size.width, height: heightIncludingNavBar)

    // Relayout progress bar
    view.progressBarPercentage = view.progressBarPercentage
  }

  private func contentHeight(for style: StatusBarNotificationStyle, with safeAreaInset: CGFloat) -> CGFloat {
    switch style.backgroundStyle.backgroundType {
    case .fullWidth:
      if safeAreaInset >= 54.0 {
        return 38.66 // For dynamic island devices, this ensures the navbar separator stays visible
      } else {
        return 44.0 // Default navbar height
      }
    case .pill:
      var notchAdjustment: CGFloat = 0.0
      if safeAreaInset >= 54.0 {
        notchAdjustment = 0.0 // For the dynamic island, utilize the default positioning
      } else if safeAreaInset > 20.0 {
        notchAdjustment = -7.0 // This matches the positioning of a similar system notification
      } else {
        notchAdjustment = 3.0 // For no-notch devices, default to a minimum spacing
      }
      return style.backgroundStyle.pillStyle.height + style.backgroundStyle.pillStyle.topSpacing + notchAdjustment
    }
  }

  // MARK: - Pan Gesture

  private func canRubberBand(for type: StatusBarNotificationBackgroundType) -> Bool {
    switch type {
    case .fullWidth: return false
    case .pill: return true
    }
  }

  @objc private func panGestureRecognized(_ recognizer: UIPanGestureRecognizer) {
    guard recognizer.isEnabled else { return }

    switch recognizer.state {
    case .possible:
      break
    case .began:
      recognizer.setTranslation(.zero, in: statusBarView)
      panMaxY = 0.0
      panInitialY = recognizer.location(in: statusBarView).y
    case .changed:
      let translation = recognizer.translation(in: statusBarView)
      panMaxY = max(panMaxY, translation.y)

      // Rubber banding downwards + immediate upwards movement even after rubber banding
      let canRubberBand = canRubberBand(for: statusBarView.style.backgroundStyle.backgroundType)
      let rubberBandingLimit = 4.0
      let rubberBanding = (panMaxY > 0 && canRubberBand
        ? rubberBandingLimit * (1 + log10(panMaxY / rubberBandingLimit))
        : 0.0)
      let yPos = (translation.y <= panMaxY
        ? translation.y - panMaxY + rubberBanding
        : rubberBanding)
      statusBarView.transform = CGAffineTransform(translationX: 0, y: yPos)
    case .ended, .cancelled, .failed:
      let relativeMovement = (statusBarView.transform.ty / panInitialY)
      if !forceDismissalOnTouchesEnded && -relativeMovement < 0.25 {
        // Animate back in place
        UIView.animate(withDuration: 0.22) {
          self.statusBarView.transform = .identity
        }
      } else {
        // Dismiss
        forceDismiss()
      }
      @unknown default:
        break
    }
  }

  @objc private func longPressGestureRecognized(_ recognizer: UILongPressGestureRecognizer) {
    guard recognizer.isEnabled else { return }

    switch recognizer.state {
    case .ended:
      if forceDismissalOnTouchesEnded {
        forceDismiss()
      }
    default:
      break
    }
  }

  // MARK: - Dismissal

  func dismiss(withDuration duration: Double, afterDelay delay: TimeInterval, completion: DismissCompletion?) {
    dismissTimer?.invalidate()

    if delay == 0.0 {
      dismiss(withDuration: duration, completion: completion)
      return
    }

    dismissCompletionBlock = completion
    dismissTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
      guard let self else { return }
      let block = dismissCompletionBlock
      dismissCompletionBlock = nil
      dismiss(withDuration: duration, completion: block)
    }
  }

  private func dismiss(withDuration duration: Double, completion: DismissCompletion?) {
    dismissTimer?.invalidate()
    dismissTimer = nil

    if canDismiss() {
      statusBarView.panGestureRecognizer.isEnabled = false

      // Animate out
      animator.animateOut(for: duration) { [weak self] in
        self?.delegate?.didDismissStatusBar()
        completion?()
      }
    } else {
      dismissCompletionBlock = completion
      forceDismissalOnTouchesEnded = true
    }
  }

  private func forceDismiss() {
    let block = dismissCompletionBlock
    dismissCompletionBlock = nil
    dismiss(withDuration: 0.25, completion: block)
  }

  private func canDismiss() -> Bool {
    if statusBarView.style.canDismissDuringUserInteraction {
      return true // Allow dismissal during interaction
    }

    // Prevent dismissal during interaction
    if isGestureRecognizerActive(statusBarView.longPressGestureRecognizer)
      || isGestureRecognizerActive(statusBarView.panGestureRecognizer)
    {
      return false
    }

    // Allow otherwise
    return true
  }

  private func isGestureRecognizerActive(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    switch gestureRecognizer.state {
    case .began, .changed:
      return true
    default:
      return false
    }
  }

  // MARK: - Rotation handling

  func shouldAutorotate() -> Bool {
      return DiscoveryHelper.discoverMainViewController(ignoring: self)?.shouldAutorotate ?? false
  }

  func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
      return DiscoveryHelper.discoverMainViewController(ignoring: self)?.supportedInterfaceOrientations ?? .portrait
  }

  func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
      return DiscoveryHelper.discoverMainViewController(ignoring: self)?.preferredInterfaceOrientationForPresentation ?? .portrait
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)

      coordinator.animate(alongsideTransition: { [weak self] context in
          self?.relayoutWindowAndStatusBarView()
      }, completion: nil)
  }

  // MARK: - System StatusBar Management

  lazy var isStatusBarAppearanceEnabled: Bool = {
    if let value = Bundle.main.infoDictionary?["UIViewControllerBasedStatusBarAppearance"] as? NSNumber {
        return value.boolValue
    }
      return false
  }()

  override var preferredStatusBarStyle: UIStatusBarStyle {
      switch statusBarView.style.backgroundStyle.backgroundType {
      case .fullWidth:
          switch statusBarView.style.systemStatusBarStyle {
          case .defaultStyle:
              return defaultStatusBarStyle()
          case .lightContent:
              return .lightContent
          case .darkContent:
              return .darkContent
          }
      case .pill:
          // the pills should not change the system status bar
          return defaultStatusBarStyle()
      }
  }

  func defaultStatusBarStyle() -> UIStatusBarStyle {
      if isStatusBarAppearanceEnabled {
          return DiscoveryHelper.discoverMainViewController(ignoring: self)?.preferredStatusBarStyle ?? .default
      }
      return super.preferredStatusBarStyle
  }

  override var prefersStatusBarHidden: Bool {
      if isStatusBarAppearanceEnabled {
          return DiscoveryHelper.discoverMainViewController(ignoring: self)?.prefersStatusBarHidden ?? false
      }
      return super.prefersStatusBarHidden
  }

  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
      return .fade
  }

}
