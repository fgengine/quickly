//
//  Quickly
//

#if os(iOS)

    open class QCollectionViewController : UICollectionViewController, IQViewController {

        public var collectionController: IQCollectionController? {
            set(value) {
                self.proxy.collectionController = value
                if let collectionController: IQCollectionController = value {
                    collectionController.reload()
                }
            }
            get {
                return self.proxy.collectionController
            }
        }
        private lazy var proxy: Proxy = Proxy(viewController: self)

        open var statusBarHidden: Bool = false {
            didSet { self.setNeedsStatusBarAppearanceUpdate() }
        }
        open var statusBarStyle: UIStatusBarStyle = .default {
            didSet { self.setNeedsStatusBarAppearanceUpdate() }
        }
        open var statusBarAnimation: UIStatusBarAnimation = .fade {
            didSet { self.setNeedsStatusBarAppearanceUpdate() }
        }
        open var supportedOrientationMask: UIInterfaceOrientationMask = .portrait
        open var navigationBarHidden: Bool = false
        open var toolbarHidden: Bool = true
        open var isAppeared: Bool = false

        open override var prefersStatusBarHidden: Bool {
            get { return self.statusBarHidden }
        }
        open override var preferredStatusBarStyle: UIStatusBarStyle {
            get { return self.statusBarStyle }
        }
        open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
            get { return self.statusBarAnimation }
        }
        open override var shouldAutorotate: Bool {
            get { return true }
        }
        open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            get { return self.supportedOrientationMask }
        }

        public init() {
            super.init(collectionViewLayout: UICollectionViewFlowLayout())
            self.setup()
        }

        public override init(collectionViewLayout: UICollectionViewLayout) {
            super.init(collectionViewLayout: collectionViewLayout)
            self.setup()
        }

        public override init(nibName: String?, bundle: Bundle?) {
            super.init(nibName: nibName, bundle: bundle)
            self.setup()
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setup()
        }

        open func setup() {
            self.edgesForExtendedLayout = []
            self.automaticallyAdjustsScrollViewInsets = false
        }

        open func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
            if let navigationController: UINavigationController = self.navigationController {
                navigationController.setNavigationBarHidden(hidden, animated: animated)
            }
            self.navigationBarHidden = hidden
        }

        open func setToolbarHidden(_ hidden: Bool, animated: Bool) {
            if let navigationController: UINavigationController = self.navigationController {
                navigationController.setToolbarHidden(hidden, animated: animated)
            }
            self.toolbarHidden = hidden
        }

        open override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.isAppeared = true
            if let navigationController: UINavigationController = self.navigationController {
                navigationController.isNavigationBarHidden = self.navigationBarHidden
                navigationController.isToolbarHidden = self.toolbarHidden
            }
        }

        open override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            self.isAppeared = false
        }

        open func willPresent(animated: Bool) {
        }

        open func didPresent(animated: Bool) {
        }

        open func willDismiss(animated: Bool) {
        }

        open func didDismiss(animated: Bool) {
        }

        private class Proxy: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

            public weak var viewController: QCollectionViewController?
            public var collectionController: IQCollectionController? = nil {
                willSet { self.cleanupCollectionController() }
                didSet { self.prepareCollectionController() }
            }

            public init(viewController: QCollectionViewController?) {
                self.viewController = viewController
                super.init()
            }

            deinit {
                if let collectionController: IQCollectionController = self.collectionController {
                    collectionController.collectionView = nil
                }
            }

            public func configure() {
                self.cleanupCollectionController()
                self.prepareCollectionController()
            }

            private func prepareCollectionController() {
                if let viewController = self.viewController {
                    if let collectionView = viewController.collectionView {
                        collectionView.delegate = self
                        collectionView.dataSource = self
                        if let collectionController: IQCollectionController = self.collectionController {
                            collectionController.collectionView = collectionView
                        }
                    }
                }
            }

            private func cleanupCollectionController() {
                if let viewController = self.viewController {
                    if let collectionView = viewController.collectionView {
                        collectionView.delegate = nil
                        collectionView.dataSource = nil
                    }
                }
                if let collectionController: IQCollectionController = self.collectionController {
                    collectionController.collectionView = nil
                }
            }

            public override func responds(to selector: Selector!) -> Bool {
                if super.responds(to: selector) {
                    return true
                }
                if let collectionController: IQCollectionController = self.collectionController {
                    if collectionController.responds(to: selector) {
                        return true
                    }
                }
                if let viewController: QCollectionViewController = self.viewController {
                    if viewController.responds(to: selector) {
                        return true
                    }
                }
                return false
            }

            public override func forwardingTarget(for selector: Selector!) -> Any? {
                if super.responds(to: selector) {
                    return self
                }
                if let collectionController: IQCollectionController = self.collectionController {
                    if collectionController.responds(to: selector) {
                        return collectionController
                    }
                }
                if let viewController: QCollectionViewController = self.viewController {
                    if viewController.responds(to: selector) {
                        return viewController
                    }
                }
                return nil
            }

            public func collectionView(
                _ collectionView: UICollectionView,
                numberOfItemsInSection index: Int
                ) -> Int {
                if let collectionController: IQCollectionController = self.collectionController {
                    return collectionController.collectionView(collectionView, numberOfItemsInSection: index)
                }
                return 0
            }


            public func collectionView(
                _ collectionView: UICollectionView,
                cellForItemAt indexPath: IndexPath
                ) -> UICollectionViewCell {
                if let collectionController: IQCollectionController = self.collectionController {
                    return collectionController.collectionView(collectionView, cellForItemAt: indexPath)
                }
                return UICollectionViewCell()
            }

        }

    }

#endif
