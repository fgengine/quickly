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

    private lazy var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var button: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        view.onPressed = { [weak self] _ in
            guard let self = self, let composable = self.composable else { return }
            composable.buttonPressed(composable)
        }
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?
    private var _buttonSpacing: CGFloat?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let textSize = composable.title.size(width: availableWidth)
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(textSize.height, composable.buttonHeight) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._buttonSpacing != composable.buttonSpacing {
            self._edgeInsets = composable.edgeInsets
            self._buttonSpacing = composable.buttonSpacing
            self._constraints = [
                self.titleLabel.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleLabel.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleLabel.trailingLayout == self.button.leadingLayout.offset(-composable.buttonSpacing),
                self.titleLabel.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.button.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.button.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.button.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleLabel.apply(composable.title)
        self.button.apply(composable.button)
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

}
