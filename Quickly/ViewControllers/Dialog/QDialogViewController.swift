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
    public private(set) lazy var tapGesture: UITapGestureRecognizer = self._prepareTapGesture()
    private var contentLayoutConstraints: [NSLayoutConstraint] = []
    private var contentSizeConstraints: [NSLayoutConstraint] = []

    public init(contentViewController: IQDialogContentViewController) {
        self.contentViewController = contentViewController
        self.widthBehaviour = .fit(min: 0, max: 0)
        self.heightBehaviour = .fit(min: 0, max: 0)
        self.verticalAlignment = .center(offset: 0)
        self.horizontalAlignment = .center(offset: 0)
        super.init()
    }

    open override func setup() {
        super.setup()

        self.contentViewController.parent = self
    }

    open override func load() -> ViewType {
        return QViewControllerDefaultView(viewController: self, backgroundColor: UIColor.clear)
    }

    open override func didLoad() {
        self.view.addGestureRecognizer(self.tapGesture)

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
            self.contentViewController.view.removeConstraints(self.contentSizeConstraints)
            self.contentSizeConstraints.removeAll()
        }
    }

    private func _layoutContentViewController() {
        switch self.widthBehaviour {
        case .fit(let min, let max):
            if min > CGFloat.leastNonzeroMagnitude || max > CGFloat.leastNonzeroMagnitude {
                if min == max {
                    self.contentSizeConstraints.append(self.contentViewController.view.heightLayout == min)
                } else {
                    self.contentSizeConstraints.append(self.contentViewController.view.heightLayout >= min)
                    self.contentSizeConstraints.append(self.contentViewController.view.heightLayout <= max)
                }
            }
            break
        case .fill(let before, let after):
            switch self.horizontalAlignment {
            case .center(let offset):
                self.contentLayoutConstraints.append(self.contentViewController.view.leadingLayout == self.view.leadingLayout + (before + offset))
                self.contentLayoutConstraints.append(self.view.trailingLayout == self.contentViewController.view.trailingLayout + (after - offset))
                break
            default:
                self.contentLayoutConstraints.append(self.contentViewController.view.leadingLayout == self.view.leadingLayout + before)
                self.contentLayoutConstraints.append(self.view.trailingLayout == self.contentViewController.view.trailingLayout + after)
                break
            }
            break
        }
        switch self.heightBehaviour {
        case .fit(let min, let max):
            if min > CGFloat.leastNonzeroMagnitude || max > CGFloat.leastNonzeroMagnitude {
                if min == max {
                    self.contentSizeConstraints.append(self.contentViewController.view.widthLayout == min)
                } else {
                    self.contentSizeConstraints.append(self.contentViewController.view.widthLayout >= min)
                    self.contentSizeConstraints.append(self.contentViewController.view.widthLayout <= max)
                }
            }
            break
        case .fill(let before, let after):
            switch self.verticalAlignment {
            case .center(let offset):
                self.contentLayoutConstraints.append(self.contentViewController.view.topLayout == self.view.topLayout + (before + offset))
                self.contentLayoutConstraints.append(self.view.bottomLayout == self.contentViewController.view.bottomLayout + (after - offset))
                break
            default:
                self.contentLayoutConstraints.append(self.contentViewController.view.topLayout == self.view.topLayout + before)
                self.contentLayoutConstraints.append(self.view.bottomLayout == self.contentViewController.view.bottomLayout + after)
                break
            }
            break
        }
        switch self.horizontalAlignment {
        case .left(let offset):
            self.contentLayoutConstraints.append(self.contentViewController.view.leadingLayout == self.view.leadingLayout + offset)
            break
        case .center(let offset):
            self.contentLayoutConstraints.append(self.contentViewController.view.centerXLayout == self.view.centerXLayout + offset)
            break
        case .right(let offset):
            self.contentLayoutConstraints.append(self.contentViewController.view.trailingLayout == self.view.trailingLayout + offset)
            break
        }
        switch self.verticalAlignment {
        case .top(let offset):
            self.contentLayoutConstraints.append(self.contentViewController.view.topLayout == self.view.topLayout + offset)
            break
        case .center(let offset):
            self.contentLayoutConstraints.append(self.contentViewController.view.centerYLayout == self.view.centerYLayout + offset)
            break
        case .bottom(let offset):
            self.contentLayoutConstraints.append(self.contentViewController.view.bottomLayout == self.view.bottomLayout + offset)
            break
        }
        if self.contentLayoutConstraints.count > 0 {
            self.view.addConstraints(self.contentLayoutConstraints)
        }
        if self.contentSizeConstraints.count > 0 {
            self.contentViewController.view.addConstraints(self.contentSizeConstraints)
        }
    }

    @objc
    private func _tapGestureHandler(_ sender: Any) {
        self.contentViewController.didPressedOutsideContent()
    }

}

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
