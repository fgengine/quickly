//
//  Quickly
//

open class QDialogViewController : QPlatformViewController, IQDialogViewController {

    public typealias ContainerViewControllerType = IQDialogViewController.ContainerViewControllerType
    public typealias ContentViewControllerType = IQDialogViewController.ContentViewControllerType

    open weak var containerViewController: ContainerViewControllerType?

    open var contentViewController: ContentViewControllerType {
        willSet { self._disappearViewController() }
        didSet { self._appearViewController() }
    }
    open var widthBehaviour: QDialogViewControllerSizeBehaviour = .fit(min: 0, max: 0) {
        didSet { self._relayoutContentViewController() }
    }
    open var heightBehaviour: QDialogViewControllerSizeBehaviour = .fit(min: 0, max: 0) {
        didSet { self._relayoutContentViewController() }
    }
    open var verticalAlignment: QDialogViewControllerVerticalAlignment = .center(offset: 0) {
        didSet { self._relayoutContentViewController() }
    }
    open var horizontalAlignment: QDialogViewControllerHorizontalAlignment = .center(offset: 0) {
        didSet { self._relayoutContentViewController() }
    }
    open var presentAnimation: IQDialogViewControllerFixedAnimation?
    open var dismissAnimation: IQDialogViewControllerFixedAnimation?
    open var interactiveDismissAnimation: IQDialogViewControllerInteractiveAnimation?
    #if os(iOS)
    open lazy var tapGesture: UITapGestureRecognizer = self._prepareTapGesture()
    #endif

    private var contentLayoutConstraints: [NSLayoutConstraint] = []
    private var contentSizeConstraints: [NSLayoutConstraint] = []

    public init(contentViewController: ContentViewControllerType) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setup() {
    }

    open override func loadView() {
        self.view = QInvisibleView()
        #if os(iOS)
            self.view.addGestureRecognizer(self.tapGesture)
        #endif

        self._appearViewController()
    }

    open func willPresent(animated: Bool) {
        #if DEBUG
            print("\(NSStringFromClass(self.classForCoder)).willPresent(animated: \(animated))")
        #endif
        self.contentViewController.willPresent(animated: animated)
    }

    open func didPresent(animated: Bool) {
        #if DEBUG
            print("\(NSStringFromClass(self.classForCoder)).didPresent(animated: \(animated))")
        #endif
        self.contentViewController.didPresent(animated: animated)
    }

    open func willDismiss(animated: Bool) {
        #if DEBUG
            print("\(NSStringFromClass(self.classForCoder)).willDismiss(animated: \(animated))")
        #endif
        self.contentViewController.willDismiss(animated: animated)
    }

    open func didDismiss(animated: Bool) {
        #if DEBUG
            print("\(NSStringFromClass(self.classForCoder)).didDismiss(animated: \(animated))")
        #endif
        self.contentViewController.didDismiss(animated: animated)
    }

    #if os(iOS)

    private func _prepareTapGesture() -> UITapGestureRecognizer {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self._tapGestureHandler(_:)))
        gesture.delegate = self
        return gesture
    }

    #endif

    private func _appearViewController() {
        guard self.isViewLoaded == true else { return }
        self.contentViewController.dialogViewController = self
        self.addChildViewController(self.contentViewController)
        self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.contentViewController.view)
        #if os(iOS)
            self.contentViewController.didMove(toParentViewController: self)
        #endif
        self._layoutContentViewController()
    }

    private func _disappearViewController() {
        guard self.isViewLoaded == true else { return }
        self.contentViewController.dialogViewController = nil
        self._unlayoutContentViewController()
        #if os(iOS)
            self.contentViewController.willMove(toParentViewController: nil)
        #endif
        self.contentViewController.view.removeFromSuperview()
        self.contentViewController.removeFromParentViewController()
    }

    private func _relayoutContentViewController() {
        guard self.isViewLoaded == true else { return }
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

    #if os(iOS)

    @objc private func _tapGestureHandler(_ sender: Any) {
        self.contentViewController.didPressedOutsideContent()
    }

    #endif

}

#if os(iOS)

    extension QDialogViewController : UIGestureRecognizerDelegate {

        open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if self.view.point(inside: gestureRecognizer.location(in: self.view), with: nil) == false {
                return false
            }
            if self.contentViewController.view.point(inside: gestureRecognizer.location(in: self.contentViewController.view), with: nil) == true {
                return false
            }
            return true
        }

    }

#endif
