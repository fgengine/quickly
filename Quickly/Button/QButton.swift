//
//  Quickly
//

import UIKit

public enum QButtonSpinnerPosition: Int {
    case fill
    case image
}

public enum QButtonImagePosition: Int {
    case top
    case left
    case right
    case bottom
}

@IBDesignable
open class QButton: QControl {

    open override var isHighlighted: Bool {
        didSet { self.applyStyle() }
    }
    open override var isSelected: Bool {
        didSet { self.applyStyle() }
    }
    open override var isEnabled: Bool {
        didSet { self.applyStyle() }
    }
    open override var contentHorizontalAlignment: UIControlContentHorizontalAlignment {
        didSet { self.setNeedsUpdateConstraints() }
    }
    open override var contentVerticalAlignment: UIControlContentVerticalAlignment {
        didSet { self.setNeedsUpdateConstraints() }
    }
    @IBInspectable public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    public var imagePosition: QButtonImagePosition = .left {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    @IBInspectable public var imageInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    @IBInspectable public var textInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    public var normalStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public var highlightedStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public var disabledStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public var selectedStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public var selectedHighlightedStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public var selectedDisabledStyle: QButtonStyle? {
        didSet { self.applyStyle() }
    }
    public private(set) var contentView: QView!
    public private(set) var imageView: QImageView!
    public private(set) var textLabel: QLabel!
    public private(set) var tapGesture: UITapGestureRecognizer!
    public var spinnerPosition: QButtonSpinnerPosition = .fill {
        didSet { self.applyStyle() }
    }
    public var spinnerView: QSpinnerView? {
        willSet {
            if let spinnerView: QSpinnerView = self.spinnerView {
                spinnerView.removeFromSuperview()
            }
        }
        didSet {
            if let spinnerView: QSpinnerView = self.spinnerView {
                spinnerView.translatesAutoresizingMaskIntoConstraints = false
                self.contentView.addSubview(spinnerView)
            }
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    internal var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.selfConstraints) }
        didSet { self.addConstraints(self.selfConstraints) }
    }
    internal var contentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.contentConstraints) }
        didSet { self.contentView.addConstraints(self.contentConstraints) }
    }

    open override var frame: CGRect {
        didSet { self.invalidateIntrinsicContentSize() }
    }
    open override var bounds: CGRect {
        didSet { self.invalidateIntrinsicContentSize() }
    }
    open override var intrinsicContentSize: CGSize {
        get {
            return self.sizeThatFits(CGSize(
                width: Const.defaultSize,
                height: Const.defaultSize
            ))
        }
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.contentView = QView(frame: self.bounds)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.isUserInteractionEnabled = false
        self.contentView.backgroundColor = UIColor.clear
        self.addSubview(self.contentView)

        self.imageView = QImageView(frame: self.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.isUserInteractionEnabled = false
        self.imageView.alpha = 0
        self.contentView.addSubview(self.imageView)

        self.textLabel = QLabel(frame: self.bounds)
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.isUserInteractionEnabled = false
        self.textLabel.alpha = 0
        self.textLabel.numberOfLines = 0
        self.contentView.addSubview(self.textLabel)

        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.gestureHandler(_:)))
        self.tapGesture.delegate = self
        self.addGestureRecognizer(self.tapGesture)
    }

    #if TARGET_INTERFACE_BUILDER

    open override func prepareForInterfaceBuilder() {
        let style: QButtonStyle = QButtonStyle()
        style.color = UIColor.blue
        style.text = QText("QButton")
        style.cornerRadius = 4
        self.normalStyle = style
    }

    #endif

    public func currentStyle() -> QButtonStyle? {
        if self.isEnabled == false {
            if self.isSelected == true && self.selectedDisabledStyle != nil {
                return self.selectedDisabledStyle
            } else if self.disabledStyle != nil {
                return self.disabledStyle
            }
        } else if self.isHighlighted == true {
            if self.isSelected == true && self.selectedHighlightedStyle != nil {
                return self.selectedHighlightedStyle
            } else if self.highlightedStyle != nil {
                return self.highlightedStyle
            }
        } else if self.isSelected == true && self.selectedStyle != nil {
            return self.selectedStyle
        }
        return self.normalStyle
    }

    public func applyStyle() {
        if let style: QButtonStyle = self.currentStyle() {
            self.applyStyle(style)
            self.invalidateIntrinsicContentSize()
        }
    }

    public func isSpinnerAnimating() -> Bool {
        if let spinnerView: IQSpinnerView = self.spinnerView {
            return spinnerView.isAnimating()
        }
        return false
    }

    public func startSpinner() {
        if let spinnerView: IQSpinnerView = self.spinnerView {
            let isAnimating: Bool = spinnerView.isAnimating()
            spinnerView.start()
            if isAnimating == false {
                self.setNeedsUpdateConstraints()
                self.applyStyle()
            }
        }
    }

    public func stopSpinner() {
        if let spinnerView: IQSpinnerView = self.spinnerView {
            let isAnimating: Bool = spinnerView.isAnimating()
            spinnerView.stop()
            if isAnimating == true {
                self.setNeedsUpdateConstraints()
                self.applyStyle()
            }
        }
    }

    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()

        if let imageView: QImageView = self.imageView {
            imageView.invalidateIntrinsicContentSize()
        }
        if let textLabel: QLabel = self.textLabel {
            textLabel.preferredMaxLayoutWidth = self.bounds.width
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let contentSize: CGSize = CGSize(
            width: size.width - (self.contentInsets.left + self.contentInsets.right),
            height: size.height - (self.contentInsets.top + self.contentInsets.bottom)
        )
        var imageSize: CGSize = CGSize.zero
        var textSize: CGSize = CGSize.zero
        if self.isSpinnerAnimating() == true {
            let spinnerSizeThatFits: CGSize = self.spinnerView!.sizeThatFits(contentSize)
            imageSize = CGSize(
                width: self.imageInsets.left + spinnerSizeThatFits.width + self.imageInsets.right,
                height: self.imageInsets.top + spinnerSizeThatFits.height + self.imageInsets.bottom
            )
            switch self.spinnerPosition {
            case .fill:
                break
            case .image:
                if self.textLabel.alpha > CGFloat.leastNonzeroMagnitude {
                    let textSizeThatFits: CGSize = self.textLabel.sizeThatFits(contentSize)
                    textSize = CGSize(
                        width: self.textInsets.left + textSizeThatFits.width + self.textInsets.right,
                        height: self.textInsets.top + textSizeThatFits.height + self.textInsets.bottom
                    )
                }
                break
            }
        } else {
            if self.imageView.alpha > CGFloat.leastNonzeroMagnitude {
                let imageSizeThatFits: CGSize = self.imageView.sizeThatFits(CGSize.zero)
                imageSize = CGSize(
                    width: self.imageInsets.left + imageSizeThatFits.width + self.imageInsets.right,
                    height: self.imageInsets.top + imageSizeThatFits.height + self.imageInsets.bottom
                )
            }
            if self.textLabel.alpha > CGFloat.leastNonzeroMagnitude {
                let textSizeThatFits: CGSize = self.textLabel.sizeThatFits(contentSize)
                textSize = CGSize(
                    width: self.textInsets.left + textSizeThatFits.width + self.textInsets.right,
                    height: self.textInsets.top + textSizeThatFits.height + self.textInsets.bottom
                )
            }
        }
        switch self.imagePosition {
        case .top, .bottom:
            return CGSize(
                width: self.contentInsets.left + max(imageSize.width, textSize.width) + self.contentInsets.right,
                height: self.contentInsets.top + imageSize.height + textSize.height + self.contentInsets.bottom
            )
        case .left, .right:
            return CGSize(
                width: self.contentInsets.left + imageSize.width + textSize.width + self.contentInsets.right,
                height: self.contentInsets.top + max(imageSize.height, textSize.height) + self.contentInsets.bottom
            )
        }
    }

    open override func sizeToFit() {
        var frame: CGRect = self.frame
        frame.size = self.sizeThatFits(CGSize(
            width: Const.defaultSize,
            height: Const.defaultSize
        ))
        self.frame = frame
    }

    open override func updateConstraints() {
        var selfConstraints: [NSLayoutConstraint] = []
        let horizontalAlignment: UIControlContentHorizontalAlignment = self.contentHorizontalAlignment
        if horizontalAlignment == .fill {
            selfConstraints.append(self.contentView.leadingLayout == self.leadingLayout + self.contentInsets.left)
            selfConstraints.append(self.contentView.trailingLayout == self.trailingLayout - self.contentInsets.right)
        } else if horizontalAlignment == .left {
            selfConstraints.append(self.contentView.leadingLayout == self.leadingLayout + self.contentInsets.left)
            selfConstraints.append(self.contentView.trailingLayout <= self.trailingLayout - self.contentInsets.right)
        } else if horizontalAlignment == .center {
            selfConstraints.append(self.contentView.centerXLayout == self.centerXLayout)
            selfConstraints.append(self.contentView.leadingLayout >= self.leadingLayout + self.contentInsets.left)
            selfConstraints.append(self.contentView.trailingLayout <= self.trailingLayout - self.contentInsets.right)
        } else if horizontalAlignment == .right {
            selfConstraints.append(self.contentView.leadingLayout >= self.leadingLayout + self.contentInsets.left)
            selfConstraints.append(self.contentView.trailingLayout == self.trailingLayout - self.contentInsets.right)
        } else if #available(iOS 11.0, *) {
            if horizontalAlignment == .leading {
                selfConstraints.append(self.contentView.leadingLayout == self.leadingLayout + self.contentInsets.left)
                selfConstraints.append(self.contentView.trailingLayout <= self.trailingLayout - self.contentInsets.right)
            } else if horizontalAlignment == .trailing {
                selfConstraints.append(self.contentView.leadingLayout >= self.leadingLayout + self.contentInsets.left)
                selfConstraints.append(self.contentView.trailingLayout == self.trailingLayout - self.contentInsets.right)
            }
        }
        let verticalAlignment: UIControlContentVerticalAlignment = self.contentVerticalAlignment
        if verticalAlignment == .fill {
            selfConstraints.append(self.contentView.topLayout == self.topLayout + self.contentInsets.top)
            selfConstraints.append(self.contentView.bottomLayout == self.bottomLayout - self.contentInsets.bottom)
        } else if verticalAlignment == .top {
            selfConstraints.append(self.contentView.topLayout == self.topLayout + self.contentInsets.top)
            selfConstraints.append(self.contentView.bottomLayout <= self.bottomLayout - self.contentInsets.bottom)
        } else if verticalAlignment == .center {
            selfConstraints.append(self.contentView.centerYLayout == self.centerYLayout)
            selfConstraints.append(self.contentView.topLayout >= self.topLayout + self.contentInsets.top)
            selfConstraints.append(self.contentView.bottomLayout <= self.bottomLayout - self.contentInsets.bottom)
        } else if verticalAlignment == .bottom {
            selfConstraints.append(self.contentView.topLayout >= self.topLayout + self.contentInsets.top)
            selfConstraints.append(self.contentView.bottomLayout == self.bottomLayout - self.contentInsets.bottom)
        }
        self.selfConstraints = selfConstraints

        var contentConstraints: [NSLayoutConstraint] = []
        if self.isSpinnerAnimating() == true {
            switch self.spinnerPosition {
            case .fill:
                self.updateContent(constraints: &contentConstraints, view: self.spinnerView!)
                switch self.imagePosition {
                case .top:
                    self.updateContent(constraints: &contentConstraints,
                                       topView: self.imageView, topEdgeInsets: self.imageInsets,
                                       bottomView: self.spinnerView!, bottomEdgeInsets: UIEdgeInsets.zero)
                    self.updateContent(constraints: &contentConstraints,
                                       topView: self.spinnerView!, topEdgeInsets: UIEdgeInsets.zero,
                                       bottomView: self.textLabel, bottomEdgeInsets: self.textInsets)
                case .left:
                    self.updateContent(constraints: &contentConstraints,
                                       leftView: self.imageView, leftEdgeInsets: self.imageInsets,
                                       rightView: self.spinnerView!, rightEdgeInsets: UIEdgeInsets.zero)
                    self.updateContent(constraints: &contentConstraints,
                                       leftView: self.spinnerView!, leftEdgeInsets: UIEdgeInsets.zero,
                                       rightView: self.textLabel, rightEdgeInsets: self.textInsets)
                case .right:
                    self.updateContent(constraints: &contentConstraints,
                                       leftView: self.textLabel, leftEdgeInsets: self.textInsets,
                                       rightView: self.spinnerView!, rightEdgeInsets: UIEdgeInsets.zero)
                    self.updateContent(constraints: &contentConstraints,
                                       leftView: self.spinnerView!, leftEdgeInsets: UIEdgeInsets.zero,
                                       rightView: self.imageView, rightEdgeInsets: self.imageInsets)
                case .bottom:
                    self.updateContent(constraints: &contentConstraints,
                                       topView: self.textLabel, topEdgeInsets: self.textInsets,
                                       bottomView: self.spinnerView!, bottomEdgeInsets: UIEdgeInsets.zero)
                    self.updateContent(constraints: &contentConstraints,
                                       topView: self.spinnerView!, topEdgeInsets: UIEdgeInsets.zero,
                                       bottomView: self.imageView, bottomEdgeInsets: self.imageInsets)
                }
                break
            case .image:
                switch self.imagePosition {
                case .top: self.updateContent(constraints: &contentConstraints,
                                              topView: self.spinnerView!, topEdgeInsets: self.imageInsets,
                                              bottomView: self.textLabel, bottomEdgeInsets: self.textInsets)
                case .left: self.updateContent(constraints: &contentConstraints,
                                               leftView: self.spinnerView!, leftEdgeInsets: self.imageInsets,
                                               rightView: self.textLabel, rightEdgeInsets: self.textInsets)
                case .right: self.updateContent(constraints: &contentConstraints,
                                                leftView: self.textLabel, leftEdgeInsets: self.textInsets,
                                                rightView: self.spinnerView!, rightEdgeInsets: self.imageInsets)
                case .bottom: self.updateContent(constraints: &contentConstraints,
                                                 topView: self.textLabel, topEdgeInsets: self.textInsets,
                                                 bottomView: self.spinnerView!, bottomEdgeInsets: self.imageInsets)
                }
                break
            }
        } else {
            if self.spinnerView != nil {
                switch self.spinnerPosition {
                case .fill:
                    contentConstraints.append(self.spinnerView!.centerXLayout == self.contentView.centerXLayout)
                    contentConstraints.append(self.spinnerView!.centerYLayout == self.contentView.centerYLayout)
                    break
                case .image:
                    if self.imageView.alpha > CGFloat.leastNonzeroMagnitude {
                        contentConstraints.append(self.spinnerView!.centerXLayout == self.imageView.centerXLayout)
                        contentConstraints.append(self.spinnerView!.centerYLayout == self.imageView.centerYLayout)
                    } else {
                        contentConstraints.append(self.spinnerView!.centerXLayout == self.contentView.centerXLayout)
                        contentConstraints.append(self.spinnerView!.centerYLayout == self.contentView.centerYLayout)
                    }
                    break
                }
            }
            if self.imageView.alpha > CGFloat.leastNonzeroMagnitude || self.textLabel.alpha > CGFloat.leastNonzeroMagnitude {
                switch self.imagePosition {
                case .top: self.updateContent(constraints: &contentConstraints,
                                              topView: self.imageView, topEdgeInsets: self.imageInsets,
                                              bottomView: self.textLabel, bottomEdgeInsets: self.textInsets)
                case .left: self.updateContent(constraints: &contentConstraints,
                                               leftView: self.imageView, leftEdgeInsets: self.imageInsets,
                                               rightView: self.textLabel, rightEdgeInsets: self.textInsets)
                case .right: self.updateContent(constraints: &contentConstraints,
                                                leftView: self.textLabel, leftEdgeInsets: self.textInsets,
                                                rightView: self.imageView, rightEdgeInsets: self.imageInsets)
                case .bottom: self.updateContent(constraints: &contentConstraints,
                                                 topView: self.textLabel, topEdgeInsets: self.textInsets,
                                                 bottomView: self.imageView, bottomEdgeInsets: self.imageInsets)
                }
            } else {
                self.updateContent(constraints: &contentConstraints, view: self.imageView, edgeInsets: self.imageInsets)
                self.updateContent(constraints: &contentConstraints, view: self.textLabel, edgeInsets: self.textInsets)
            }
        }
        if self.isSpinnerAnimating() == false && self.imageView.alpha <= CGFloat.leastNonzeroMagnitude && self.textLabel.alpha <= CGFloat.leastNonzeroMagnitude {
            contentConstraints.append(self.contentView.widthLayout == 0)
            contentConstraints.append(self.contentView.heightLayout == 0)
        }
        self.contentConstraints = contentConstraints

        super.updateConstraints()
    }

    private func applyStyle(_ style: QButtonStyle) {
        if let color: UIColor = style.color {
            self.backgroundColor = color
        }
        if let borderColor: UIColor = style.borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth: CGFloat = style.borderWidth {
            self.layer.borderWidth = borderWidth
        }
        if let cornerRadius: CGFloat = style.cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
        if self.isSpinnerAnimating() == true {
            self.isUserInteractionEnabled = false
            switch self.spinnerPosition {
            case .fill:
                self.resetImageStyle()
                self.resetTextStyle()
                break
            case .image:
                self.resetImageStyle()
                self.applyTextStyle(style)
                break
            }
        } else {
            self.isUserInteractionEnabled = true
            self.applyImageStyle(style)
            self.applyTextStyle(style)
        }
    }

    private func applyImageStyle(_ style: QButtonStyle) {
        if let imageSource: QImageSource = style.imageSource {
            self.imageView.source = imageSource
            self.imageView.alpha = 1
        } else {
            self.resetImageStyle()
        }
    }

    private func resetImageStyle() {
        self.imageView.alpha = 0
    }

    private func applyTextStyle(_ style: QButtonStyle) {
        if let text: IQText = style.text {
            self.textLabel.text = text
            self.textLabel.alpha = 1
        } else {
            self.resetTextStyle()
        }
    }

    private func resetTextStyle() {
        self.textLabel.alpha = 0
    }

    private func updateContent(constraints: inout [NSLayoutConstraint], view: UIView) {
        constraints.append(view.topLayout == self.contentView.topLayout)
        constraints.append(view.leadingLayout == self.contentView.leadingLayout)
        constraints.append(view.trailingLayout <= self.contentView.trailingLayout)
        constraints.append(view.bottomLayout <= self.contentView.bottomLayout)
        constraints.append(view.centerXLayout == self.contentView.centerXLayout)
        constraints.append(view.centerYLayout == self.contentView.centerYLayout)
    }

    private func updateContent(constraints: inout [NSLayoutConstraint], view: UIView, edgeInsets: UIEdgeInsets) {
        constraints.append(view.topLayout == self.contentView.topLayout + edgeInsets.top)
        constraints.append(view.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
        constraints.append(view.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
        constraints.append(view.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
        constraints.append(view.centerXLayout == self.contentView.centerXLayout)
        constraints.append(view.centerYLayout == self.contentView.centerYLayout)
    }

    private func updateContent(
        constraints: inout [NSLayoutConstraint],
        topView: UIView, topEdgeInsets: UIEdgeInsets,
        bottomView: UIView, bottomEdgeInsets: UIEdgeInsets
    ) {
        constraints.append(topView.leadingLayout >= self.contentView.leadingLayout + topEdgeInsets.left)
        constraints.append(topView.trailingLayout <= self.contentView.trailingLayout - topEdgeInsets.right)
        constraints.append(topView.bottomLayout == bottomView.topLayout - (topEdgeInsets.bottom + bottomEdgeInsets.top))
        constraints.append(bottomView.leadingLayout >= self.contentView.leadingLayout + bottomEdgeInsets.left)
        constraints.append(bottomView.trailingLayout <= self.contentView.trailingLayout - bottomEdgeInsets.right)
        if topView.alpha <= CGFloat.leastNonzeroMagnitude {
            constraints.append(bottomView.topLayout == self.contentView.topLayout + bottomEdgeInsets.top)
            constraints.append(bottomView.bottomLayout == self.contentView.bottomLayout - bottomEdgeInsets.bottom)
        } else if bottomView.alpha <= CGFloat.leastNonzeroMagnitude {
            constraints.append(topView.topLayout == self.contentView.topLayout + topEdgeInsets.top)
            constraints.append(topView.bottomLayout == self.contentView.bottomLayout - topEdgeInsets.bottom)
        } else {
            constraints.append(topView.topLayout == self.contentView.topLayout + topEdgeInsets.top)
            constraints.append(bottomView.bottomLayout == self.contentView.bottomLayout - bottomEdgeInsets.bottom)
        }
        constraints.append(topView.centerXLayout == self.contentView.centerXLayout)
        constraints.append(bottomView.centerXLayout == self.contentView.centerXLayout)
    }

    private func updateContent(
        constraints: inout [NSLayoutConstraint],
        leftView: UIView, leftEdgeInsets: UIEdgeInsets,
        rightView: UIView, rightEdgeInsets: UIEdgeInsets
    ) {
        constraints.append(leftView.topLayout >= self.contentView.topLayout + leftEdgeInsets.top)
        constraints.append(leftView.trailingLayout == rightView.leadingLayout - (leftEdgeInsets.right + rightEdgeInsets.left))
        constraints.append(leftView.bottomLayout <= self.contentView.bottomLayout - leftEdgeInsets.bottom)
        constraints.append(rightView.topLayout >= self.contentView.topLayout + rightEdgeInsets.top)
        constraints.append(rightView.bottomLayout <= self.contentView.bottomLayout - rightEdgeInsets.bottom)
        if leftView.alpha <= CGFloat.leastNonzeroMagnitude {
            constraints.append(rightView.leadingLayout == self.contentView.leadingLayout + rightEdgeInsets.left)
            constraints.append(rightView.trailingLayout == self.contentView.trailingLayout - rightEdgeInsets.right)
        } else if rightView.alpha <= CGFloat.leastNonzeroMagnitude {
            constraints.append(leftView.leadingLayout == self.contentView.leadingLayout + leftEdgeInsets.left)
            constraints.append(leftView.trailingLayout == self.contentView.trailingLayout - leftEdgeInsets.right)
        } else {
            constraints.append(leftView.leadingLayout == self.contentView.leadingLayout + leftEdgeInsets.left)
            constraints.append(rightView.trailingLayout == self.contentView.trailingLayout - rightEdgeInsets.right)
        }
        constraints.append(leftView.centerYLayout == self.contentView.centerYLayout)
        constraints.append(rightView.centerYLayout == self.contentView.centerYLayout)
    }

    @IBAction private func gestureHandler(_ sender: Any) {
        self.sendActions(for: .touchUpInside)
    }

    private struct Const {

        static let defaultSize: CGFloat = 1024 * 1024

    }

}

extension QButton: UIGestureRecognizerDelegate {

    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.tapGesture == gestureRecognizer {
            let location: CGPoint = self.tapGesture.location(in: self)
            return self.bounds.contains(location)
        }
        return false
    }

}

