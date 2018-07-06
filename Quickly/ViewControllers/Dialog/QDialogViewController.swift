//
//  Quickly
//

open class QDialogViewController : QViewController, IQDialogViewController {

    open private(set) var dialogContentViewController: IQDialogContentViewController
    open var dialogWidthBehaviour: QDialogViewControllerSizeBehaviour {
        didSet { self._relayoutContentViewController() }
    }
    open var dialogHeightBehaviour: QDialogViewControllerSizeBehaviour {
        didSet { self._relayoutContentViewController() }
    }
    open var dialogVerticalAlignment: QDialogViewControllerVerticalAlignment {
        didSet { self._relayoutContentViewController() }
    }
    open var dialogHorizontalAlignment: QDialogViewControllerHorizontalAlignment {
        didSet { self._relayoutContentViewController() }
    }
    open var dialogPresentAnimation: IQDialogViewControllerFixedAnimation?
    open var dialogDismissAnimation: IQDialogViewControllerFixedAnimation?
    open var dialogInteractiveDismissAnimation: IQDialogViewControllerInteractiveAnimation?
    public private(set) lazy var tapGesture: UITapGestureRecognizer = self._prepareTapGesture()
    private var contentLayoutConstraints: [NSLayoutConstraint] = []
    private var contentSizeConstraints: [NSLayoutConstraint] = []

    public init(
        _ contentViewController: IQDialogContentViewController,
        widthBehaviour: QDialogViewControllerSizeBehaviour = .fit(min: 0, max: 0),
        heightBehaviour: QDialogViewControllerSizeBehaviour = .fit(min: 0, max: 0),
        verticalAlignment: QDialogViewControllerVerticalAlignment = .center(offset: 0),
        horizontalAlignment: QDialogViewControllerHorizontalAlignment = .center(offset: 0)
    ) {
        self.dialogContentViewController = contentViewController
        self.dialogWidthBehaviour = widthBehaviour
        self.dialogHeightBehaviour = heightBehaviour
        self.dialogVerticalAlignment = verticalAlignment
        self.dialogHorizontalAlignment = horizontalAlignment
        super.init()
    }

    open override func setup() {
        super.setup()

        self.dialogContentViewController.parent = self
    }

    open override func load() -> ViewType {
        return QViewControllerDefaultView(viewController: self, backgroundColor: UIColor.clear)
    }

    open override func didLoad() {
        self.view.addGestureRecognizer(self.tapGesture)

        self.dialogContentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.dialogContentViewController.view)

