//
//  Quickly
//

import UIKit

open class QImageTitleButtonComposable : QComposable {

    public typealias Closure = (_ composable: QImageTitleButtonComposable) -> Void

    public var imageStyle: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public var titleStyle: QLabelStyleSheet

    public var buttonStyle: QButtonStyleSheet
    public var buttonIsHidden: Bool
    public var buttonSize: CGSize
    public var buttonSpacing: CGFloat
    public var buttonIsSpinnerAnimating: Bool
    public var buttonPressed: Closure

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        imageStyle: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        titleStyle: QLabelStyleSheet,
        buttonStyle: QButtonStyleSheet,
        buttonIsHidden: Bool = false,
        buttonSize: CGSize = CGSize(width: 44, height: 44),
        buttonSpacing: CGFloat = 4,
        buttonPressed: @escaping Closure
    ) {
        self.imageStyle = imageStyle
        self.imageWidth = imageWidth
        self.imageSpacing = imageSpacing
        self.titleStyle = titleStyle
        self.buttonStyle = buttonStyle
        self.buttonIsHidden = buttonIsHidden
        self.buttonSize = buttonSize
        self.buttonSpacing = buttonSpacing
        self.buttonIsSpinnerAnimating = false
        self.buttonPressed = buttonPressed
        super.init(edgeInsets: edgeInsets)
    }

}

open class QImageTitleButtonComposition< Composable: QImageTitleButtonComposable > : QComposition< Composable > {
    
    public private(set) lazy var imageView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var titleView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var buttonView: QButton = {
        let view = QButton(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        view.onPressed = { [weak self] _ in
            guard let self = self, let composable = self.composable else { return }
            composable.buttonPressed(composable)
        }
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?
    private var _imageWidth: CGFloat?
    private var _imageSpacing: CGFloat?
    private var _buttonSize: CGSize?
    private var _buttonIsHidden: Bool?
    private var _buttonSpacing: CGFloat?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _imageConstraints: [NSLayoutConstraint] = [] {
        willSet { self.imageView.removeConstraints(self._imageConstraints) }
        didSet { self.imageView.addConstraints(self._imageConstraints) }
    }
    private var _buttonConstraints: [NSLayoutConstraint] = [] {
        willSet { self.buttonView.removeConstraints(self._buttonConstraints) }
        didSet { self.buttonView.addConstraints(self._buttonConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let imageSize = composable.imageStyle.size(CGSize(width: composable.imageWidth, height: availableWidth))
        let titleSize = composable.titleStyle.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing + composable.buttonSize.width + composable.buttonSpacing))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(imageSize.height, titleSize.height, composable.buttonSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._imageSpacing != composable.imageSpacing || self._buttonIsHidden != composable.buttonIsHidden || self._buttonSpacing != composable.buttonSpacing {
            self._edgeInsets = composable.edgeInsets
            self._imageSpacing = composable.imageSpacing
            self._buttonIsHidden = composable.buttonIsHidden
            self._buttonSpacing = composable.buttonSpacing
            var constraints: [NSLayoutConstraint] = [
                self.imageView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.imageView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.imageView.trailingLayout == self.titleView.leadingLayout.offset(-composable.imageSpacing),
                self.imageView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.buttonView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.buttonView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.buttonView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right)
            ]
            if composable.buttonIsHidden == false {
                constraints.append(contentsOf: [
                    self.titleView.trailingLayout == self.buttonView.leadingLayout.offset(-composable.buttonSpacing)
                ])
            } else {
                constraints.append(contentsOf: [
                    self.titleView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right)
                ])
            }
            self._constraints = constraints
        }
        if self._imageWidth != composable.imageWidth {
            self._imageWidth = composable.imageWidth
            self._imageConstraints = [
                self.imageView.widthLayout == composable.imageWidth
            ]
        }
        if self._buttonSize != composable.buttonSize {
            self._buttonSize = composable.buttonSize
            self._buttonConstraints = [
                self.buttonView.widthLayout == composable.buttonSize.width,
                self.buttonView.heightLayout == composable.buttonSize.height
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.imageView.apply(composable.imageStyle)
        self.titleView.apply(composable.titleStyle)
        self.buttonView.apply(composable.buttonStyle)
    }
    
    open override func postLayout(composable: Composable, spec: IQContainerSpec) {
        self.buttonView.alpha = (composable.buttonIsHidden == false) ? 1 : 0
        if composable.buttonIsSpinnerAnimating == true {
            self.buttonView.startSpinner()
        } else {
            self.buttonView.stopSpinner()
        }
    }

    public func isSpinnerAnimating() -> Bool {
        return self.buttonView.isSpinnerAnimating()
    }

    public func startSpinner() {
        if let composable = self.composable {
            composable.buttonIsSpinnerAnimating = true
            self.buttonView.startSpinner()
        }
    }

    public func stopSpinner() {
        if let composable = self.composable {
            composable.buttonIsSpinnerAnimating = false
            self.buttonView.stopSpinner()
        }
    }

}
