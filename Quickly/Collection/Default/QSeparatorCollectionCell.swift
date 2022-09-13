//
//  Quickly
//

import UIKit

open class QSeparatorCollectionItem : QBackgroundColorCollectionItem {

    public var edgeInsets: UIEdgeInsets
    public var axis: NSLayoutConstraint.Axis
    public var color: UIColor

    public init(
        axis: NSLayoutConstraint.Axis,
        color: UIColor,
        backgroundColor: UIColor? = nil,
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    ) {
        self.edgeInsets = edgeInsets
        self.axis = axis
        self.color = color
        super.init(
            backgroundColor: backgroundColor,
            canSelect: false
        )
    }

}

open class QSeparatorCollectionCell< Item: QSeparatorCollectionItem > : QBackgroundColorCollectionCell< Item > {

    public private(set) var lineView: QView!

    private var _edgeInsets: UIEdgeInsets?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }

    open override class func size(
        item: Item,
        layout: UICollectionViewLayout,
        section: IQCollectionSection,
        spec: IQContainerSpec
    ) -> CGSize {
        let separatorSize = (1 / UIScreen.main.scale)
        switch item.axis {
        case .horizontal:
            return CGSize(
                width: item.edgeInsets.left + separatorSize + item.edgeInsets.right,
                height: spec.containerSize.height
            )
        case .vertical:
            return CGSize(
                width: spec.containerSize.width,
                height: item.edgeInsets.top + separatorSize + item.edgeInsets.bottom
            )
        @unknown default: return CGSize.zero
        }
    }

    open override func setup() {
        super.setup()

        self.lineView = self.prepareLineView()
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.lineView)
    }

    open func prepareLineView() -> QView {
        return QView(frame: self.contentView.bounds)
    }

    open override func set(item: Item, spec: IQContainerSpec, animated: Bool) {
        super.set(item: item, spec: spec, animated: animated)

        if self._edgeInsets != item.edgeInsets {
            self._edgeInsets = item.edgeInsets
            self._constraints = [
                self.lineView.topLayout == self.contentView.topLayout.offset(item.edgeInsets.top),
                self.lineView.leadingLayout == self.contentView.leadingLayout.offset(item.edgeInsets.left),
                self.lineView.trailingLayout == self.contentView.trailingLayout.offset(-item.edgeInsets.right),
                self.lineView.bottomLayout == self.contentView.bottomLayout.offset(-item.edgeInsets.bottom)
            ]
        }
        self.lineView.backgroundColor = item.color
    }

}
