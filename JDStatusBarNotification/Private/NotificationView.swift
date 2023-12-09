//
//

import Foundation
import UIKit

protocol NotificationViewDelegate: AnyObject {
  func didUpdateStyle()
}

class NotificationView: UIView, UIGestureRecognizerDelegate, StylableView {
  weak var delegate: NotificationViewDelegate?

  let longPressGestureRecognizer = UILongPressGestureRecognizer()
  let panGestureRecognizer = UIPanGestureRecognizer()

  // Private
  let expectedSubviewTag = 12321
  var contentView = UIView()
  var pillView = UIView()
  var titleLabel = UILabel()
  var subtitleLabel = UILabel()
  var activityIndicatorView: UIActivityIndicatorView? = nil
  var progressView: UIView? = nil

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View setup

  private func setupView() {
    titleLabel.tag = expectedSubviewTag
    titleLabel.backgroundColor = .clear
    titleLabel.baselineAdjustment = .alignCenters
    titleLabel.adjustsFontSizeToFitWidth = true

#if JDSB_LAYOUT_DEBUGGING
    titleLabel.layer.borderColor = UIColor.darkGray.cgColor
    titleLabel.layer.borderWidth = 1.0
#endif

    subtitleLabel.tag = expectedSubviewTag
    subtitleLabel.backgroundColor = .clear
    subtitleLabel.baselineAdjustment = .alignCenters
    subtitleLabel.adjustsFontSizeToFitWidth = true

#if JDSB_LAYOUT_DEBUGGING
    subtitleLabel.layer.borderColor = UIColor.darkGray.cgColor;
    subtitleLabel.layer.borderWidth = 1.0;
#endif

    pillView.backgroundColor = .clear
    pillView.tag = expectedSubviewTag

    contentView.tag = expectedSubviewTag

    longPressGestureRecognizer.minimumPressDuration = 0.0
    longPressGestureRecognizer.isEnabled = true
    longPressGestureRecognizer.delegate = self
    addGestureRecognizer(longPressGestureRecognizer)

    panGestureRecognizer.isEnabled = true
    panGestureRecognizer.delegate = self
    addGestureRecognizer(panGestureRecognizer)
  }

  private func resetSubviews() {
    // Remove subviews added from outside
    for view in [self, contentView, titleLabel, subtitleLabel, pillView] {
      for subview in view.subviews where subview.tag != expectedSubviewTag {
        subview.removeFromSuperview()
      }
    }

    // Reset custom subview
    customSubview = nil
    customSubviewSizingController = nil
    if leftView != activityIndicatorView {
      leftView = nil
    }

    // Ensure expected subviews are set
    addSubview(contentView)
    contentView.addSubview(pillView)
    if let progressView {
      contentView.addSubview(progressView)
    }
    contentView.addSubview(titleLabel)
    contentView.addSubview(subtitleLabel)
    if let leftView {
      contentView.addSubview(leftView)
    }

    // Ensure gesture recognizers are added
    addGestureRecognizer(longPressGestureRecognizer)
    addGestureRecognizer(panGestureRecognizer)
  }

  // MARK: - Activity Indicator
  private func createActivityIndicatorViewIfNeeded() {
    if activityIndicatorView == nil {
      let activityIndicatorView = UIActivityIndicatorView()
      activityIndicatorView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      activityIndicatorView.sizeToFit()
      activityIndicatorView.color = style.leftViewStyle.tintColor ?? style.textStyle.textColor
      activityIndicatorView.tag = expectedSubviewTag
      self.activityIndicatorView = activityIndicatorView
    }
  }

  var displaysActivityIndicator: Bool {
    get {
      return leftView === activityIndicatorView
    }
    set {
      activityIndicatorView?.isHidden = !newValue

      if newValue {
        createActivityIndicatorViewIfNeeded()
        activityIndicatorView?.startAnimating()
        leftView = activityIndicatorView
      } else {
        activityIndicatorView?.stopAnimating()
        if leftView === activityIndicatorView {
          leftView = nil
        }
      }
    }
  }

