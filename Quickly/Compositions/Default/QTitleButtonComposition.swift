//
//  Quickly
//

open class QTitleButtonComposable : QComposable {

    public typealias Closure = (_ composable: QTitleButtonComposable) -> Void

    public var title: QLabelStyleSheet

    public var button: QButtonStyleSheet
    public var buttonHeight: CGFloat
    public var buttonSpacing: CGFloat
    public var buttonIsSpinnerAnimating: Bool
    public var buttonPressed: Closure

    public init(
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
        title: QLabelStyleSheet,
        button: QButtonStyleSheet,
        buttonHeight: CGFloat = 44,
        buttonSpacing: CGFloat = 4,
        buttonPressed: @escaping Closure
    ) {
        self.title = title
        self.button = button
        self.buttonHeight = buttonHeight
        self.buttonSpacing = buttonSpacing
        self.buttonIsSpinnerAnimating = false
        self.buttonPressed = buttonPressed
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleButtonComposition< Composable: QTitleButtonComposable > : QComposition< Composable > {

    public private(set) var titleLabel: QLabel!
    public private(set) var button: QButton!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentButtonSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let textSize = composable.title.text.size(width: availableWidth).ceil()
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(textSize.height, composable.buttonHeight) + composable.edgeInsets.bottom
        )
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.button = QButton(frame: self.contentView.bounds)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.button.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.button.addTouchUpInside(self, action: #selector(self.pressedButton(_:)))
        self.contentView.addSubview(self.button)
    }
    
    open override func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        super.prepare(composable: composable, spec: spec, animated: animated)
        
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets || self.currentButtonSpacing != composable.buttonSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentButtonSpacing = composable.buttonSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.titleLabel.trailingLayout == self.button.leadingLayout - composable.buttonSpacing)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            selfConstraints.append(self.button.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.button.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.button.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        composable.title.apply(target: self.titleLabel)
        composable.button.apply(target: self.button)
        if composable.buttonIsSpinnerAnimating == true {
            self.button.startSpinner()
        } else {
            self.button.stopSpinner()
        }
    }

    public func isSpinnerAnimating() -> Bool {
        return self.button.isSpinnerAnimating()
    }

    public func startSpinner() {
        if let composable = self.composable {
            composable.buttonIsSpinnerAnimating = true
            self.button.startSpinner()
        }
    }

    public func stopSpinner() {
        if let composable = self.composable {
            composable.buttonIsSpinnerAnimating = false
            self.button.stopSpinner()
        }
    }

    @objc
    private func pressedButton(_ sender: Any) {
        if let composable = self.composable {
            composable.buttonPressed(composable)
        }
    }

}
