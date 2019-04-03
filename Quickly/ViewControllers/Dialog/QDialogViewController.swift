//
//  Quickly
//

open class QDialogViewController : QViewController, IQDialogViewController {

    open private(set) var contentViewController: IQDialogContentViewController
    open var widthBehaviour: QDialogViewControllerSizeBehaviour {
        didSet { self._relayoutContentViewController() }
    }
    open var heightBehaviour: QDialogViewControllerSizeBehaviour {
        didSet { self._relayoutContentViewController() }
    }
    open var verticalAlignment: QDialogViewControllerVerticalAlignment {
        didSet { self._relayoutContentViewController() }
    }
    open var horizontalAlignment: QDialogViewControllerHorizontalAlignment {
        didSet { self._relayoutContentViewController() }
    }
    open var presentAnimation: IQDialogViewControllerFixedAnimation?
    open var dismissAnimation: IQDialogViewControllerFixedAnimation?
    open var interactiveDismissAnimation: IQDialogViewControllerInteractiveAnimation?
    public private(set) lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self._handleTapGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    private lazy var _backgroundView: QInvisibleView = {
        let view = QInvisibleView(frame: self.view.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(self.tapGesture)
        return view
    }()
    private var _backgroundConstraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._backgroundConstraints) }
        didSet { self.view.addConstraints(self._backgroundConstraints) }
    }
    private var _contentLayoutConstraints: [NSLayoutConstraint] = []
    private var _contentSizeConstraints: [NSLayoutConstraint] = []

    public init(
        _ contentViewController: IQDialogContentViewController,
        widthBehaviour: QDialogViewControllerSizeBehaviour = .fit(min: 0, max: 0),
        heightBehaviour: QDialogViewControllerSizeBehaviour = .fit(min: 0, max: 0),
        verticalAlignment: QDialogViewControllerVerticalAlignment = .center(offset: 0),
        horizontalAlignment: QDialogViewControllerHorizontalAlignment = .center(offset: 0)
    ) {
        self.contentViewController = contentViewController
        self.widthBehaviour = widthBehaviour
        self.heightBehaviour = heightBehaviour
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        super.init()
    }

    open override func setup() {
        super.setup()

        self.contentViewController.parent = self
    }

    open override func didLoad() {
        self.view.addSubview(self._backgroundView)
        self._backgroundConstraints = [
            self._backgroundView.topLayout == self.view.topLayout,
            self._backgroundView.leadingLayout == self.view.leadingLayout,
            self._backgroundView.trailingLayout == self.view.trailingLayout,
            self._backgroundView.bottomLayout == self.view.bottomLayout
        ]
        
        self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.contentViewController.view)

        self._layoutContentViewController()
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.contentViewController.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.contentViewController.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.contentViewController.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.contentViewController.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.contentViewController.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.contentViewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.contentViewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self.contentViewController.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.contentViewController.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.contentViewController.didDismiss(animated: animated)
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self.contentViewController.willTransition(size: size)
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self.contentViewController.didTransition(size: size)
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self.contentViewController.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        return self.contentViewController.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.contentViewController.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.contentViewController.preferedStatusBarAnimation()
    }
    
}

// MARK: - Private -

extension QDialogViewController {

    private func _relayoutContentViewController() {
        guard self.isLoaded == true else { return }
        self._unlayoutContentViewController()
        self._layoutContentViewController()
    }

    private func _unlayoutContentViewController() {
        if self._contentLayoutConstraints.count > 0 {
            self.view.removeConstraints(self._contentLayoutConstraints)
            self._contentLayoutConstraints.removeAll()
        }
        if self._contentSizeConstraints.count > 0 {
            self.contentViewController.view.removeConstraints(self._contentSizeConstraints)
            self._contentSizeConstraints.removeAll()
        }
    }

