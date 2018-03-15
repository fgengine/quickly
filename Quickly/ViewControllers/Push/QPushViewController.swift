//
//  Quickly
//

open class QPushViewController : QPlatformViewController, IQPushViewController {

    public typealias ContainerViewControllerType = IQPushViewController.ContainerViewControllerType
    public typealias ContentViewControllerType = IQPushViewController.ContentViewControllerType

    open weak var containerViewController: ContainerViewControllerType?

    open var contentViewController: ContentViewControllerType {
        willSet { self._disappearViewController() }
        didSet { self._appearViewController() }
    }
    open var state: QPushViewControllerState = .hide {
        didSet { self._relayoutContentViewController() }
    }
    open var offset: CGFloat = 0 {
        didSet { self._relayoutContentViewController() }
    }
    open var edgeInsets: QPlatformEdgeInsets = QPlatformEdgeInsets(top: 28, left: 8, bottom: 0, right: 8) {
        didSet { self._relayoutContentViewController() }
    }
    open private(set) var displayTime: TimeInterval?
    open var presentAnimation: IQPushViewControllerFixedAnimation?
    open var dismissAnimation: IQPushViewControllerFixedAnimation?
    open var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation?
    open private(set) var timer: QTimer?
    #if os(iOS)
    open lazy var tapGesture: UITapGestureRecognizer = self._prepareTapGesture()
    #endif

    private var contentLayoutConstraints: [NSLayoutConstraint] = []

    public init(contentViewController: ContentViewControllerType, displayTime: TimeInterval?) {
        self.contentViewController = contentViewController
        self.displayTime = displayTime
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        if let timer: QTimer = self.timer {
            timer.stop()
        }
    }

    open func setup() {
    }

    open override func loadView() {
        self.view = QTransparentView()
        if let displayTime: TimeInterval = self.displayTime {
            let timer: QTimer = QTimer(interval: displayTime)
            timer.onFinished = { [weak self] (timer: QTimer) in
                if let strongify = self {
                    strongify.contentViewController.didTimeout()
                }
            }
            self.timer = timer
        }

        self._appearViewController()
    }

    open func willPresent(animated: Bool) {
        #if DEBUG
            print("\(NSStringFromClass(self.classForCoder)).willPresent(animated: \(animated))")
        #endif
        self.contentViewController.willPresent(animated: animated)
    }

    open func didPresent(animated: Bool) {
        if let timer: QTimer = self.timer {
            timer.start()
        }
        #if DEBUG
            print("\(NSStringFromClass(self.classForCoder)).didPresent(animated: \(animated))")
        #endif
        self.contentViewController.didPresent(animated: animated)
    }

    open func willDismiss(animated: Bool) {
        if let timer: QTimer = self.timer {
            timer.stop()
        }
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
        self.contentViewController.pushViewController = self
        self.addChildViewController(self.contentViewController)
        self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.contentViewController.view)
        #if os(iOS)
            self.contentViewController.didMove(toParentViewController: self)
        #endif
        #if os(iOS)
            self.contentViewController.view.addGestureRecognizer(self.tapGesture)
        #endif
        self._layoutContentViewController()
    }

    private func _disappearViewController() {
        guard self.isViewLoaded == true else { return }
        self.contentViewController.pushViewController = nil
        self._unlayoutContentViewController()
        #if os(iOS)
            self.contentViewController.willMove(toParentViewController: nil)
        #endif
        #if os(iOS)
            self.contentViewController.view.removeGestureRecognizer(self.tapGesture)
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
    }

    private func _layoutContentViewController() {
        switch self.state {
        case .hide:
            self.contentLayoutConstraints.append(self.view.topLayout == self.contentViewController.view.bottomLayout + self.offset)
        case .show:
            self.contentLayoutConstraints.append(self.view.topLayout == self.contentViewController.view.topLayout - (self.edgeInsets.top + self.offset))
        }
        self.contentLayoutConstraints.append(self.view.leadingLayout == self.contentViewController.view.leadingLayout - self.edgeInsets.left)
        self.contentLayoutConstraints.append(self.view.trailingLayout == self.contentViewController.view.trailingLayout + self.edgeInsets.right)
        self.contentLayoutConstraints.append(self.view.bottomLayout <= self.contentViewController.view.bottomLayout - self.edgeInsets.bottom ~ .defaultLow)
        if self.contentLayoutConstraints.count > 0 {
            self.view.addConstraints(self.contentLayoutConstraints)
        }
    }

    #if os(iOS)

    @objc private func _tapGestureHandler(_ sender: Any) {
        self.contentViewController.didPressed()
    }

    #endif

}

#if os(iOS)
    
    extension QPushViewController : UIGestureRecognizerDelegate {

        open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if self.contentViewController.view.point(inside: gestureRecognizer.location(in: self.view), with: nil) == false {
                return false
            }
            return true
        }

    }

#endif
