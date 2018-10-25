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
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
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

    lazy private var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    lazy private var button: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        view.addTouchUpInside(self, action: #selector(self.pressedButton(_:)))
        self.contentView.addSubview(view)
        return view
    }()

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentButtonSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let textSize = composable.title.text.size(width: availableWidth)
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(textSize.height, composable.buttonHeight) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets || self.currentButtonSpacing != composable.buttonSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentButtonSpacing = composable.buttonSpacing
            self.selfConstraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.titleLabel.trailingLayout == self.button.leadingLayout - composable.buttonSpacing,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                self.button.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.button.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.button.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.title.apply(self.titleLabel)
        composable.button.apply(self.button)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
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