    private func _layoutContentViewController() {
        switch self.widthBehaviour {
        case .fit(let min, let max):
            if min > CGFloat.leastNonzeroMagnitude || max > CGFloat.leastNonzeroMagnitude {
                if min == max {
                    self._contentSizeConstraints.append(self.contentViewController.view.widthLayout == min)
                } else {
                    self._contentSizeConstraints.append(self.contentViewController.view.widthLayout >= min)
                    self._contentSizeConstraints.append(self.contentViewController.view.widthLayout <= max)
                }
            }
            break
        case .fill(let before, let after):
            switch self.horizontalAlignment {
            case .center(let offset):
                self._contentLayoutConstraints.append(contentsOf: [
                    self.contentViewController.view.leadingLayout == self.view.leadingLayout.offset(before + offset),
                    self.view.trailingLayout == self.contentViewController.view.trailingLayout.offset(after - offset)
                ])
            default:
                self._contentLayoutConstraints.append(contentsOf: [
                    self.contentViewController.view.leadingLayout == self.view.leadingLayout.offset(before),
                    self.view.trailingLayout == self.contentViewController.view.trailingLayout.offset(after)
                ])
                break
            }
            break
        }
        switch self.heightBehaviour {
        case .fit(let min, let max):
            if min > CGFloat.leastNonzeroMagnitude || max > CGFloat.leastNonzeroMagnitude {
                if min == max {
                    self._contentSizeConstraints.append(self.contentViewController.view.heightLayout == min)
                } else {
                    self._contentSizeConstraints.append(contentsOf: [
                        self.contentViewController.view.heightLayout >= min,
                        self.contentViewController.view.heightLayout <= max
                    ])
                }
            }
            break
        case .fill(let before, let after):
            switch self.verticalAlignment {
            case .center(let offset):
                self._contentLayoutConstraints.append(contentsOf: [
                    self.contentViewController.view.topLayout == self.view.topLayout.offset(before + offset),
                    self.view.bottomLayout == self.contentViewController.view.bottomLayout.offset(after - offset)
                ])
            default:
                self._contentLayoutConstraints.append(contentsOf: [
                    self.contentViewController.view.topLayout == self.view.topLayout.offset(before),
                    self.view.bottomLayout == self.contentViewController.view.bottomLayout.offset(after)
                ])
                break
            }
            break
        }
        switch self.horizontalAlignment {
        case .left(let offset):
            self._contentLayoutConstraints.append(self.contentViewController.view.leadingLayout == self.view.leadingLayout.offset(offset))
            break
        case .center(let offset):
            self._contentLayoutConstraints.append(self.contentViewController.view.centerXLayout == self.view.centerXLayout.offset(offset))
            break
        case .right(let offset):
            self._contentLayoutConstraints.append(self.contentViewController.view.trailingLayout == self.view.trailingLayout.offset(offset))
            break
        }
        switch self.verticalAlignment {
        case .top(let offset):
            self._contentLayoutConstraints.append(self.contentViewController.view.topLayout == self.view.topLayout.offset(offset))
            break
        case .center(let offset):
            self._contentLayoutConstraints.append(self.contentViewController.view.centerYLayout == self.view.centerYLayout.offset(offset))
            break
        case .bottom(let offset):
            self._contentLayoutConstraints.append(self.contentViewController.view.bottomLayout == self.view.bottomLayout.offset(offset))
            break
        }
        if self._contentLayoutConstraints.count > 0 {
            self.view.addConstraints(self._contentLayoutConstraints)
        }
        if self._contentSizeConstraints.count > 0 {
            self.contentViewController.view.addConstraints(self._contentSizeConstraints)
        }
    }

    @objc
    private func _handleTapGesture(_ sender: Any) {
        self.contentViewController.dialogDidPressedOutside()
    }

}

// MARK: - UIGestureRecognizerDelegate -

extension QDialogViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self.view)
        if self.view.point(inside: location, with: nil) == false {
            return false
        }
        let contentLocation = gestureRecognizer.location(in: self.contentViewController.view)
        if self.contentViewController.view.point(inside: contentLocation, with: nil) == true {
            return false
        }
        return true
    }

}
