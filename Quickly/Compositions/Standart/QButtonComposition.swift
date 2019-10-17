//
//  Quickly
//

open class QButtonComposable : QComposable {

    public typealias Closure = (_ composable: QButtonComposable) -> Void

    public var buttonStyle: QButtonStyleSheet
    public var buttonHeight: CGFloat
    public var buttonIsSpinnerAnimating: Bool
    public var buttonPressed: Closure

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        buttonStyle: QButtonStyleSheet,
        buttonHeight: CGFloat = 44,
        buttonPressed: @escaping Closure
    ) {
        self.buttonStyle = buttonStyle
        self.buttonHeight = buttonHeight
        self.buttonIsSpinnerAnimating = false
        self.buttonPressed = buttonPressed
        super.init(edgeInsets: edgeInsets)
    }

}

open class QButtonComposition< Composable: QButtonComposable > : QComposition< Composable > {

    public private(set) lazy var buttonView: QButton = {
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
                self.buttonView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.buttonView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.buttonView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.buttonView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.buttonView.apply(composable.buttonStyle)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        if composable.buttonIsSpinnerAnimating == true {
            self.buttonView.startSpinner()
        } else {
            self.buttonView.stopSpinner()
        }
    }

    public func isSpinnerAnimating() -> Bool {
        return self.buttonView.isSpinnerAnimating()
    }

    public func startSpinner() {
        guard let composable = self.composable else { return }
        composable.buttonIsSpinnerAnimating = true
        self.buttonView.startSpinner()
    }

    public func stopSpinner() {
        guard let composable = self.composable else { return }
        composable.buttonIsSpinnerAnimating = false
        self.buttonView.stopSpinner()
    }

}