        self._layoutContentViewController()
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.dialogContentViewController.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.dialogContentViewController.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.dialogContentViewController.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.dialogContentViewController.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.dialogContentViewController.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.dialogContentViewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        self.dialogContentViewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        self.dialogContentViewController.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.dialogContentViewController.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.dialogContentViewController.didDismiss(animated: animated)
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self.dialogContentViewController.willTransition(size: size)
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self.dialogContentViewController.didTransition(size: size)
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self.dialogContentViewController.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        return self.dialogContentViewController.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.dialogContentViewController.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.dialogContentViewController.preferedStatusBarAnimation()
    }

    private func _prepareTapGesture() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self._tapGestureHandler(_:)))
        gesture.delegate = self
        return gesture
    }

    private func _relayoutContentViewController() {
        guard self.isLoaded == true else { return }
        self._unlayoutContentViewController()
        self._layoutContentViewController()
    }

    private func _unlayoutContentViewController() {
        if self.contentLayoutConstraints.count > 0 {
            self.view.removeConstraints(self.contentLayoutConstraints)
            self.contentLayoutConstraints.removeAll()
        }
        if self.contentSizeConstraints.count > 0 {
            self.dialogContentViewController.view.removeConstraints(self.contentSizeConstraints)
            self.contentSizeConstraints.removeAll()
        }
    }

    private func _layoutContentViewController() {
        switch self.dialogWidthBehaviour {
        case .fit(let min, let max):
            if min > CGFloat.leastNonzeroMagnitude || max > CGFloat.leastNonzeroMagnitude {
                if min == max {
                    self.contentSizeConstraints.append(self.dialogContentViewController.view.heightLayout == min)
                } else {
                    self.contentSizeConstraints.append(self.dialogContentViewController.view.heightLayout >= min)
                    self.contentSizeConstraints.append(self.dialogContentViewController.view.heightLayout <= max)
                }
            }
            break
        case .fill(let before, let after):
            switch self.dialogHorizontalAlignment {
            case .center(let offset):
                self.contentLayoutConstraints.append(self.dialogContentViewController.view.leadingLayout == self.view.leadingLayout + (before + offset))
                self.contentLayoutConstraints.append(self.view.trailingLayout == self.dialogContentViewController.view.trailingLayout + (after - offset))
                break
            default:
                self.contentLayoutConstraints.append(self.dialogContentViewController.view.leadingLayout == self.view.leadingLayout + before)
                self.contentLayoutConstraints.append(self.view.trailingLayout == self.dialogContentViewController.view.trailingLayout + after)
                break
            }
            break
        }
        switch self.dialogHeightBehaviour {
        case .fit(let min, let max):
            if min > CGFloat.leastNonzeroMagnitude || max > CGFloat.leastNonzeroMagnitude {
                if min == max {
                    self.contentSizeConstraints.append(self.dialogContentViewController.view.widthLayout == min)
                } else {
                    self.contentSizeConstraints.append(self.dialogContentViewController.view.widthLayout >= min)
                    self.contentSizeConstraints.append(self.dialogContentViewController.view.widthLayout <= max)
                }
            }
            break
        case .fill(let before, let after):
            switch self.dialogVerticalAlignment {
            case .center(let offset):
                self.contentLayoutConstraints.append(self.dialogContentViewController.view.topLayout == self.view.topLayout + (before + offset))
                self.contentLayoutConstraints.append(self.view.bottomLayout == self.dialogContentViewController.view.bottomLayout + (after - offset))
                break
            default:
                self.contentLayoutConstraints.append(self.dialogContentViewController.view.topLayout == self.view.topLayout + before)
                self.contentLayoutConstraints.append(self.view.bottomLayout == self.dialogContentViewController.view.bottomLayout + after)
                break
            }
            break
        }
        switch self.dialogHorizontalAlignment {
        case .left(let offset):
            self.contentLayoutConstraints.append(self.dialogContentViewController.view.leadingLayout == self.view.leadingLayout + offset)
            break
        case .center(let offset):
            self.contentLayoutConstraints.append(self.dialogContentViewController.view.centerXLayout == self.view.centerXLayout + offset)
            break
        case .right(let offset):
            self.contentLayoutConstraints.append(self.dialogContentViewController.view.trailingLayout == self.view.trailingLayout + offset)
            break
        }
        switch self.dialogVerticalAlignment {
        case .top(let offset):
            self.contentLayoutConstraints.append(self.dialogContentViewController.view.topLayout == self.view.topLayout + offset)
            break
        case .center(let offset):
            self.contentLayoutConstraints.append(self.dialogContentViewController.view.centerYLayout == self.view.centerYLayout + offset)
            break
        case .bottom(let offset):
            self.contentLayoutConstraints.append(self.dialogContentViewController.view.bottomLayout == self.view.bottomLayout + offset)
            break
        }
        if self.contentLayoutConstraints.count > 0 {
            self.view.addConstraints(self.contentLayoutConstraints)
        }
        if self.contentSizeConstraints.count > 0 {
            self.dialogContentViewController.view.addConstraints(self.contentSizeConstraints)
        }
    }

    @objc
    private func _tapGestureHandler(_ sender: Any) {
        self.dialogContentViewController.didPressedOutsideContent()
    }

}

extension QDialogViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self.view)
        if self.view.point(inside: location, with: nil) == false {
            return false
        }
        let contentLocation = gestureRecognizer.location(in: self.dialogContentViewController.view)
        if self.dialogContentViewController.view.point(inside: contentLocation, with: nil) == true {
            return false
        }
        return true
    }

}