  // MARK: - Progress Bar

  private func createProgressViewIfNeeded() -> UIView {
    if let progressView {
      return progressView
    }

    let progressView = UIView(frame: .zero)
    progressView.backgroundColor = style.progressBarStyle.barColor
    progressView.layer.cornerRadius = style.progressBarStyle.cornerRadius
    progressView.frame = progressViewRect(forPercentage: 0.0, with: style)
    progressView.tag = expectedSubviewTag
    self.progressView = progressView

    contentView.insertSubview(progressView, belowSubview: titleLabel)
    setNeedsLayout()

    return progressView
  }

  private func progressViewRect(forPercentage percentage: CGFloat, with style: StatusBarNotificationStyle) -> CGRect {
    let progressBarStyle = style.progressBarStyle
    let contentSize = contentRectForViewMinusSafeAreaInsets().size

    // calculate progressView frame
    let barHeight = min(contentSize.height, max(0.5, progressBarStyle.barHeight))
    let width = round((contentSize.width - 2 * progressBarStyle.horizontalInsets) * percentage)
    var barFrame = CGRect(x: progressBarStyle.horizontalInsets, y: progressBarStyle.offsetY, width: width, height: barHeight)

    // calculate y-position
    switch progressBarStyle.position {
      case .top:
        break
      case .center:
        barFrame.origin.y += style.textStyle.textOffsetY + round((contentSize.height - barHeight) / 2.0) + 1
      case .bottom:
        barFrame.origin.y += contentSize.height - barHeight
    }

    return barFrame
  }

  private var clampedProgress: CGFloat = 0.0
  var progressBarPercentage: CGFloat {
    get {
      clampedProgress
    }
    set {
      animateProgressBar(toPercentage: newValue, animationDuration: 0.0, completion: nil)
    }
  }

