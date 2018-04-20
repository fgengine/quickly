//
//  Quickly
//

open class QButtonCompositionData : QCompositionData {

    public typealias Closure = (_ data: QButtonCompositionData) -> Void

    public var button: QButtonStyleSheet
    public var buttonHeight: CGFloat
    public var buttonIsSpinnerAnimating: Bool
    public var buttonPressed: Closure

    public init(
        button: QButtonStyleSheet,
        buttonPressed: @escaping Closure
    ) {
        self.button = button
        self.buttonHeight = 44
        self.buttonIsSpinnerAnimating = false
        self.buttonPressed = buttonPressed
        super.init()
    }

}

open class QButtonComposition< DataType: QButtonCompositionData > : QComposition< DataType > {

    public private(set) var button: QButton!

    private var currentEdgeInsets: UIEdgeInsets?
    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(data: DataType?, size: CGSize) -> CGSize {
        guard let data = data else { return CGSize.zero }
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + data.buttonHeight + data.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.button = QButton(frame: self.contentView.bounds)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.addTouchUpInside(self, action: #selector(self.pressedButton(_:)))
        self.contentView.addSubview(self.button)
    }

    open override func prepare(data: DataType, animated: Bool) {
        if self.currentEdgeInsets != data.edgeInsets {
            self.currentEdgeInsets = data.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.button.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.button.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.button.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.button.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        data.button.apply(target: self.button)
        if data.buttonIsSpinnerAnimating == true {
            self.button.startSpinner()
        } else {
            self.button.stopSpinner()
        }
    }

    public func isSpinnerAnimating() -> Bool {
        return self.button.isSpinnerAnimating()
    }

    public func startSpinner() {
        guard let data = self.data else { return }
        data.buttonIsSpinnerAnimating = true
        self.button.startSpinner()
    }

    public func stopSpinner() {
        guard let data = self.data else { return }
        data.buttonIsSpinnerAnimating = false
        self.button.stopSpinner()
    }

    @objc
    private func pressedButton(_ sender: Any) {
        if let data = self.data {
            data.buttonPressed(data)
        }
    }

}
