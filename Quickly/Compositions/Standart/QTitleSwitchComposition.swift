//
//  Quickly
//

open class QTitleSwitchComposable : QComposable {

    public typealias Closure = (_ composable: QTitleSwitchComposable) -> Void

    public var title: QLabelStyleSheet

    public var `switch`: QSwitchStyleSheet
    public var switchHeight: CGFloat
    public var switchSpacing: CGFloat
    public var switchIsOn: Bool
    public var switchChanged: Closure

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QLabelStyleSheet,
        switch: QSwitchStyleSheet,
        switchHeight: CGFloat = 44,
        switchSpacing: CGFloat = 4,
        switchIsOn: Bool = false,
        switchChanged: @escaping Closure
    ) {
        self.title = title
        self.switch = `switch`
        self.switchHeight = switchHeight
        self.switchSpacing = switchSpacing
        self.switchIsOn = switchIsOn
        self.switchChanged = switchChanged
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleSwitchComposition< Composable: QTitleSwitchComposable > : QComposition< Composable > {

    private lazy var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var `switch`: QSwitch = {
        let view = QSwitch(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        view.onChanged = { [weak self] (`switch`, isOn) in
            guard let strong = self else { return }
            if let composable = strong.composable {
                composable.switchIsOn = strong.switch.isOn
                composable.switchChanged(composable)
            }
        }
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?
    private var _switchSpacing: CGFloat?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let textSize = composable.title.text.size(width: availableWidth)
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(textSize.height, composable.switchHeight) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._switchSpacing != composable.switchSpacing {
            self._edgeInsets = composable.edgeInsets
            self._switchSpacing = composable.switchSpacing
            self._constraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                self.titleLabel.trailingLayout == self.switch.leadingLayout - composable.switchSpacing,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.switch.topLayout >= self.contentView.topLayout + composable.edgeInsets.top,
                self.switch.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                self.switch.bottomLayout <= self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.switch.centerYLayout == self.contentView.centerYLayout
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleLabel.apply(composable.title)
        self.switch.apply(composable.switch)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.switch.setOn(composable.switchIsOn, animated: false)
    }
    
    open func setOn(_ on: Bool, animated: Bool) {
        if let composable = self.composable {
            composable.switchIsOn = on
        }
        self.switch.setOn(on, animated: animated)
    }

}
