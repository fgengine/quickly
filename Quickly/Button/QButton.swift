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
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
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
    public var imageInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    public var textInsets: UIEdgeInsets = UIEdgeInsets.zero {
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
                spinnerView.translatesAutoresizingMaskIntoConstraints = true
                self.contentView.addSubview(spinnerView)
            }
            self.invalidateIntrinsicContentSize()
            self.setNeedsUpdateConstraints()
        }
    }
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.currentConstraints) }
        didSet { self.addConstraints(self.currentConstraints) }
    }
    internal var contentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.contentConstraints) }
        didSet { self.contentView.addConstraints(self.contentConstraints) }
    }

    open override var intrinsicContentSize: CGSize {
        get {
            return self.sizeThatFits(CGSize(
                width: CGFloat.greatestFiniteMagnitude,
                height: CGFloat.greatestFiniteMagnitude
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
        self.imageView.isHidden = true
        self.contentView.addSubview(self.imageView)

        self.textLabel = QLabel(frame: self.bounds)
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.isUserInteractionEnabled = false
        self.textLabel.isHidden = true
        self.contentView.addSubview(self.textLabel)
    }

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

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let contentSize: CGSize = CGSize(
            width: size.width - (self.contentInsets.left + self.contentInsets.right),
            height: size.height - (self.contentInsets.top + self.contentInsets.bottom)
        )
        let isSpinnerAnimating: Bool = self.isSpinnerAnimating()
        if isSpinnerAnimating == true && self.spinnerPosition == .fill {
            let spinnerSizeThatFits: CGSize = self.spinnerView!.sizeThatFits(contentSize)
            return CGSize(
                width: self.contentInsets.left + spinnerSizeThatFits.width + self.contentInsets.right,
                height: self.contentInsets.top + spinnerSizeThatFits.height + self.contentInsets.bottom
            )
        }
        var imageSize: CGSize
        if isSpinnerAnimating == true && self.spinnerPosition == .image {
            let spinnerSizeThatFits: CGSize = self.spinnerView!.sizeThatFits(contentSize)
            imageSize = CGSize(
                width: self.imageInsets.left + spinnerSizeThatFits.width + self.imageInsets.right,
                height: self.imageInsets.top + spinnerSizeThatFits.height + self.imageInsets.bottom
            )
        } else if self.imageView.isHidden == false {
            let imageSizeThatFits: CGSize = self.imageView.sizeThatFits(contentSize)
            imageSize = CGSize(
                width: self.imageInsets.left + imageSizeThatFits.width + self.imageInsets.right,
                height: self.imageInsets.top + imageSizeThatFits.height + self.imageInsets.bottom
            )
        } else {
            imageSize = CGSize.zero
        }
        var textSize: CGSize
        if self.textLabel.isHidden == false {
            let textSizeThatFits: CGSize = self.textLabel.sizeThatFits(contentSize)
            textSize = CGSize(
                width: self.textInsets.left + textSizeThatFits.width + self.textInsets.right,
                height: self.textInsets.top + textSizeThatFits.height + self.textInsets.bottom
            )
        } else {
            textSize = CGSize.zero
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
        super.sizeToFit()

        self.frame.size = self.sizeThatFits(CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        ))
    }

    open override func updateConstraints() {
        var currentConstraints: [NSLayoutConstraint] = []
        switch self.contentHorizontalAlignment {
        case .fill:
            currentConstraints.append(self.contentView.leadingLayout == self.leadingLayout + self.contentInsets.left)
            currentConstraints.append(self.contentView.trailingLayout == self.trailingLayout - self.contentInsets.right)
            break
        case .left:
            currentConstraints.append(self.contentView.leadingLayout == self.leadingLayout + self.contentInsets.left)
            currentConstraints.append(self.contentView.trailingLayout <= self.trailingLayout - self.contentInsets.right)
            break
        case .center:
            currentConstraints.append(self.contentView.centerXLayout == self.centerXLayout)
            currentConstraints.append(self.contentView.leadingLayout >= self.leadingLayout + self.contentInsets.left)
            currentConstraints.append(self.contentView.trailingLayout <= self.trailingLayout - self.contentInsets.right)
            break
        case .right:
            currentConstraints.append(self.contentView.leadingLayout >= self.leadingLayout + self.contentInsets.left)
            currentConstraints.append(self.contentView.trailingLayout == self.trailingLayout - self.contentInsets.right)
            break
        }
        switch self.contentVerticalAlignment {
        case .fill:
            currentConstraints.append(self.contentView.topLayout == self.topLayout + self.contentInsets.top)
            currentConstraints.append(self.contentView.bottomLayout == self.bottomLayout - self.contentInsets.bottom)
            break
        case .top:
            currentConstraints.append(self.contentView.topLayout == self.topLayout + self.contentInsets.top)
            currentConstraints.append(self.contentView.bottomLayout <= self.bottomLayout - self.contentInsets.bottom)
            break
        case .center:
            currentConstraints.append(self.contentView.centerYLayout == self.centerYLayout)
            currentConstraints.append(self.contentView.topLayout >= self.topLayout + self.contentInsets.top)
            currentConstraints.append(self.contentView.bottomLayout <= self.bottomLayout - self.contentInsets.bottom)
            break
        case .bottom:
            currentConstraints.append(self.contentView.topLayout >= self.topLayout + self.contentInsets.top)
            currentConstraints.append(self.contentView.bottomLayout == self.bottomLayout - self.contentInsets.bottom)
            break
        }
        self.currentConstraints = currentConstraints

        var contentConstraints: [NSLayoutConstraint] = []
        let isSpinnerAnimating: Bool = self.isSpinnerAnimating()
        let existSpinner: Bool = self.spinnerView != nil
        let existImage: Bool = self.imageView.isHidden == false
        let existText: Bool = self.textLabel.isHidden == false
        if isSpinnerAnimating == true {
            switch self.spinnerPosition {
            case .fill:
                self.updateContent(constraints: &contentConstraints, view: self.spinnerView!)
                break
            case .image:
                if existText == true {
                    switch self.imagePosition {
                    case .top:
                        self.updateContent(constraints: &contentConstraints,
                                           topView: self.spinnerView!, topEdgeInsets: self.imageInsets,
                                           bottomView: self.textLabel, bottomEdgeInsets: self.textInsets)
                        break
                    case .left:
                        self.updateContent(constraints: &contentConstraints,
                                           leftView: self.spinnerView!, leftEdgeInsets: self.imageInsets,
                                           rightView: self.textLabel, rightEdgeInsets: self.textInsets)
                        break
                    case .right:
                        self.updateContent(constraints: &contentConstraints,
                                           leftView: self.textLabel, leftEdgeInsets: self.textInsets,
                                           rightView: self.spinnerView!, rightEdgeInsets: self.imageInsets)
                        break
                    case .bottom:
                        self.updateContent(constraints: &contentConstraints,
                                           topView: self.textLabel, topEdgeInsets: self.textInsets,
                                           bottomView: self.spinnerView!, bottomEdgeInsets: self.imageInsets)
                        break
                    }
                } else {
                    self.updateContent(constraints: &contentConstraints, view: self.spinnerView!)
                }
                break
            }
        } else {
            if existImage == true && existText == true {
                switch self.imagePosition {
                case .top:
                    self.updateContent(constraints: &contentConstraints,
                                       topView: self.imageView, topEdgeInsets: self.imageInsets,
                                       bottomView: self.textLabel, bottomEdgeInsets: self.textInsets)
                    break
                case .left:
                    self.updateContent(constraints: &contentConstraints,
                                       leftView: self.imageView, leftEdgeInsets: self.imageInsets,
                                       rightView: self.textLabel, rightEdgeInsets: self.textInsets)
                    break
                case .right:
                    self.updateContent(constraints: &contentConstraints,
                                       leftView: self.textLabel, leftEdgeInsets: self.textInsets,
                                       rightView: self.imageView, rightEdgeInsets: self.imageInsets)
                    break
                case .bottom:
                    self.updateContent(constraints: &contentConstraints,
                                       topView: self.textLabel, topEdgeInsets: self.textInsets,
                                       bottomView: self.imageView, bottomEdgeInsets: self.imageInsets)
                    break
                }
            } else if existImage == true {
                self.updateContent(constraints: &contentConstraints, view: self.imageView, edgeInsets: self.imageInsets)
            } else if existText == false {
                self.updateContent(constraints: &contentConstraints, view: self.textLabel, edgeInsets: self.textInsets)
            }
        }
        if isSpinnerAnimating == false && existImage == false && existText == false {
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
        let isSpinnerAnimating: Bool = self.isSpinnerAnimating()
        if isSpinnerAnimating == true {
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
            self.imageView.tintColor = style.imageTintColor
            self.imageView.isHidden = false
        } else {
            self.resetImageStyle()
        }
    }

    private func resetImageStyle() {
        self.imageView.source = nil
        self.imageView.tintColor = nil
        self.imageView.isHidden = true
    }

    private func applyTextStyle(_ style: QButtonStyle) {
        if let text: IQText = style.text {
            self.textLabel.text = text
            self.textLabel.isHidden = false
        } else {
            self.resetTextStyle()
        }
    }

    private func resetTextStyle() {
        self.textLabel.text = nil
        self.textLabel.isHidden = true
    }

    private func updateContent(constraints: inout [NSLayoutConstraint], view: UIView) {
        constraints.append(view.topLayout == self.contentView.topLayout)
        constraints.append(view.leadingLayout == self.contentView.leadingLayout)
        constraints.append(view.trailingLayout == self.contentView.trailingLayout)
        constraints.append(view.bottomLayout == self.contentView.bottomLayout)
    }

    private func updateContent(constraints: inout [NSLayoutConstraint], view: UIView, edgeInsets: UIEdgeInsets) {
        constraints.append(view.topLayout == self.contentView.topLayout + edgeInsets.top)
        constraints.append(view.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
        constraints.append(view.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
        constraints.append(view.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
    }

    private func updateContent(
        constraints: inout [NSLayoutConstraint],
        topView: UIView, topEdgeInsets: UIEdgeInsets,
        bottomView: UIView, bottomEdgeInsets: UIEdgeInsets
    ) {
        constraints.append(topView.topLayout == self.contentView.topLayout + topEdgeInsets.top)
        constraints.append(topView.leadingLayout == self.contentView.leadingLayout + topEdgeInsets.left)
        constraints.append(topView.trailingLayout == self.contentView.trailingLayout - topEdgeInsets.right)
        constraints.append(topView.bottomLayout == bottomView.topLayout + (topEdgeInsets.bottom + bottomEdgeInsets.top))
        constraints.append(bottomView.leadingLayout == self.contentView.leadingLayout + bottomEdgeInsets.left)
        constraints.append(bottomView.trailingLayout == self.contentView.trailingLayout - bottomEdgeInsets.right)
        constraints.append(bottomView.bottomLayout == self.contentView.bottomLayout - bottomEdgeInsets.bottom)
    }

    private func updateContent(
        constraints: inout [NSLayoutConstraint],
        leftView: UIView, leftEdgeInsets: UIEdgeInsets,
        rightView: UIView, rightEdgeInsets: UIEdgeInsets
    ) {
        constraints.append(leftView.topLayout == self.contentView.topLayout + leftEdgeInsets.top)
        constraints.append(leftView.leadingLayout == self.contentView.leadingLayout + leftEdgeInsets.left)
        constraints.append(leftView.trailingLayout == rightView.leadingLayout + (leftEdgeInsets.right + rightEdgeInsets.left))
        constraints.append(leftView.bottomLayout == self.contentView.bottomLayout + leftEdgeInsets.bottom)
        constraints.append(rightView.topLayout == self.contentView.topLayout + rightEdgeInsets.top)
        constraints.append(rightView.trailingLayout == self.contentView.trailingLayout - rightEdgeInsets.right)
        constraints.append(rightView.bottomLayout == self.contentView.bottomLayout - rightEdgeInsets.bottom)
    }

}
