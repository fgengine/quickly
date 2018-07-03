//
//  Quickly
//

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

public class QButton : QControl {

    open override var isHighlighted: Bool {
        didSet { self.invalidate() }
    }
    open override var isSelected: Bool {
        didSet { self.invalidate() }
    }
    open override var isEnabled: Bool {
        didSet { self.invalidate() }
    }
    open override var contentHorizontalAlignment: UIControlContentHorizontalAlignment {
        didSet { self.invalidate() }
    }
    open override var contentVerticalAlignment: UIControlContentVerticalAlignment {
        didSet { self.invalidate() }
    }
    @IBInspectable public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet { self.invalidate() }
    }
    public var imagePosition: QButtonImagePosition = .left {
        didSet { self.invalidate() }
    }
    public var imageInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet { self.invalidate() }
    }
    public var textInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet { self.invalidate() }
    }
    public var normalStyle: IQButtonStyle? {
        didSet { self.invalidate() }
    }
    public var highlightedStyle: IQButtonStyle? {
        didSet { self.invalidate() }
    }
    public var disabledStyle: IQButtonStyle? {
        didSet { self.invalidate() }
    }
    public var selectedStyle: IQButtonStyle? {
        didSet { self.invalidate() }
    }
    public var selectedHighlightedStyle: IQButtonStyle? {
        didSet { self.invalidate() }
    }
    public var selectedDisabledStyle: IQButtonStyle? {
        didSet { self.invalidate() }
    }
    public private(set) var backgroundView: QDisplayView!
    public private(set) var contentView: QView!
    public private(set) var imageView: QImageView!
    public private(set) var textLabel: QLabel!
    public private(set) var tapGesture: UITapGestureRecognizer!
    public var spinnerPosition: QButtonSpinnerPosition = .fill {
        didSet { self.invalidate() }
    }
    public var spinnerView: QSpinnerViewType? {
        willSet {
            if let spinnerView = self.spinnerView {
                spinnerView.removeFromSuperview()
            }
        }
        didSet {
            if let spinnerView = self.spinnerView {
                spinnerView.translatesAutoresizingMaskIntoConstraints = false
                self.contentView.addSubview(spinnerView)
            }
            self.invalidate()
        }
    }
    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.selfConstraints) }
        didSet { self.addConstraints(self.selfConstraints) }
    }
    private var contentConstraints: [NSLayoutConstraint] = [] {
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

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init(frame: CGRect, styleSheet: QButtonStyleSheet) {
        self.init(frame: frame)
        styleSheet.apply(target: self)
    }

    public convenience init(styleSheet: QButtonStyleSheet) {
        self.init(frame: CGRect.zero)
        styleSheet.apply(target: self)
        self.sizeToFit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.backgroundView = QDisplayView(frame: self.bounds)
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.isUserInteractionEnabled = false
        self.backgroundView.backgroundColor = UIColor.clear
        self.addSubview(self.backgroundView)

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

        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self._gestureHandler(_:)))
        self.tapGesture.delegate = self
        self.addGestureRecognizer(self.tapGesture)
        
        self.invalidate()
    }

    public func isSpinnerAnimating() -> Bool {
        if let spinnerView = self.spinnerView {
            return spinnerView.isAnimating()
        }
        return false
    }

    public func startSpinner() {
        if let spinnerView = self.spinnerView {
            spinnerView.start()
            self.invalidate()
        }
    }

    public func stopSpinner() {
        if let spinnerView = self.spinnerView {
            spinnerView.stop()
            self.invalidate()
        }
    }

    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        if let imageView = self.imageView {
            imageView.invalidateIntrinsicContentSize()
        }
        if let textLabel = self.textLabel {
            textLabel.preferredMaxLayoutWidth = self.bounds.width
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let contentSize = CGSize(
            width: size.width - (self.contentInsets.left + self.contentInsets.right),
            height: size.height - (self.contentInsets.top + self.contentInsets.bottom)
        )
        var imageSize = CGSize.zero
        var textSize = CGSize.zero
        if self.isSpinnerAnimating() == true {
            let spinnerSizeThatFits = self.spinnerView!.sizeThatFits(contentSize)
            imageSize = CGSize(
                width: self.imageInsets.left + spinnerSizeThatFits.width + self.imageInsets.right,
                height: self.imageInsets.top + spinnerSizeThatFits.height + self.imageInsets.bottom
            )
            switch self.spinnerPosition {
            case .fill:
                break
            case .image:
                if self.textLabel.alpha > CGFloat.leastNonzeroMagnitude {
                    let textSizeThatFits = self.textLabel.sizeThatFits(contentSize)
                    textSize = CGSize(
                        width: self.textInsets.left + textSizeThatFits.width + self.textInsets.right,
                        height: self.textInsets.top + textSizeThatFits.height + self.textInsets.bottom
                    )
                }
                break
            }
        } else {
            if self.imageView.alpha > CGFloat.leastNonzeroMagnitude {
                let imageSizeThatFits = self.imageView.sizeThatFits(CGSize.zero)
                imageSize = CGSize(
                    width: self.imageInsets.left + imageSizeThatFits.width + self.imageInsets.right,
                    height: self.imageInsets.top + imageSizeThatFits.height + self.imageInsets.bottom
                )
            }
            if self.textLabel.alpha > CGFloat.leastNonzeroMagnitude {
                let textSizeThatFits = self.textLabel.sizeThatFits(contentSize)
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
        var frame = self.frame
        frame.size = self.sizeThatFits(CGSize(
            width: Const.defaultSize,
            height: Const.defaultSize
        ))
        self.frame = frame
    }

    open override func updateConstraints() {
        var selfConstraints: [NSLayoutConstraint] = []
        selfConstraints.append(self.backgroundView.topLayout == self.topLayout)
        selfConstraints.append(self.backgroundView.leadingLayout == self.leadingLayout)
        selfConstraints.append(self.backgroundView.trailingLayout == self.trailingLayout)
        selfConstraints.append(self.backgroundView.bottomLayout == self.bottomLayout)
        let horizontalAlignment = self.contentHorizontalAlignment
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
        let verticalAlignment = self.contentVerticalAlignment
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
                self._updateContent(constraints: &contentConstraints, view: self.spinnerView!)
                switch self.imagePosition {
                case .top:
                    self._updateContent(constraints: &contentConstraints,
                                       topView: self.imageView, topEdgeInsets: self.imageInsets,
                                       bottomView: self.spinnerView!, bottomEdgeInsets: UIEdgeInsets.zero)
                    self._updateContent(constraints: &contentConstraints,
                                       topView: self.spinnerView!, topEdgeInsets: UIEdgeInsets.zero,
                                       bottomView: self.textLabel, bottomEdgeInsets: self.textInsets)
                case .left:
                    self._updateContent(constraints: &contentConstraints,
                                       leftView: self.imageView, leftEdgeInsets: self.imageInsets,
                                       rightView: self.spinnerView!, rightEdgeInsets: UIEdgeInsets.zero)
                    self._updateContent(constraints: &contentConstraints,
                                       leftView: self.spinnerView!, leftEdgeInsets: UIEdgeInsets.zero,
                                       rightView: self.textLabel, rightEdgeInsets: self.textInsets)
                case .right:
                    self._updateContent(constraints: &contentConstraints,
                                       leftView: self.textLabel, leftEdgeInsets: self.textInsets,
                                       rightView: self.spinnerView!, rightEdgeInsets: UIEdgeInsets.zero)
                    self._updateContent(constraints: &contentConstraints,
                                       leftView: self.spinnerView!, leftEdgeInsets: UIEdgeInsets.zero,
                                       rightView: self.imageView, rightEdgeInsets: self.imageInsets)
                case .bottom:
                    self._updateContent(constraints: &contentConstraints,
                                       topView: self.textLabel, topEdgeInsets: self.textInsets,
                                       bottomView: self.spinnerView!, bottomEdgeInsets: UIEdgeInsets.zero)
                    self._updateContent(constraints: &contentConstraints,
                                       topView: self.spinnerView!, topEdgeInsets: UIEdgeInsets.zero,
                                       bottomView: self.imageView, bottomEdgeInsets: self.imageInsets)
                }
                break
            case .image:
                switch self.imagePosition {
                case .top: self._updateContent(constraints: &contentConstraints,
                                              topView: self.spinnerView!, topEdgeInsets: self.imageInsets,
                                              bottomView: self.textLabel, bottomEdgeInsets: self.textInsets)
                case .left: self._updateContent(constraints: &contentConstraints,
                                               leftView: self.spinnerView!, leftEdgeInsets: self.imageInsets,
                                               rightView: self.textLabel, rightEdgeInsets: self.textInsets)
                case .right: self._updateContent(constraints: &contentConstraints,
                                                leftView: self.textLabel, leftEdgeInsets: self.textInsets,
                                                rightView: self.spinnerView!, rightEdgeInsets: self.imageInsets)
                case .bottom: self._updateContent(constraints: &contentConstraints,
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
                case .top: self._updateContent(constraints: &contentConstraints,
                                              topView: self.imageView, topEdgeInsets: self.imageInsets,
                                              bottomView: self.textLabel, bottomEdgeInsets: self.textInsets)
                case .left: self._updateContent(constraints: &contentConstraints,
                                               leftView: self.imageView, leftEdgeInsets: self.imageInsets,
                                               rightView: self.textLabel, rightEdgeInsets: self.textInsets)
                case .right: self._updateContent(constraints: &contentConstraints,
                                                leftView: self.textLabel, leftEdgeInsets: self.textInsets,
                                                rightView: self.imageView, rightEdgeInsets: self.imageInsets)
                case .bottom: self._updateContent(constraints: &contentConstraints,
                                                 topView: self.textLabel, topEdgeInsets: self.textInsets,
                                                 bottomView: self.imageView, bottomEdgeInsets: self.imageInsets)
                }
            } else {
                self._updateContent(constraints: &contentConstraints, view: self.imageView, edgeInsets: self.imageInsets)
                self._updateContent(constraints: &contentConstraints, view: self.textLabel, edgeInsets: self.textInsets)
            }
        }
        if self.isSpinnerAnimating() == false && self.imageView.alpha <= CGFloat.leastNonzeroMagnitude && self.textLabel.alpha <= CGFloat.leastNonzeroMagnitude {
            contentConstraints.append(self.contentView.widthLayout == 0)
            contentConstraints.append(self.contentView.heightLayout == 0)
        }
        self.contentConstraints = contentConstraints
        super.updateConstraints()
    }

    private func invalidate() {
        self.invalidateIntrinsicContentSize()
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        self._applyStyle()
    }

    private func _currentStyle() -> IQButtonStyle? {
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

    private func _applyStyle() {
        if let style = self._currentStyle() {
            self._applyStyle(style)
        }
    }

    private func _applyStyle(_ style: IQButtonStyle) {
        if let color = style.color {
            self.backgroundView.backgroundColor = color
        }
        if let border = style.border {
            self.backgroundView.border = border
        }
        if let cornerRadius = style.cornerRadius {
            self.backgroundView.cornerRadius = cornerRadius
        }
        if let shadow = style.shadow {
            self.backgroundView.shadow = shadow
        }
        if self.isSpinnerAnimating() == true {
            self.isUserInteractionEnabled = false
            switch self.spinnerPosition {
            case .fill:
                self._resetImageStyle()
                self._resetTextStyle()
                break
            case .image:
                self._resetImageStyle()
                self._applyTextStyle(style)
                break
            }
        } else {
            self.isUserInteractionEnabled = true
            self._applyImageStyle(style)
            self._applyTextStyle(style)
        }
    }

    private func _applyImageStyle(_ style: IQButtonStyle) {
        if let image = style.image {
            self.imageView.source = image
            self.imageView.alpha = 1
        } else {
            self._resetImageStyle()
        }
    }

    private func _resetImageStyle() {
        self.imageView.alpha = 0
    }

    private func _applyTextStyle(_ style: IQButtonStyle) {
        if let text = style.text {
            self.textLabel.text = text
            self.textLabel.alpha = 1
        } else {
            self._resetTextStyle()
        }
    }

    private func _resetTextStyle() {
        self.textLabel.alpha = 0
    }

    private func _updateContent(constraints: inout [NSLayoutConstraint], view: UIView) {
        constraints.append(view.topLayout == self.contentView.topLayout)
        constraints.append(view.leadingLayout == self.contentView.leadingLayout)
        constraints.append(view.trailingLayout <= self.contentView.trailingLayout)
        constraints.append(view.bottomLayout <= self.contentView.bottomLayout)
        constraints.append(view.centerXLayout == self.contentView.centerXLayout)
        constraints.append(view.centerYLayout == self.contentView.centerYLayout)
    }

    private func _updateContent(constraints: inout [NSLayoutConstraint], view: UIView, edgeInsets: UIEdgeInsets) {
        constraints.append(view.topLayout == self.contentView.topLayout + edgeInsets.top)
        constraints.append(view.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
        constraints.append(view.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
        constraints.append(view.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
        constraints.append(view.centerXLayout == self.contentView.centerXLayout)
        constraints.append(view.centerYLayout == self.contentView.centerYLayout)
    }

    private func _updateContent(
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

    private func _updateContent(
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

    @objc
    private func _gestureHandler(_ sender: Any) {
        self.sendActions(for: .touchUpInside)
    }

    private struct Const {

        static let defaultSize: CGFloat = 1024 * 1024

    }

}

extension QButton : UIGestureRecognizerDelegate {

    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.tapGesture == gestureRecognizer {
            let location = self.tapGesture.location(in: self)
            return self.bounds.contains(location)
        }
        return false
    }

}
