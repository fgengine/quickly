//
//  Quickly
//

open class QPagebarTitleItem : QPagebarItem {

    public var edgeInsets: UIEdgeInsets
    public var title: QLabelStyleSheet
    public var backgroundColor: UIColor?
    public var selectedBackgroundColor: UIColor?

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
        title: QLabelStyleSheet,
        backgroundColor: UIColor? = nil,
        selectedBackgroundColor: UIColor? = nil
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.edgeInsets = edgeInsets
        super.init(
            canSelect: true,
            canDeselect: true
        )
    }

}

open class QPagebarTitleCell< ItemType: QPagebarTitleItem > : QPagebarCell< ItemType > {

    private lazy var _titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    private var _edgeInsets: UIEdgeInsets?
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }

    open override class func size(
        item: ItemType,
        layout: UICollectionViewLayout,
        section: IQCollectionSection,
        spec: IQContainerSpec
    ) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (item.edgeInsets.left + item.edgeInsets.right)
        let textSize = item.title.text.size(width: availableWidth)
        return CGSize(
            width: item.edgeInsets.left + textSize.width + item.edgeInsets.right,
            height: spec.containerSize.height
        )
    }

    open override func set(item: ItemType, spec: IQContainerSpec, animated: Bool) {
        super.set(item: item, spec: spec, animated: animated)

        if let backgroundColor = item.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let selectedBackgroundColor = item.selectedBackgroundColor {
            let view = UIView(frame: self.bounds)
            view.backgroundColor = selectedBackgroundColor
            self.selectedBackgroundView = view
        } else {
            self.selectedBackgroundView = nil
        }

        if self._edgeInsets != item.edgeInsets {
            self._edgeInsets = item.edgeInsets
            self._constraints = [
                self._titleLabel.topLayout == self.contentView.topLayout + item.edgeInsets.top,
                self._titleLabel.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left,
                self._titleLabel.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right,
                self._titleLabel.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom
            ]
        }
        self._titleLabel.apply(item.title)
    }

}
