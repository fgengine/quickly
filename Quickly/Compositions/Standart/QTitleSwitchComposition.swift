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
        self.switchIsOn = false
        self.switchChanged = switchChanged
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleSwitchComposition< Composable: QTitleSwitchComposable > : QComposition< Composable > {

    lazy private var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    lazy private var `switch`: QSwitch = {
        let view = QSwitch(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        view.addValueChanged(self, action: #selector(self.pressedSwitch(_:)))
        self.contentView.addSubview(view)
        return view
    }()

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentSwitchSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let textSize = composable.title.text.size(width: availableWidth)
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(textSize.height, composable.switchHeight) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets || self.currentSwitchSpacing != composable.switchSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentSwitchSpacing = composable.switchSpacing
            self.selfConstraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.titleLabel.trailingLayout == self.switch.leadingLayout - composable.switchSpacing,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                self.switch.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.switch.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.switch.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.title.apply(self.titleLabel)
        composable.switch.apply(self.switch)
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

    @objc
    private func pressedSwitch(_ sender: Any) {
        if let composable = self.composable {
            composable.switchIsOn = self.switch.isOn
            composable.switchChanged(composable)
        }
    }

}