  func animateProgressBar(toPercentage percentage: CGFloat, animationDuration: CGFloat, completion: (() -> Void)?) {
    // clamp progress
    clampedProgress = min(1.0, max(0.0, percentage))

    // reset animations
    progressView?.layer.removeAllAnimations()

    // reset view
    if clampedProgress == 0.0 && animationDuration == 0.0 {
      if let progressView {
        progressView.isHidden = true
        layoutSubviews()
        let frame = progressViewRect(forPercentage: clampedProgress, with: style)
        progressView.frame = frame
      }
      completion?()
      return
    }

    // create view & reset state
    let progressView = createProgressViewIfNeeded()
    progressView.isHidden = false

    // calculate progressView frame
    let frame = progressViewRect(forPercentage: clampedProgress, with: style)

    // immediately set frame, if duration is 0s
    if animationDuration == 0.0 {
      progressView.frame = frame
      completion?()
      return
    }

    // animate
    UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0, options: .curveLinear, animations: {
      progressView.frame = frame
    }, completion: { finished in
      if finished {
        completion?()
      }
    })
  }

  // MARK: - Title
  var title: String? {
    get {
      return titleLabel.text
    }
    set {
      titleLabel.accessibilityLabel = newValue
      titleLabel.text = newValue
      titleLabel.isHidden = (newValue?.isEmpty ?? true)

      setNeedsLayout()
    }
  }

  // MARK: - Subtitle
  var subtitle: String? {
    get {
      return subtitleLabel.text
    }
    set {
      subtitleLabel.accessibilityLabel = newValue
      subtitleLabel.text = newValue
      subtitleLabel.isHidden = (newValue?.isEmpty ?? true)

      setNeedsLayout()
    }
  }

  // MARK: - Left View

  var leftView: UIView? {
    didSet {
      oldValue?.removeFromSuperview()

      if let tintColor = style.leftViewStyle.tintColor {
        leftView?.tintColor = tintColor
      }

      if let leftView {
        contentView.addSubview(leftView)
      }

      setNeedsLayout()

#if JDSB_LAYOUT_DEBUGGING
      leftView?.layer.borderColor = UIColor.darkGray.cgColor
      leftView?.layer.borderWidth = 1.0
#endif
    }
  }

  // MARK: - Custom Subview
  var customSubview: UIView? {
    didSet {
      oldValue?.removeFromSuperview()
      if let customSubview {
        contentView.addSubview(customSubview)
      }
      setNeedsLayout()
    }
  }

  var customSubviewSizingController: NotificationPresenterCustomViewSizingController? {
    didSet {
      setNeedsLayout()
    }
  }

  // MARK: - Style
  var style: StatusBarNotificationStyle = StatusBarNotificationStyle() {
    didSet {
      // Background
      let color = style.backgroundStyle.backgroundColor
      switch style.backgroundStyle.backgroundType {
        case .fullWidth:
          backgroundColor = color
          pillView.isHidden = true
        case .pill:
          backgroundColor = .clear
          pillView.backgroundColor = color
          pillView.isHidden = false
          setPillStyle(style.backgroundStyle.pillStyle)
      }

      // Style labels
      applyTextStyleForLabel(style.textStyle, titleLabel)
      applyTextStyleForLabel(style.subtitleStyle, subtitleLabel)

      // Activity indicator
      activityIndicatorView?.color = style.leftViewStyle.tintColor ?? style.textStyle.textColor
      leftView?.tintColor = style.leftViewStyle.tintColor

      // Progress view
      progressView?.backgroundColor = style.progressBarStyle.barColor
      progressView?.layer.cornerRadius = style.progressBarStyle.cornerRadius

      // Enable/disable gesture recognizers
      panGestureRecognizer.isEnabled = style.canSwipeToDismiss
      longPressGestureRecognizer.isEnabled = style.canTapToHold

      resetSubviews()
      setNeedsLayout()
      delegate?.didUpdateStyle()
    }
  }

  func sizeFromPoint(_ point: CGPoint) -> CGSize {
    return CGSizeMake(point.x, point.y);
  }

  func applyTextStyleForLabel(_ textStyle: StatusBarNotificationTextStyle, _ label: UILabel) {
    label.textColor = textStyle.textColor
    label.font = textStyle.font

    if let shadowColor = textStyle.shadowColor {
      label.shadowColor = shadowColor
      label.shadowOffset = sizeFromPoint(textStyle.shadowOffset)
    } else {
      label.shadowColor = nil
      label.shadowOffset = CGSize.zero
    }
  }

  func setPillStyle(_ pillStyle: StatusBarNotificationPillStyle) {
    // Set border
    pillView.layer.borderColor = pillStyle.borderColor?.cgColor
    pillView.layer.borderWidth = pillStyle.borderColor != nil ? pillStyle.borderWidth : 0.0

    // Set shadows
    pillView.layer.shadowColor = pillStyle.shadowColor?.cgColor
    pillView.layer.shadowRadius = pillStyle.shadowColor != nil ? pillStyle.shadowRadius : 0.0
    pillView.layer.shadowOpacity = pillStyle.shadowColor != nil ? 1.0 : 0.0
    pillView.layer.shadowOffset = sizeFromPoint(pillStyle.shadowOffsetXY)
  }

  // MARK: - Layout
  func contentRectForViewMinusSafeAreaInsets() -> CGRect {
    let topLayoutMargins = self.window?.safeAreaInsets.top ?? 0.0
    let height = self.bounds.size.height - topLayoutMargins
    let rect = CGRect(x: 0, y: topLayoutMargins, width: self.bounds.size.width, height: height)

    switch style.backgroundStyle.backgroundType {
      case .fullWidth:
        return rect
      case .pill:
        return pillContentRectForContentRect(rect)
    }
  }

  func realTextSizeForLabel(_ textLabel: UILabel) -> CGSize {
    let attributes = [NSAttributedString.Key.font: textLabel.font!]
    return ((textLabel.text ?? "") as NSString).size(withAttributes: attributes)
  }

  func roundRectMaskForRectAndRadius(_ rect: CGRect) -> CALayer {
    let roundedRectPath = UIBezierPath(roundedRect: rect, cornerRadius: rect.size.height / 2.0)
    let maskLayer = CAShapeLayer()
    maskLayer.path = roundedRectPath.cgPath
    return maskLayer
  }

  func pillContentRectForContentRect(_ contentRect: CGRect) -> CGRect {
    let pillStyle = style.backgroundStyle.pillStyle

    // Pill layout parameters
    let pillHeight = pillStyle.height
    var paddingX: CGFloat = 20.0
    let minimumPillInset: CGFloat = 20.0
    let maximumPillWidth = contentRect.size.width - minimumPillInset * 2
    let minimumPillWidth = min(maximumPillWidth, max(pillHeight, pillStyle.minimumWidth))

    // Left view padding adjustment
    if let leftView {
      paddingX += round((leftView.frame.width + style.leftViewStyle.spacing) / 2.0)
    }

    // Layout pill
    var maxTextWidth = max(realTextSizeForLabel(titleLabel).width, realTextSizeForLabel(subtitleLabel).width)
    if let customSubview {
      paddingX = 0.0 // Let the custom view control all padding
      let sizeThatFits = customSubviewSizingController?.sizeThatFits(in: contentRect.size) ?? customSubview.sizeThatFits(contentRect.size) 
      maxTextWidth = max(maxTextWidth, sizeThatFits.width)
    }
    let pillWidth = round(max(minimumPillWidth, min(maximumPillWidth, maxTextWidth + paddingX * 2)))
    let pillX = round(max(minimumPillInset, (bounds.width - pillWidth) / 2.0))
    let pillY = round(contentRect.origin.y + contentRect.size.height - pillHeight)
    return CGRect(x: pillX, y: pillY, width: pillWidth, height: pillHeight)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    // update content view
    contentView.frame = contentRectForViewMinusSafeAreaInsets()

    // relayout pill view
    if style.backgroundStyle.backgroundType == .pill {
      pillView.frame = contentView.bounds

      // Setup rounded corners (not using a mask layer, so that we can use shadows on this view)
      pillView.layer.cornerRadius = round(pillView.frame.size.height / 2.0)
      pillView.layer.cornerCurve = .continuous
      pillView.layer.allowsEdgeAntialiasing = true
    }

    // Custom subview always matches full content view
    customSubview?.frame = contentView.bounds

    // Title label
    let labelInsetX: CGFloat = 20.0
    let subtitleSpacing: CGFloat = 1.0
    let innerContentRect = contentView.bounds.inset(by: UIEdgeInsets(top: 0, left: labelInsetX, bottom: 0, right: labelInsetX))
    let titleSize = realTextSizeForLabel(titleLabel)
    let titleWidth = min(titleSize.width, innerContentRect.width)
    let subtitleSize = realTextSizeForLabel(subtitleLabel)
    let subtitleWidth = min(subtitleSize.width, innerContentRect.width)
    let combinedMaxTextWidth = max(titleWidth, subtitleWidth)
    titleLabel.frame = CGRect(x: round((contentView.bounds.width - combinedMaxTextWidth) / 2.0),
                              y: round((contentView.bounds.height - titleSize.height) / 2.0 + style.textStyle.textOffsetY),
                              width: combinedMaxTextWidth,
                              height: titleSize.height)

    // Default to center alignment
    var textAlignment = NSTextAlignment.center

    // Progress view
    if let progressView, (progressView.layer.animationKeys())?.count == 0 {
      progressView.frame = progressViewRect(forPercentage: progressBarPercentage, with: style)
    }

    // Left view
    if let leftView {
      var leftViewFrame = leftView.frame

      // Fit left view into notification
      if leftView != activityIndicatorView {
        if leftViewFrame.isEmpty {
          leftViewFrame = CGRect(x: 0, y: 0, width: innerContentRect.size.height, height: innerContentRect.size.height)
        }
        leftViewFrame.size = leftView.sizeThatFits(innerContentRect.size)
      }

      // Center vertically
      leftViewFrame.origin.y = round((contentView.bounds.height - leftViewFrame.height) / 2.0 + style.textStyle.textOffsetY)

      // X-position
      if combinedMaxTextWidth == 0.0 {
        // Center horizontally
        leftViewFrame.origin.x = round(contentView.bounds.size.width / 2.0 - leftViewFrame.size.width / 2.0)
      } else {
        switch style.leftViewStyle.alignment {
          case .centerWithText:
            // Position left view in front of text and center together with text
            let widthAndSpacing = leftViewFrame.width + style.leftViewStyle.spacing
            titleLabel.frame = titleLabel.frame.offsetBy(dx: round(widthAndSpacing / 2.0), dy: 0)
            leftViewFrame.origin.x = max(innerContentRect.minX, titleLabel.frame.minX - widthAndSpacing)
            textAlignment = .left
          case .left:
            // Left-align left view
            leftViewFrame.origin.x = innerContentRect.minX
        }
      }

      leftViewFrame = leftViewFrame.offsetBy(dx: style.leftViewStyle.offset.x, dy: style.leftViewStyle.offset.y)
      leftView.frame = leftViewFrame

      // Title adjustments
      if combinedMaxTextWidth > 0.0 {
        var titleRect = titleLabel.frame

        // Avoid left view/text overlap
        var viewAndSpacing = leftViewFrame
        viewAndSpacing.size.width += style.leftViewStyle.spacing
        let intersection = viewAndSpacing.intersection(titleRect)
        if !intersection.isNull {
          textAlignment = .left
          titleRect.origin.x += intersection.width
        }

        // Respect inner bounds
        titleRect.size.width = min(titleRect.width, innerContentRect.maxX - titleRect.origin.x)

        titleLabel.frame = titleRect
      }
    }

    // Subtitle label
    if let text = subtitleLabel.text, !text.isEmpty {
      // Adjust title y centering
      let centerYAdjustment = round((subtitleSize.height + subtitleSpacing) / 2.0)
      titleLabel.frame = titleLabel.frame.offsetBy(dx: 0, dy: -centerYAdjustment)

      // Set subtitle frame
      subtitleLabel.frame = CGRect(x: titleLabel.frame.minX,
                                   y: titleLabel.frame.maxY + subtitleSpacing + style.subtitleStyle.textOffsetY,
                                   width: titleLabel.frame.width,
                                   height: subtitleSize.height)
    }

    // Update text alignment
    titleLabel.textAlignment = textAlignment
    subtitleLabel.textAlignment = textAlignment

    // Update masks (after layout is done)
    setupClippingAndLayerMasksForSubviews()
  }

  func setupClippingAndLayerMasksForSubviews() {
    // Mask progress view & custom subview to pill size & shape
    switch style.backgroundStyle.backgroundType {
      case .fullWidth:
        progressView?.layer.mask = nil
        customSubview?.layer.mask = nil
        customSubview?.clipsToBounds = true
      case .pill:
        if let progressView {
          progressView.layer.mask = roundRectMaskForRectAndRadius(progressView.convert(pillView.frame, from: pillView.superview))
        }
        if let customSubview {
          customSubview.clipsToBounds = false
          customSubview.layer.mask = roundRectMaskForRectAndRadius(customSubview.convert(pillView.frame, from: pillView.superview))
        }
    }
  }

  // MARK: - UIView overrides

  // HitTest
  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    if isUserInteractionEnabled {
      return contentView.hitTest(convert(point, to: contentView), with: event)
    }
    return nil
  }

  // UIGestureRecognizerDelegate
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return (otherGestureRecognizer == longPressGestureRecognizer)
  }



}
