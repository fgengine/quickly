//
//  Quickly
//

open class QTableViewController : QViewController, IQStackContentViewController, IQPageContentViewController {

    #if DEBUG
    open override var logging: Bool {
        get { return true }
    }
    #endif
    public var contentOffset: CGPoint {
        get {
            guard self.isLoaded == true else { return CGPoint.zero }
            let contentOffset = self.tableView.contentOffset
            let contentInset = self.tableView.contentInset
            return CGPoint(
                x: contentInset.left + contentOffset.x,
                y: contentInset.top + contentOffset.y
            )
        }
    }
    public var contentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.tableView.contentSize
        }
    }
    public private(set) var tableView: QTableView! {
        willSet {
            guard let view = self.tableView else { return }
            view.removeFromSuperview()
        }
        didSet {
            guard let view = self.tableView else { return }
            let edgeInsets = self.inheritedEdgeInsets
            view.contentInset = edgeInsets
            view.scrollIndicatorInsets = edgeInsets
            self.view.addSubview(view)
        }
    }
    public var tableController: IQTableController? {
        set(value) {
            if let controller = self.tableView.tableController {
                controller.removeObserver(self)
            }
            self.tableView.tableController = value
            if let controller = self.tableView.tableController {
                controller.addObserver(self, priority: 0)
            }
        }
        get { return self.tableView.tableController }
    }
    public var refreshControlHidden: Bool = false {
        didSet { self._updateRefreshControlState() }
    }
    public var refreshControl: UIRefreshControl? {
        set(value) {
            if let refreshControl = self.storeRefreshControl {
                if refreshControl.isRefreshing == true {
                    refreshControl.endRefreshing()
                }
            }
            self.storeRefreshControl = value
            self._updateRefreshControlState()
        }
        get { return self.storeRefreshControl }
    }
    public var isRefreshing: Bool {
        get {
            guard let refreshControl = self.storeRefreshControl else { return false }
            return refreshControl.isRefreshing
        }
    }
    private var storeRefreshControl: UIRefreshControl? {
        willSet {
            guard let refreshControl = self.storeRefreshControl else { return }
            refreshControl.removeValueChanged(self, action: #selector(self._triggeredRefreshControl(_:)))
        }
        didSet {
            guard let refreshControl = self.storeRefreshControl else { return }
            refreshControl.addValueChanged(self, action: #selector(self._triggeredRefreshControl(_:)))
        }
    }

    deinit {
        self.tableController = nil
    }

    open override func didLoad() {
        self.tableView = QTableView(frame: self.view.bounds)
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self._updateRefreshControlState()
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self._updateRefreshControlState()
    }

    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)

        /*if let view = self.tableView {
            let edgeInsets = self.inheritedEdgeInsets
            let beforeContentInset = view.contentInset
            let beforeContentOffset = view.contentOffset
            let beforeContentSize = view.contentSize
            let progress = CGPoint(
                x: (beforeContentSize.width > CGFloat.leastNonzeroMagnitude) ? ((beforeContentInset.left + beforeContentOffset.x) / beforeContentSize.width) : 0,
                y: (beforeContentSize.height > CGFloat.leastNonzeroMagnitude) ? ((beforeContentInset.top + beforeContentOffset.y) / beforeContentSize.height) : 0
            )
            let afterContentSize = view.contentSize
            view.contentOffset = CGPoint(
                x: (afterContentSize.width > CGFloat.leastNonzeroMagnitude) ? (-edgeInsets.left + (afterContentSize.width * progress.x)) : 0,
                y: (afterContentSize.height > CGFloat.leastNonzeroMagnitude) ? (-edgeInsets.top + (afterContentSize.height * progress.y)) : 0
            )
        }*/
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds: bounds)

        if let view = self.tableView {
            let edgeInsets = self.inheritedEdgeInsets
            view.frame = bounds
            view.contentInset = edgeInsets
            view.scrollIndicatorInsets = edgeInsets
        }
    }

    open func beginRefreshing() {
        guard let refreshControl = self.storeRefreshControl else { return }
        refreshControl.beginRefreshing()
    }

    open func endRefreshing() {
        guard let refreshControl = self.storeRefreshControl else { return }
        refreshControl.endRefreshing()
    }

    open func triggeredRefreshControl() {
    }

    @objc
    private func _triggeredRefreshControl(_ sender: Any) {
        self.triggeredRefreshControl()
    }

    private func _updateRefreshControlState() {
        if self.isLoaded == true {
            if self.refreshControlHidden == false && self.isPresented == true {
                self.tableView.refreshControl = self.storeRefreshControl
            } else {
                if let refreshControl = self.storeRefreshControl {
                    refreshControl.endRefreshing()
                }
                self.tableView.refreshControl = nil
            }
        }
    }

}

extension QTableViewController : IQTableControllerObserver {

    open func scroll(_ controller: IQTableController, tableView: UITableView) {
        if let vc = self.contentOwnerViewController {
            vc.updateContent()
        }
    }

    open func update(_ controller: IQTableController) {
    }

}
