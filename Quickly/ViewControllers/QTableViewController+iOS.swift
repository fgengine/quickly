//
//  Quickly
//

#if os(iOS)

    open class QTableViewController : UITableViewController, IQViewController {

        public var tableController: IQTableController? {
            set(value) {
                self.proxy.tableController = value
                if let tableController: IQTableController = value {
                    tableController.reload()
                }
            }
            get {
                return self.proxy.tableController
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
            super.init(style: .plain)
            self.setup()
        }

        public override init(style: UITableViewStyle) {
            super.init(style: style)
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
        }

        open func triggeredRefreshControl() {
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
            #if DEBUG
                print("\(NSStringFromClass(self.classForCoder)).willPresent(animated: \(animated))")
            #endif
        }

        open func didPresent(animated: Bool) {
            #if DEBUG
                print("\(NSStringFromClass(self.classForCoder)).didPresent(animated: \(animated))")
            #endif
        }

        open func willDismiss(animated: Bool) {
            #if DEBUG
                print("\(NSStringFromClass(self.classForCoder)).willDismiss(animated: \(animated))")
            #endif
        }

        open func didDismiss(animated: Bool) {
            #if DEBUG
                print("\(NSStringFromClass(self.classForCoder)).didDismiss(animated: \(animated))")
            #endif
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

        private class Proxy: NSObject, UITableViewDataSource, UITableViewDelegate {

            public weak var viewController: QTableViewController?
            public var tableController: IQTableController? = nil {
                willSet { self.cleanupTableController() }
                didSet { self.prepareTableController() }
            }

            public init(viewController: QTableViewController?) {
                self.viewController = viewController
                super.init()
            }

            deinit {
                if let tableController: IQTableController = self.tableController {
                    tableController.tableView = nil
                }
            }

            public func configure() {
                self.cleanupTableController()
                self.prepareTableController()
            }

            private func prepareTableController() {
                if let viewController = self.viewController {
                    viewController.tableView.delegate = self
                    viewController.tableView.dataSource = self
                    if let tableController: IQTableController = self.tableController {
                        tableController.tableView = viewController.tableView
                    }
                }
            }

            private func cleanupTableController() {
                if let viewController = self.viewController {
                    viewController.tableView.delegate = nil
                    viewController.tableView.dataSource = nil
                }
                if let tableController: IQTableController = self.tableController {
                    tableController.tableView = nil
                }
            }

            public override func responds(to selector: Selector!) -> Bool {
                if super.responds(to: selector) {
                    return true
                }
                if let tableController: IQTableController = self.tableController {
                    if tableController.responds(to: selector) {
                        return true
                    }
                }
                if let viewController: QTableViewController = self.viewController {
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
                if let tableController: IQTableController = self.tableController {
                    if tableController.responds(to: selector) {
                        return tableController
                    }
                }
                if let viewController: QTableViewController = self.viewController {
                    if viewController.responds(to: selector) {
                        return viewController
                    }
                }
                return nil
            }

            public func tableView(
                _ tableView: UITableView,
                numberOfRowsInSection index: Int
            ) -> Int {
                if let tableController: IQTableController = self.tableController {
                    return tableController.tableView(tableView, numberOfRowsInSection: index)
                }
                return 0
            }

            public func tableView(
                _ tableView: UITableView,
                cellForRowAt indexPath: IndexPath
            ) -> UITableViewCell {
                if let tableController: IQTableController = self.tableController {
                    return tableController.tableView(tableView, cellForRowAt: indexPath)
                }
                return UITableViewCell(style: .default, reuseIdentifier: "Unknown")
            }

        }

    }

#endif
