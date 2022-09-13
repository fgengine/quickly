//
//  Quickly
//

import UIKit

open class QImageTitleDetailComposable : QComposable {

    public var imageStyle: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public var titleStyle: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var detailStyle: QLabelStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        imageStyle: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        titleStyle: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        detailStyle: QLabelStyleSheet
    ) {
        self.imageStyle = imageStyle
        self.imageWidth = imageWidth
        self.imageSpacing = imageSpacing
        self.titleStyle = titleStyle
        self.titleSpacing = titleSpacing
        self.detailStyle = detailStyle
        super.init(edgeInsets: edgeInsets)
    }

}

open class QImageTitleDetailComposition< Composable: QImageTitleDetailComposable > : QComposition< Composable > {

    public private(set) lazy var imageView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var titleView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var detailView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?
    private var _imageSpacing: CGFloat?
    private var _titleSpacing: CGFloat?
    private var _imageWidth: CGFloat?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _imageConstraints: [NSLayoutConstraint] = [] {
        willSet { self.imageView.removeConstraints(self._imageConstraints) }
        didSet { self.imageView.addConstraints(self._imageConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let imageSize = composable.imageStyle.size(CGSize(width: composable.imageWidth, height: availableWidth))
        let titleTextSize = composable.titleStyle.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing))
        let detailTextSize = composable.detailStyle.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(imageSize.height, titleTextSize.height + composable.titleSpacing + detailTextSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._imageSpacing != composable.imageSpacing || self._titleSpacing != composable.titleSpacing {
            self._edgeInsets = composable.edgeInsets
            self._imageSpacing = composable.imageSpacing
            self._titleSpacing = composable.titleSpacing
            self._constraints = [
                self.imageView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.imageView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.imageView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.leadingLayout == self.imageView.trailingLayout.offset(composable.imageSpacing),
                self.titleView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.titleView.bottomLayout <= self.detailView.topLayout.offset(-composable.titleSpacing),
                self.detailView.leadingLayout == self.imageView.trailingLayout.offset(composable.imageSpacing),
                self.detailView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.detailView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
        if self._imageWidth != composable.imageWidth {
            self._imageWidth = composable.imageWidth
            self._imageConstraints = [
                self.imageView.widthLayout == composable.imageWidth
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.imageView.apply(composable.imageStyle)
        self.titleView.apply(composable.titleStyle)
        self.detailView.apply(composable.detailStyle)
    }

}
