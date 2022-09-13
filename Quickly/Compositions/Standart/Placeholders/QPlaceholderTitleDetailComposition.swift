//
//  Quickly
//

import UIKit

open class QPlaceholderTitleDetailComposable : QComposable {
    
    public var titleStyle: QPlaceholderStyleSheet
    public var titleHeight: CGFloat
    public var titleSpacing: CGFloat
    
    public var detailStyle: QPlaceholderStyleSheet
    public var detailHeight: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        titleStyle: QPlaceholderStyleSheet,
        titleHeight: CGFloat,
        titleSpacing: CGFloat = 4,
        detailStyle: QPlaceholderStyleSheet,
        detailHeight: CGFloat
    ) {
        self.titleStyle = titleStyle
        self.titleHeight = titleHeight
        self.titleSpacing = titleSpacing
        self.detailStyle = detailStyle
        self.detailHeight = detailHeight
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QPlaceholderTitleDetailComposition< Composable: QPlaceholderTitleDetailComposable > : QComposition< Composable > {
    
    public private(set) lazy var titleView: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var detailView: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    private var _edgeInsets: UIEdgeInsets?
    private var _titleHeight: CGFloat?
    private var _titleSpacing: CGFloat?
    private var _detailHeight: CGFloat?
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _titleConstraints: [NSLayoutConstraint] = [] {
        willSet { self.titleView.removeConstraints(self._titleConstraints) }
        didSet { self.titleView.addConstraints(self._titleConstraints) }
    }
    private var _detailConstraints: [NSLayoutConstraint] = [] {
        willSet { self.detailView.removeConstraints(self._detailConstraints) }
        didSet { self.detailView.addConstraints(self._detailConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + composable.titleHeight + composable.titleSpacing + composable.detailHeight + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._titleSpacing != composable.titleSpacing {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._constraints = [
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.titleView.bottomLayout <= self.detailView.topLayout.offset(-composable.titleSpacing),
                self.detailView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.detailView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.detailView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
        if self._titleHeight != composable.titleHeight {
            self._titleHeight = composable.titleHeight
            self._titleConstraints = [
                self.titleView.heightLayout == composable.titleHeight
            ]
        }
        if self._detailHeight != composable.detailHeight {
            self._detailHeight = composable.detailHeight
            self._detailConstraints = [
                self.detailView.heightLayout == composable.detailHeight
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleView.apply(composable.titleStyle)
        self.detailView.apply(composable.detailStyle)
    }
    
}
