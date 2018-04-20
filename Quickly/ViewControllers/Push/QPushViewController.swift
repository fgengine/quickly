//
//  Quickly
//

open class QPushViewController : QViewController, IQPushViewController {

    open weak var containerViewController: IQPushContainerViewController?
    open private(set) var contentViewController: IQPushContentViewController
    open var state: QPushViewControllerState {
        didSet { self._relayoutContentViewController() }
    }
    open var offset: CGFloat = 0 {
        didSet { self._relayoutContentViewController() }
    }
    open private(set) var displayTime: TimeInterval?
    open var presentAnimation: IQPushViewControllerFixedAnimation?
    open var dismissAnimation: IQPushViewControllerFixedAnimation?
    open var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation?
    open lazy var tapGesture: UITapGestureRecognizer = self._prepareTapGesture()

    private var timer: QTimer?
    private var contentLayoutConstraints: [NSLayoutConstraint] = []

    public init(contentViewController: IQPushContentViewController, displayTime: TimeInterval?) {
        self.contentViewController = contentViewController
        self.state = .hide
        self.offset = 0
        self.displayTime = displayTime
        
        super.init()
    }

    deinit {
        if let timer = self.timer {
            timer.stop()
        }
    }

    open override func setup() {
        super.setup()

        self.additionalEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)

        self.contentViewController.pushViewController = self
        self.contentViewController.parent = self
    }

    open override func didLoad() {
        if let displayTime = self.displayTime {
            let timer = QTimer(interval: displayTime)
            timer.onFinished = { [weak self] (timer: QTimer) in
                guard let strongify = self else { return }
                strongify.contentViewController.didTimeout()
            }
            timer.start()
            self.timer = timer
        }

        self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentViewController.view.addGestureRecognizer(self.tapGesture)
        self.view.addSubview(self.contentViewController.view)

        self._layoutContentViewController()
    }

    open override func layout(bounds: CGRect) {
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

    open override func prepareInteractiveDismiss() {
        if let timer = self.timer {
            timer.pause()
        }
        super.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        if let timer = self.timer {
            timer.resume()
        }
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        if let timer = self.timer {
            timer.stop()
        }
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
    }

    private func _layoutContentViewController() {
        let additionalEdgeInsets = self.additionalEdgeInsets
        let inheritedEdgeInsets = self.inheritedEdgeInsets
        let edgeInsets = UIEdgeInsets(
            top: additionalEdgeInsets.top + inheritedEdgeInsets.top,
            left: additionalEdgeInsets.left + inheritedEdgeInsets.left,
            bottom: additionalEdgeInsets.bottom + inheritedEdgeInsets.bottom,
            right: additionalEdgeInsets.right + inheritedEdgeInsets.right
        )
        switch self.state {
        case .hide:
            self.contentLayoutConstraints.append(self.view.topLayout == self.contentViewController.view.bottomLayout + self.offset)
        case .show:
            self.contentLayoutConstraints.append(self.view.topLayout == self.contentViewController.view.topLayout - (edgeInsets.top + self.offset))
        }
        self.contentLayoutConstraints.append(self.view.leadingLayout == self.contentViewController.view.leadingLayout - edgeInsets.left)
        self.contentLayoutConstraints.append(self.view.trailingLayout == self.contentViewController.view.trailingLayout + edgeInsets.right)
        self.contentLayoutConstraints.append(self.view.bottomLayout <= self.contentViewController.view.bottomLayout - edgeInsets.bottom ~ .defaultLow)
        if self.contentLayoutConstraints.count > 0 {
            self.view.addConstraints(self.contentLayoutConstraints)
        }
    }

    @objc private func _tapGestureHandler(_ sender: Any) {
        self.contentViewController.didPressed()
    }

}
    
extension QPushViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self.contentViewController.view)
        if self.contentViewController.view.point(inside: location, with: nil) == false {
            return false
        }
        return true
    }

}
