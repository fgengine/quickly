//
//  Quickly
//

open class QTitleSwitchComposable : QComposable {

    public typealias Closure = (_ composable: QTitleSwitchComposable) -> Void

    public private(set) var titleStyle: QLabelStyleSheet

    public private(set) var switchStyle: QSwitchStyleSheet
    public private(set) var switchHeight: CGFloat
    public private(set) var switchSpacing: CGFloat
    public fileprivate(set) var switchIsOn: Bool
    public private(set) var switchChanged: Closure

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        titleStyle: QLabelStyleSheet,
        switchStyle: QSwitchStyleSheet,
        switchHeight: CGFloat = 44,
        switchSpacing: CGFloat = 4,
        switchIsOn: Bool = false,
        switchChanged: @escaping Closure
    ) {
        self.titleStyle = titleStyle
        self.switchStyle = switchStyle
        self.switchHeight = switchHeight
        self.switchSpacing = switchSpacing
        self.switchIsOn = switchIsOn
        self.switchChanged = switchChanged
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleSwitchComposition< Composable: QTitleSwitchComposable > : QComposition< Composable > {

    public private(set) lazy var titleView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var switchView: QSwitch = {
        let view = QSwitch(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        view.onChanged = { [weak self] (_, _) in
            guard let self = self, let composable = self.composable else { return }
            composable.switchIsOn = self.switchView.isOn
            composable.switchChanged(composable)
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
        let textSize = composable.titleStyle.size(width: availableWidth)
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
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleView.trailingLayout == self.switchView.leadingLayout.offset(-composable.switchSpacing),
                self.titleView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.switchView.topLayout >= self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.switchView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.switchView.bottomLayout <= self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.switchView.centerYLayout == self.contentView.centerYLayout
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleView.apply(composable.titleStyle)
        self.switchView.apply(composable.switchStyle)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.switchView.setOn(composable.switchIsOn, animated: false)
    }
    
    open func setOn(_ on: Bool, animated: Bool) {
        if let composable = self.composable {
            composable.switchIsOn = on
        }
        self.switchView.setOn(on, animated: animated)
    }

}
