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
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
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

    public private(set) var button: QButton!

    private var currentEdgeInsets: UIEdgeInsets?
    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(composable: Composable, size: CGSize) -> CGSize {
        return CGSize(
            width: size.width,
            height: composable.edgeInsets.top + composable.buttonHeight + composable.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.button = QButton(frame: self.contentView.bounds)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.addTouchUpInside(self, action: #selector(self.pressedButton(_:)))
        self.contentView.addSubview(self.button)
    }

    open override func prepare(composable: Composable, animated: Bool) {
        super.prepare(composable: composable, animated: animated)
        
        if self.currentEdgeInsets != composable.edgeInsets {
            self.currentEdgeInsets = composable.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.button.topLayout == self.contentView.topLayout + composable.edgeInsets.top)
            selfConstraints.append(self.button.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left)
            selfConstraints.append(self.button.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right)
            selfConstraints.append(self.button.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
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
        guard let composable = self.composable else { return }
        composable.buttonIsSpinnerAnimating = true
        self.button.startSpinner()
    }

    public func stopSpinner() {
        guard let composable = self.composable else { return }
        composable.buttonIsSpinnerAnimating = false
        self.button.stopSpinner()
    }

    @objc
    private func pressedButton(_ sender: Any) {
        if let composable = self.composable {
            composable.buttonPressed(composable)
        }
    }

}
