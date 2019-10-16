//
//  Quickly
//

open class QTitleButtonComposable : QComposable {

    public typealias Closure = (_ composable: QTitleButtonComposable) -> Void

    public private(set) var titleStyle: QLabelStyleSheet

    public private(set) var buttonStyle: QButtonStyleSheet
    public private(set) var buttonIsHidden: Bool
    public private(set) var buttonHeight: CGFloat
    public private(set) var buttonSpacing: CGFloat
    public fileprivate(set) var buttonIsSpinnerAnimating: Bool
    public private(set) var buttonPressed: Closure

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        titleStyle: QLabelStyleSheet,
        buttonStyle: QButtonStyleSheet,
        buttonIsHidden: Bool = false,
        buttonHeight: CGFloat = 44,
        buttonSpacing: CGFloat = 4,
        buttonPressed: @escaping Closure
    ) {
        self.titleStyle = titleStyle
        self.buttonStyle = buttonStyle
        self.buttonIsHidden = buttonIsHidden
        self.buttonHeight = buttonHeight
        self.buttonSpacing = buttonSpacing
        self.buttonIsSpinnerAnimating = false
        self.buttonPressed = buttonPressed
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleButtonComposition< Composable: QTitleButtonComposable > : QComposition< Composable > {

    public private(set) lazy var titleView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var buttonView: QButton = {
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
    private var _buttonIsHidden: Bool?
    private var _buttonSpacing: CGFloat?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let textSize = composable.titleStyle.size(width: availableWidth)
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(textSize.height, composable.buttonHeight) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._buttonIsHidden != composable.buttonIsHidden || self._buttonSpacing != composable.buttonSpacing {
            self._edgeInsets = composable.edgeInsets
            self._buttonIsHidden = composable.buttonIsHidden
            self._buttonSpacing = composable.buttonSpacing
            var constraints: [NSLayoutConstraint] = [
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.buttonView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.buttonView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.buttonView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right)
            ]
            if composable.buttonIsHidden == false {
                constraints.append(contentsOf: [
                    self.titleView.trailingLayout == self.buttonView.leadingLayout.offset(-composable.buttonSpacing)
                ])
            } else {
                constraints.append(contentsOf: [
                    self.titleView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right)
                ])
            }
            self._constraints = constraints
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleView.apply(composable.titleStyle)
        self.buttonView.apply(composable.buttonStyle)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.buttonView.alpha = (composable.buttonIsHidden == false) ? 1 : 0
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
        if let composable = self.composable {
            composable.buttonIsSpinnerAnimating = true
            self.buttonView.startSpinner()
        }
    }

    public func stopSpinner() {
        if let composable = self.composable {
            composable.buttonIsSpinnerAnimating = false
            self.buttonView.stopSpinner()
        }
    }

}
