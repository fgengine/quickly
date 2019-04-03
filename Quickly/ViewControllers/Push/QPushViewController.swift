//
//  Quickly
//

open class QPushViewController : QViewController, IQPushViewController {

    open private(set) var contentViewController: IQPushContentViewController
    open var state: QPushViewControllerState {
        didSet { self._relayoutContentViewController() }
    }
    open var offset: CGFloat {
        didSet { self._relayoutContentViewController() }
    }
    open private(set) var displayTime: TimeInterval?
    open var presentAnimation: IQPushViewControllerFixedAnimation?
    open var dismissAnimation: IQPushViewControllerFixedAnimation?
    open var interactiveDismissAnimation: IQPushViewControllerInteractiveAnimation?
    public private(set) lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self._handleTapGesture(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    private var _timer: QTimer?
    private var _contentLayoutConstraints: [NSLayoutConstraint]

    public init(_ contentViewController: IQPushContentViewController, displayTime: TimeInterval? = nil) {
        self.contentViewController = contentViewController
        self.state = .hide
        self.offset = 0
        self.displayTime = displayTime
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

        self.contentViewController.parent = self
    }

    open override func didLoad() {
        if let displayTime = self.displayTime {
            let timer = QTimer(interval: displayTime, onFinished: { [weak self] (timer: QTimer) in
                guard let strong = self else { return }
                strong.contentViewController.didTimeout()
            })
            timer.start()
            self._timer = timer
        }

        self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentViewController.view.addGestureRecognizer(self.tapGesture)
        self.view.addSubview(self.contentViewController.view)

        self._layoutContentViewController()
    }
    
    open override func didChangeContentEdgeInsets() {
        super.didChangeContentEdgeInsets()
        self._relayoutContentViewController()
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
        if let timer = self._timer {
            timer.pause()
        }
        super.prepareInteractiveDismiss()
        self.contentViewController.prepareInteractiveDismiss()
    }

    open override func cancelInteractiveDismiss() {
        super.cancelInteractiveDismiss()
        if let timer = self._timer {
            timer.resume()
        }
        self.contentViewController.cancelInteractiveDismiss()
    }

    open override func finishInteractiveDismiss() {
        super.finishInteractiveDismiss()
        if let timer = self._timer {
            timer.stop()
        }
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

extension QPushViewController {

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
        switch self.state {
        case .hide:
            self._contentLayoutConstraints.append(self.view.topLayout == self.contentViewController.view.bottomLayout.offset(self.offset))
        case .show:
            self._contentLayoutConstraints.append(self.view.topLayout == self.contentViewController.view.topLayout.offset(-(edgeInsets.top + self.offset)))
        }
        self._contentLayoutConstraints.append(contentsOf: [
            self.view.leadingLayout == self.contentViewController.view.leadingLayout.offset(-edgeInsets.left),
            self.view.trailingLayout == self.contentViewController.view.trailingLayout.offset(edgeInsets.right),
            self.view.bottomLayout <= self.contentViewController.view.bottomLayout.offset(-edgeInsets.bottom) ~ .defaultLow
        ])
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

    @objc private func _handleTapGesture(_ sender: Any) {
        self.contentViewController.didPressed()
    }

}

// MARK: - UIGestureRecognizerDelegate -
    
extension QPushViewController : UIGestureRecognizerDelegate {

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self.contentViewController.view)
        if self.contentViewController.view.point(inside: location, with: nil) == false {
            return false
        }
        return true
    }

}
