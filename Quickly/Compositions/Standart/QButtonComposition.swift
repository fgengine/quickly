//
//  Quickly
//

open class QButtonComposable : QComposable {

    public typealias Closure = (_ composable: QButtonComposable) -> Void

    public var button: QButtonStyleSheet
    public var buttonHeight: CGFloat
    public var buttonIsSpinnerAnimating: Bool
    public var buttonPressed: Closure

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        button: QButtonStyleSheet,
        buttonHeight: CGFloat = 44,
        buttonPressed: @escaping Closure
    ) {
        self.button = button
        self.buttonHeight = buttonHeight
        self.buttonIsSpinnerAnimating = false
        self.buttonPressed = buttonPressed
        super.init(edgeInsets: edgeInsets)
    }

}

open class QButtonComposition< Composable: QButtonComposable > : QComposition< Composable > {

    private lazy var button: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onPressed = { [weak self] _ in
            guard let self = self, let composable = self.composable else { return }
            composable.buttonPressed(composable)
        }
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + composable.buttonHeight + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets {
            self._edgeInsets = composable.edgeInsets
            self._constraints = [
                self.button.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.button.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.button.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.button.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
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
        guard let composable = self.composable else { return }
        composable.buttonIsSpinnerAnimating = true
        self.button.startSpinner()
    }

    public func stopSpinner() {
        guard let composable = self.composable else { return }
        composable.buttonIsSpinnerAnimating = false
        self.button.stopSpinner()
    }

}
