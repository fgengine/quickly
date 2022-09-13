//
//  Quickly
//

import UIKit

open class QTitleComposable : QComposable {

    public var titleStyle: QLabelStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        titleStyle: QLabelStyleSheet
    ) {
        self.titleStyle = titleStyle
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleComposition< Composable: QTitleComposable > : QComposition< Composable > {

    public private(set) lazy var titleView: QLabel = {
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
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let textSize = composable.titleStyle.size(width: availableWidth)
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + textSize.height + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets {
            self._edgeInsets = composable.edgeInsets
            self._constraints = [
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.titleView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleView.apply(composable.titleStyle)
    }

}
