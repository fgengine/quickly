//
//  Quickly
//

public enum QButtonSpinnerPosition : Int {
    case fill
    case image
}

public enum QButtonImagePosition : Int {
    case top
    case left
    case right
    case bottom
}

public enum QButtonContentVerticalAlignment : Int {
    case center
    case top
    case bottom
    case fill
    
}

public enum QButtonContentHorizontalAlignment : Int {
    case center
    case left
    case right
    case fill
}

public class QButton : QView {
    
    public typealias Closure = (_ button: QButton) -> Void

    public var isHighlighted: Bool = false {
        didSet(oldValue) { if self.isHighlighted != oldValue { self._invalidate() } }
    }
    public var isSelected: Bool = false {
        didSet(oldValue) { if self.isSelected != oldValue { self._invalidate() } }
    }
    public var isEnabled: Bool = false {
        didSet(oldValue) { if self.isEnabled != oldValue { self._invalidate() } }
    }
    public var contentHorizontalAlignment: QButtonContentHorizontalAlignment = .fill {
        didSet(oldValue) { if self.contentHorizontalAlignment != oldValue { self._invalidate() } }
    }
    public var contentVerticalAlignment: QButtonContentVerticalAlignment = .fill {
        didSet(oldValue) { if self.contentVerticalAlignment != oldValue { self._invalidate() } }
    }
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet(oldValue) { if self.contentInsets != oldValue { self._invalidate() } }
    }
    public var imagePosition: QButtonImagePosition = .left {
        didSet(oldValue) { if self.imagePosition != oldValue { self._invalidate() } }
    }
    public var imageInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet(oldValue) { if self.imageInsets != oldValue { self._invalidate() } }
    }
    public var textInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet(oldValue) { if self.textInsets != oldValue { self._invalidate() } }
    }
    public var normalStyle: IQButtonStyle? {
        didSet(oldValue) { if self.normalStyle !== oldValue { self._invalidate() } }
    }
    public var highlightedStyle: IQButtonStyle? {
        didSet(oldValue) { if self.highlightedStyle !== oldValue { self._invalidate() } }
    }
    public var disabledStyle: IQButtonStyle? {
        didSet(oldValue) { if self.disabledStyle !== oldValue { self._invalidate() } }
    }
    public var selectedStyle: IQButtonStyle? {
        didSet(oldValue) { if self.selectedStyle !== oldValue { self._invalidate() } }
    }
    public var selectedHighlightedStyle: IQButtonStyle? {
        didSet(oldValue) { if self.selectedHighlightedStyle !== oldValue { self._invalidate() } }
    }
    public var selectedDisabledStyle: IQButtonStyle? {
        didSet(oldValue) { if self.selectedDisabledStyle !== oldValue { self._invalidate() } }
    }
    public var durationChangeState: TimeInterval = 0.075
    public private(set) lazy var backgroundView: QDisplayView = {
        let view = QDisplayView(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.clipsToBounds = false
        return view
    }()
    public private(set) lazy var contentView: QView = {
        let view = QView(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.clipsToBounds = false
        return view
    }()
    public private(set) lazy var imageView: QImageView = {
        let view = QImageView(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.alpha = 0
        return view
    }()
    public private(set) lazy var textLabel: QLabel = {
        let view = QLabel(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        view.alpha = 0
        return view
    }()
    public var spinnerPosition: QButtonSpinnerPosition = .fill {
        didSet(oldValue) { if self.spinnerPosition != oldValue { self._invalidate() } }
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
            self._invalidate()
        }
    }
    public private(set) lazy var pressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self._pressGestureHandler(_:)))
        gesture.delaysTouchesBegan = true
        gesture.minimumPressDuration = 0.02
        gesture.allowableMovement = self._pressGestureAllowableMovement()
        gesture.delegate = self
        return gesture
    }()
    public private(set) lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self._tapGestureHandler(_:)))
        gesture.delaysTouchesBegan = true
        gesture.delegate = self
        return gesture
    }()
    
    public var onPressed: Closure?
    
    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.selfConstraints) }
        didSet { self.addConstraints(self.selfConstraints) }
    }
    private var contentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.contentConstraints) }
        didSet { self.contentView.addConstraints(self.contentConstraints) }
    }

    open override var frame: CGRect {
        didSet(oldValue) {
            if self.frame != oldValue {
                self.pressGesture.allowableMovement = self._pressGestureAllowableMovement()
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    open override var bounds: CGRect {
        didSet(oldValue) {
            if self.bounds != oldValue {
                self.pressGesture.allowableMovement = self._pressGestureAllowableMovement()
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    open override var intrinsicContentSize: CGSize {
        get {
            return self.sizeThatFits(CGSize(
                width: CGFloat.greatestFiniteMagnitude,
                height: CGFloat.greatestFiniteMagnitude
            ))
        }
    }
    
    public required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init(frame: CGRect, styleSheet: QButtonStyleSheet) {
        self.init(frame: frame)
        styleSheet.apply(self)
    }

    public convenience init(styleSheet: QButtonStyleSheet) {
        self.init(frame: CGRect.zero)
        styleSheet.apply(self)
        self.sizeToFit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear

        self.addSubview(self.backgroundView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.textLabel)

        self.addGestureRecognizer(self.pressGesture)
        self.addGestureRecognizer(self.tapGesture)
        
        self._invalidate()
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
            self._invalidate()
        }
    }

    public func stopSpinner() {
        if let spinnerView = self.spinnerView {
            spinnerView.stop()
            self._invalidate()
        }
    }

    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        self.imageView.invalidateIntrinsicContentSize()
        self.textLabel.invalidateIntrinsicContentSize()
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
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        ))
        self.frame = frame
    }

    open override func updateConstraints() {
        var selfConstraints: [NSLayoutConstraint] = [
            self.backgroundView.topLayout == self.topLayout,
            self.backgroundView.leadingLayout == self.leadingLayout,
            self.backgroundView.trailingLayout == self.trailingLayout,
            self.backgroundView.bottomLayout == self.bottomLayout
        ]
        switch self.contentHorizontalAlignment {
        case .fill:
            selfConstraints.append(contentsOf: [
                self.contentView.leadingLayout == self.leadingLayout + self.contentInsets.left,
                self.contentView.trailingLayout == self.trailingLayout - self.contentInsets.right
            ])
        case .left:
            selfConstraints.append(contentsOf: [
                self.contentView.leadingLayout == self.leadingLayout + self.contentInsets.left,
                self.contentView.trailingLayout <= self.trailingLayout - self.contentInsets.right
            ])
        case .center:
            selfConstraints.append(contentsOf: [
                self.contentView.centerXLayout == self.centerXLayout,
                self.contentView.leadingLayout >= self.leadingLayout + self.contentInsets.left,
                self.contentView.trailingLayout <= self.trailingLayout - self.contentInsets.right
            ])
        case .right:
            selfConstraints.append(contentsOf: [
                self.contentView.leadingLayout >= self.leadingLayout + self.contentInsets.left,
                self.contentView.trailingLayout == self.trailingLayout - self.contentInsets.right
            ])
        }
        switch self.contentVerticalAlignment {
        case .fill:
            selfConstraints.append(contentsOf: [
                self.contentView.topLayout == self.topLayout + self.contentInsets.top,
                self.contentView.bottomLayout == self.bottomLayout - self.contentInsets.bottom
            ])
        case .top:
            selfConstraints.append(contentsOf: [
                self.contentView.topLayout == self.topLayout + self.contentInsets.top,
                self.contentView.bottomLayout <= self.bottomLayout - self.contentInsets.bottom
            ])
        case .center:
            selfConstraints.append(contentsOf: [
                self.contentView.centerYLayout == self.centerYLayout,
                self.contentView.topLayout >= self.topLayout + self.contentInsets.top,
                self.contentView.bottomLayout <= self.bottomLayout - self.contentInsets.bottom
            ])
        case .bottom:
            selfConstraints.append(contentsOf: [
                self.contentView.topLayout >= self.topLayout + self.contentInsets.top,
                self.contentView.bottomLayout == self.bottomLayout - self.contentInsets.bottom
            ])
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

    private func _invalidate() {
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
            image.apply(self.imageView)
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
            text.apply(self.textLabel)
            self.textLabel.alpha = 1
        } else {
            self._resetTextStyle()
        }
    }

    private func _resetTextStyle() {
        self.textLabel.alpha = 0
    }

    private func _updateContent(constraints: inout [NSLayoutConstraint], view: UIView) {
        constraints.append(contentsOf: [
            view.topLayout == self.contentView.topLayout,
            view.leadingLayout == self.contentView.leadingLayout,
            view.trailingLayout == self.contentView.trailingLayout,
            view.bottomLayout == self.contentView.bottomLayout,
            view.centerXLayout == self.contentView.centerXLayout,
            view.centerYLayout == self.contentView.centerYLayout
        ])
    }

    private func _updateContent(constraints: inout [NSLayoutConstraint], view: UIView, edgeInsets: UIEdgeInsets) {
        constraints.append(contentsOf: [
            view.topLayout == self.contentView.topLayout + edgeInsets.top,
            view.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
            view.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
            view.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
            view.centerXLayout == self.contentView.centerXLayout,
            view.centerYLayout == self.contentView.centerYLayout
        ])
    }

    private func _updateContent(
        constraints: inout [NSLayoutConstraint],
        topView: UIView,
        topEdgeInsets: UIEdgeInsets,
        bottomView: UIView,
        bottomEdgeInsets: UIEdgeInsets
    ) {
        constraints.append(contentsOf: [
            topView.leadingLayout == self.contentView.leadingLayout + topEdgeInsets.left,
            topView.trailingLayout == self.contentView.trailingLayout - topEdgeInsets.right,
            topView.centerXLayout == self.contentView.centerXLayout
        ])
        if topView.alpha <= CGFloat.leastNonzeroMagnitude {
            constraints.append(contentsOf: [
                bottomView.topLayout == self.contentView.topLayout + bottomEdgeInsets.top,
                bottomView.bottomLayout == self.contentView.bottomLayout - bottomEdgeInsets.bottom
            ])
        } else if bottomView.alpha <= CGFloat.leastNonzeroMagnitude {
            constraints.append(contentsOf: [
                topView.topLayout == self.contentView.topLayout + topEdgeInsets.top,
                topView.bottomLayout == self.contentView.bottomLayout - topEdgeInsets.bottom
            ])
        } else {
            constraints.append(contentsOf: [
                topView.topLayout == self.contentView.topLayout + topEdgeInsets.top,
                bottomView.bottomLayout == self.contentView.bottomLayout - bottomEdgeInsets.bottom
            ])
        }
        constraints.append(contentsOf: [
            bottomView.topLayout == topView.bottomLayout + (topEdgeInsets.bottom + bottomEdgeInsets.top),
            bottomView.leadingLayout == self.contentView.leadingLayout + bottomEdgeInsets.left,
            bottomView.trailingLayout == self.contentView.trailingLayout - bottomEdgeInsets.right,
            bottomView.centerXLayout == self.contentView.centerXLayout
        ])
    }

    private func _updateContent(
        constraints: inout [NSLayoutConstraint],
        leftView: UIView,
        leftEdgeInsets: UIEdgeInsets,
        rightView: UIView,
        rightEdgeInsets: UIEdgeInsets
    ) {
        constraints.append(contentsOf: [
            leftView.topLayout == self.contentView.topLayout + leftEdgeInsets.top,
            leftView.trailingLayout == rightView.leadingLayout - (leftEdgeInsets.right + rightEdgeInsets.left),
            leftView.bottomLayout == self.contentView.bottomLayout - leftEdgeInsets.bottom,
            leftView.centerYLayout == self.contentView.centerYLayout
        ])
        constraints.append(contentsOf: [
            rightView.topLayout == self.contentView.topLayout + rightEdgeInsets.top,
            rightView.bottomLayout == self.contentView.bottomLayout - rightEdgeInsets.bottom,
            rightView.centerYLayout == self.contentView.centerYLayout
        ])
        if leftView.alpha <= CGFloat.leastNonzeroMagnitude {
            constraints.append(contentsOf: [
                rightView.leadingLayout == self.contentView.leadingLayout + rightEdgeInsets.left,
                rightView.trailingLayout == self.contentView.trailingLayout - rightEdgeInsets.right
            ])
        } else if rightView.alpha <= CGFloat.leastNonzeroMagnitude {
            constraints.append(contentsOf: [
                leftView.leadingLayout == self.contentView.leadingLayout + leftEdgeInsets.left,
                leftView.trailingLayout == self.contentView.trailingLayout - leftEdgeInsets.right
            ])
        } else {
            constraints.append(contentsOf: [
                leftView.leadingLayout == self.contentView.leadingLayout + leftEdgeInsets.left,
                rightView.trailingLayout == self.contentView.trailingLayout - rightEdgeInsets.right
            ])
        }
    }
    
}

extension QButton {
    
    private func _pressGestureAllowableMovement() -> CGFloat {
        return min(self.frame.width, self.frame.height) * 1.5
    }
    
}

extension QButton {
    
    @objc
    private func _pressGestureHandler(_ sender: Any) {
        var isHighlighted = self.isHighlighted
        switch self.pressGesture.state {
        case .began: isHighlighted = true
        default: isHighlighted = false
        }
        if isHighlighted != self.isHighlighted {
            UIView.animate(withDuration: self.durationChangeState, delay: 0, options: [ .beginFromCurrentState ], animations: {
                self.isHighlighted = isHighlighted
                self.layoutIfNeeded()
            })
        }
    }

    @objc
    private func _tapGestureHandler(_ sender: Any) {
        guard let onPressed = self.onPressed else { return }
        onPressed(self)
    }

}

extension QButton : UIGestureRecognizerDelegate {

    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self)
        return self.bounds.contains(location)
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let otherView = otherGestureRecognizer.view else { return false }
        return self.isDescendant(of: otherView)
    }

}
