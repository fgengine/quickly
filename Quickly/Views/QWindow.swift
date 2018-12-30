//
//  Quickly
//

open class QWindow : UIWindow, IQView {

    open var contentViewController: IQViewController {
        set(value) { self._viewController.contentViewController = value }
        get { return self._viewController.contentViewController }
    }
    
    private var _viewController: RootViewController
    
    public required init() {
        fatalError("init(coder:) has not been implemented")
    }

    public init(_ contentViewController: IQViewController) {
        self._viewController = RootViewController(contentViewController)
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setup() {
        self.rootViewController = self._viewController
    }

    private class RootViewController : UIViewController, IQViewControllerDelegate {

        open var contentViewController: IQViewController {
            willSet {
                if self.isViewLoaded == true {
                    self.contentViewController.willDismiss(animated: false)
                    self.contentViewController.didDismiss(animated: false)
                }
            }
            didSet {
                self.contentViewController.delegate = self
                if self.isViewLoaded == true {
                    self.contentViewController.view.frame = self.view.bounds
                    self.view.addSubview(self.contentViewController.view)
                    self.contentViewController.willPresent(animated: false)
                    self.contentViewController.didPresent(animated: false)
                }
            }
        }

        open override var prefersStatusBarHidden: Bool {
            get { return self.contentViewController.preferedStatusBarHidden() }
        }
        open override var preferredStatusBarStyle: UIStatusBarStyle {
            get { return self.contentViewController.preferedStatusBarStyle() }
        }
        open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
            get { return self.contentViewController.preferedStatusBarAnimation() }
        }
        open override var shouldAutorotate: Bool {
            get { return true }
        }
        open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            get { return self.contentViewController.supportedOrientations() }
        }

        public init(_ contentViewController: IQViewController) {
            self.contentViewController = contentViewController
            super.init(nibName: nil, bundle: nil)
            self.setup()
        }

        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        open func setup() {
            self.contentViewController.delegate = self
        }

        open override func loadView() {
            self.view = QTransparentView(frame: UIScreen.main.bounds)
        }

        open override func viewDidLoad() {
            super.viewDidLoad()

            self.contentViewController.view.frame = self.view.bounds
            self.view.addSubview(self.contentViewController.view)
            self.contentViewController.willPresent(animated: false)
            self.contentViewController.didPresent(animated: false)
        }

        open override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            self.contentViewController.additionalEdgeInsets = self._currentAdditionalEdgeInsets()
            self.contentViewController.view.frame = self.view.bounds
        }

        open override func viewSafeAreaInsetsDidChange() {
            self.contentViewController.additionalEdgeInsets = self._currentAdditionalEdgeInsets()
        }

        open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            coordinator.animate(alongsideTransition: { [unowned self] _ in
                self.contentViewController.willTransition(size: size)
            }, completion: { [unowned self] _ in
                self.contentViewController.didTransition(size: size)
            })
        }

        private func _currentAdditionalEdgeInsets() -> UIEdgeInsets {
            if #available(iOS 11.0, *) {
                return self.view.safeAreaInsets
            } else {
                return UIEdgeInsets(
                    top: self.topLayoutGuide.length,
                    left: 0,
                    bottom: self.bottomLayoutGuide.length,
                    right: 0
                )
            }
        }

        // MARK: IQViewControllerDelegate

        public func requestUpdateStatusBar(viewController: IQViewController) {
            self.setNeedsStatusBarAppearanceUpdate()
        }

    }

}
