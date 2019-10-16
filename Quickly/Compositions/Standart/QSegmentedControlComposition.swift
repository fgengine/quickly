//
//  Quickly
//

open class QSegmentedControlComposable : QComposable {

    public typealias Closure = (_ composable: QSegmentedControlComposable) -> Void

    public private(set) var segmentStyle: QSegmentedControlStyleSheet
    public fileprivate(set) var segmentSelectedItem: QSegmentedControl.Item?
    public private(set) var segmentHeight: CGFloat
    public private(set) var segmentChanged: Closure

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        segmentStyle: QSegmentedControlStyleSheet,
        segmentSelectedItem: QSegmentedControl.Item? = nil,
        segmentHeight: CGFloat = 44,
        segmentChanged: @escaping Closure
    ) {
        self.segmentStyle = segmentStyle
        self.segmentSelectedItem = segmentSelectedItem
        self.segmentHeight = segmentHeight
        self.segmentChanged = segmentChanged
        super.init(edgeInsets: edgeInsets)
    }

}

open class QSegmentedControlComposition< Composable: QSegmentedControlComposable > : QComposition< Composable > {

    public private(set) lazy var segmentView: QSegmentedControl = {
        let view = QSegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onSelected = { [weak self] (_, selected) in
            guard let self = self, let composable = self.composable else { return }
            composable.segmentSelectedItem = selected
            composable.segmentChanged(composable)
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
            height: composable.edgeInsets.top + composable.segmentHeight + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets {
            self._edgeInsets = composable.edgeInsets
            self._constraints = [
                self.segmentView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.segmentView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.segmentView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.segmentView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.segmentView.apply(composable.segmentStyle)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.segmentView.selectedItem = composable.segmentSelectedItem
    }

}
