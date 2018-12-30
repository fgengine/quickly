//
//  Quickly
//

open class QPushViewController : QViewController, IQPushViewController {

    open private(set) var pushContentViewController: IQPushContentViewController
    open var pushState: QPushViewControllerState {
        didSet { self._relayoutContentViewController() }
    }
    open var pushOffset: CGFloat {
        didSet { self._relayoutContentViewController() }
    }
    open private(set) var pushDisplayTime: TimeInterval?
    open var pushPresentAnimation: IQPushViewControllerFixedAnimation?
    open var pushDismissAnimation: IQPushViewControllerFixedAnimation?
    open var pushInteractiveDismissAnimation: IQPushViewControllerInteractiveAnimation?
    public private(set) lazy var tapGesture: UITapGestureRecognizer = self._prepareTapGesture()
    
    private var _timer: QTimer?
    private var _contentLayoutConstraints: [NSLayoutConstraint]

    public init(_ contentViewController: IQPushContentViewController, displayTime: TimeInterval? = nil) {
        self.pushContentViewController = contentViewController
        self.pushState = .hide
        self.pushOffset = 0
        self.pushDisplayTime = displayTime
        self._contentLayoutConstraints = []
        super.init()
    }

    deinit {
        if let timer = self._timer {
            timer.stop()
        }
    }

    open override func setup() {
        super.setup()

        self.additionalEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)

        self.pushContentViewController.parent = self
    }

    open override func didLoad() {
        if let displayTime = self.pushDisplayTime {
            let timer = QTimer(interval: displayTime, onFinished: { [weak self] (timer: QTimer) in
                guard let strong = self else { return }
                strong.pushContentViewController.didTimeout()
            })
            timer.start()
            self._timer = timer
        }

        self.pushContentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.pushContentViewController.view.addGestureRecognizer(self.tapGesture)
        self.view.addSubview(self.pushContentViewController.view)

        self._layoutContentViewController()
    }
    
    open override func didChangeAdditionalEdgeInsets() {
        super.didChangeAdditionalEdgeInsets()
        self._relayoutContentViewController()
    }

    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self.pushContentViewController.prepareInteractivePresent()
    }

    open override func cancelInteractivePresent() {
        super.cancelInteractivePresent()
        self.pushContentViewController.cancelInteractivePresent()
    }

    open override func finishInteractivePresent() {
        super.finishInteractivePresent()
        self.pushContentViewController.finishInteractivePresent()
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self.pushContentViewController.willPresent(animated: animated)
    }

    open override func didPresent(animated: Bool) {
        super.didPresent(animated: animated)
        self.pushContentViewController.didPresent(animated: animated)
    }

    open override func prepareInteractiveDismiss() {
        if let timer = self._timer {
            timer.pause()
        }
        super.prepareInteractiveDismiss()
        self.pushContentViewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        if let timer = self._timer {
            timer.resume()
        }
        self.pushContentViewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        if let timer = self._timer {
            timer.stop()
        }
        self.pushContentViewController.finishInteractiveDismiss()
    }

    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.pushContentViewController.willDismiss(animated: animated)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self.pushContentViewController.didDismiss(animated: animated)
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        self.pushContentViewController.willTransition(size: size)
    }

    open override func didTransition(size: CGSize) {
        super.didTransition(size: size)
        self.pushContentViewController.didTransition(size: size)
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self.pushContentViewController.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        return self.pushContentViewController.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.pushContentViewController.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.pushContentViewController.preferedStatusBarAnimation()
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

    private func _layoutContentViewController() {
        let additionalEdgeInsets = self.additionalEdgeInsets
        let inheritedEdgeInsets = self.inheritedEdgeInsets
        let edgeInsets = UIEdgeInsets(
            top: additionalEdgeInsets.top + inheritedEdgeInsets.top,
            left: additionalEdgeInsets.left + inheritedEdgeInsets.left,
            bottom: additionalEdgeInsets.bottom + inheritedEdgeInsets.bottom,
            right: additionalEdgeInsets.right + inheritedEdgeInsets.right
        )
        switch self.pushState {
        case .hide:
            self._contentLayoutConstraints.append(self.view.topLayout == self.pushContentViewController.view.bottomLayout + self.pushOffset)
        case .show:
            self._contentLayoutConstraints.append(self.view.topLayout == self.pushContentViewController.view.topLayout - (edgeInsets.top + self.pushOffset))
        }
        self._contentLayoutConstraints.append(self.view.leadingLayout == self.pushContentViewController.view.leadingLayout - edgeInsets.left)
        self._contentLayoutConstraints.append(self.view.trailingLayout == self.pushContentViewController.view.trailingLayout + edgeInsets.right)
        self._contentLayoutConstraints.append(self.view.bottomLayout <= self.pushContentViewController.view.bottomLayout - edgeInsets.bottom ~ .defaultLow)
        if self._contentLayoutConstraints.count > 0 {
            self.view.addConstraints(self._contentLayoutConstraints)
        }
    }
    
    private func _unlayoutContentViewController() {
        if self._contentLayoutConstraints.count > 0 {
            self.view.removeConstraints(self._contentLayoutConstraints)
            self._contentLayoutConstraints.removeAll()
        }
    }

    @objc private func _tapGestureHandler(_ sender: Any) {
        self.pushContentViewController.didPressed()
    }

}
    
extension QPushViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self.pushContentViewController.view)
        if self.pushContentViewController.view.point(inside: location, with: nil) == false {
            return false
        }
        return true
    }

}
