//
//  Quickly
//

open class QSegmentComposable : QComposable {

    public typealias Closure = (_ composable: QSegmentComposable) -> Void

    public var segment: QSegmentStyleSheet
    public var segmentSelectedItem: QSegmentItem?
    public var segmentHeight: CGFloat
    public var segmentChanged: Closure

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        segment: QSegmentStyleSheet,
        segmentSelectedItem: QSegmentItem? = nil,
        segmentHeight: CGFloat = 44,
        segmentChanged: @escaping Closure
    ) {
        self.segment = segment
        self.segmentSelectedItem = segmentSelectedItem
        self.segmentHeight = segmentHeight
        self.segmentChanged = segmentChanged
        super.init(edgeInsets: edgeInsets)
    }

}

open class QSegmentComposition< Composable: QSegmentComposable > : QComposition< Composable > {

    private lazy var segment: QSegment = {
        let view = QSegment()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onSelected = { [weak self] (segment, selected) in
            guard let strong = self else { return }
            if let composable = strong.composable {
                composable.segmentSelectedItem = selected
                composable.segmentChanged(composable)
            }
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
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self._edgeInsets != edgeInsets {
            self._edgeInsets = edgeInsets
            self._constraints = [
                self.segment.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.segment.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.segment.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.segment.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.segment.apply(composable.segment)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.segment.selectedItem = composable.segmentSelectedItem
    }

}
