//
//  Quickly
//

open class QTitleButtonCompositionData : QCompositionData {

    public typealias Closure = (_ data: QTitleButtonCompositionData) -> Void

    public var title: QLabelStyleSheet

    public var button: QButtonStyleSheet
    public var buttonHeight: CGFloat
    public var buttonSpacing: CGFloat
    public var buttonIsSpinnerAnimating: Bool
    public var buttonPressed: Closure

    public init(
        title: QLabelStyleSheet,
        button: QButtonStyleSheet,
        buttonPressed: @escaping Closure
    ) {
        self.title = title
        self.button = button
        self.buttonHeight = 44
        self.buttonSpacing = 8
        self.buttonIsSpinnerAnimating = false
        self.buttonPressed = buttonPressed
        super.init()
    }

}

public class QTitleButtonComposition< DataType: QTitleButtonCompositionData > : QComposition< DataType > {

    public private(set) var titleLabel: QLabel!
    public private(set) var button: QButton!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentButtonSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(data: DataType?, size: CGSize) -> CGSize {
        guard let data = data else { return CGSize.zero }
        let availableWidth = size.width - (data.edgeInsets.left + data.edgeInsets.right)
        let textSize = data.title.text.size(width: availableWidth)
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + max(textSize.height, data.buttonHeight) + data.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

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

    open override func prepare(data: DataType, animated: Bool) {
        if self.currentEdgeInsets != data.edgeInsets || self.currentButtonSpacing != data.buttonSpacing {
            self.currentEdgeInsets = data.edgeInsets
            self.currentButtonSpacing = data.buttonSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.titleLabel.trailingLayout == self.button.leadingLayout - data.buttonSpacing)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.button.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.button.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.button.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        data.title.apply(target: self.titleLabel)
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
        if let data = self.data {
            data.buttonIsSpinnerAnimating = true
            self.button.startSpinner()
        }
    }

    public func stopSpinner() {
        if let data = self.data {
            data.buttonIsSpinnerAnimating = false
            self.button.stopSpinner()
        }
    }

    @objc
    private func pressedButton(_ sender: Any) {
        if let data = self.data {
            data.buttonPressed(data)
        }
    }

}
