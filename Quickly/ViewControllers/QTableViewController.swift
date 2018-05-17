//
//  Quickly
//

open class QTableViewController : QViewController, IQTableControllerObserver, IQStackContentViewController {

    open var stackPageViewController: IQStackPageViewController?
    open var stackPageContentOffset: CGPoint {
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
    open var stackPageContentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.tableView.contentSize
        }
    }

    open private(set) var tableView: QTableView! {
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
    open var refreshControlHidden: Bool = false {
        didSet { self.updateRefreshControlState() }
    }
    public var refreshControl: UIRefreshControl? {
        set(value) {
            if let refreshControl = self.storeRefreshControl {
                if refreshControl.isRefreshing == true {
                    refreshControl.endRefreshing()
                }
            }
            self.storeRefreshControl = value
            self.updateRefreshControlState()
        }
        get { return self.storeRefreshControl }
    }
    open var isRefreshing: Bool {
        get {
            guard let refreshControl = self.storeRefreshControl else { return false }
            return refreshControl.isRefreshing
        }
    }

    private var storeRefreshControl: UIRefreshControl? {
        willSet {
            guard let refreshControl = self.storeRefreshControl else { return }
            refreshControl.removeValueChanged(self, action: #selector(self.triggeredRefreshControl(_:)))
        }
        didSet {
            guard let refreshControl = self.storeRefreshControl else { return }
            refreshControl.addValueChanged(self, action: #selector(self.triggeredRefreshControl(_:)))
        }
    }

    open override func didLoad() {
        self.tableView = QTableView(frame: self.view.bounds)
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds : bounds)

        if let view = self.tableView {
            let edgeInsets = self.inheritedEdgeInsets
            let beforeContentInset = view.contentInset
            let beforeContentOffset = view.contentOffset
            let beforeContentSize = view.contentSize
            let progress = CGPoint(
                x: (beforeContentInset.left + beforeContentOffset.x) / beforeContentSize.width,
                y: (beforeContentInset.top + beforeContentOffset.y) / beforeContentSize.height
            )
            view.frame = bounds
            view.contentInset = edgeInsets
            view.scrollIndicatorInsets = edgeInsets
            let afterContentSize = view.contentSize
            view.contentOffset = CGPoint(
                x: -edgeInsets.left + (afterContentSize.width * progress.x),
                y: -edgeInsets.top + (afterContentSize.height * progress.y)
            )
        }
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)

        self.updateRefreshControlState()
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)

        self.updateRefreshControlState()
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

    open func scroll(_ controller: IQTableController, tableView: UITableView) {
        guard let stackPage = self.stackPageViewController else { return }
        stackPage.updateContent()
    }

    open func update(_ controller: IQTableController) {
    }

    @objc
    private func triggeredRefreshControl(_ sender: Any) {
        self.triggeredRefreshControl()
    }

    private func updateRefreshControlState() {
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
