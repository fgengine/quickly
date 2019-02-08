//
//  Quickly
//

open class QTableViewController : QViewController, IQTableControllerObserver, IQKeyboardObserver, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController, IQModalContentViewController {

    public var contentOffset: CGPoint {
        get {
            guard let tableView = self.tableView else { return CGPoint.zero }
            let contentOffset = tableView.contentOffset
            let contentInset = tableView.contentInset
            return CGPoint(
                x: contentInset.left + contentOffset.x,
                y: contentInset.top + contentOffset.y
            )
        }
    }
    public var contentSize: CGSize {
        get {
            guard let tableView = self.tableView else { return CGSize.zero }
            return tableView.contentSize
        }
    }
    public private(set) var tableView: QTableView! {
        willSet {
            guard let tableView = self.tableView else { return }
            tableView.removeFromSuperview()
        }
        didSet {
            guard let tableView = self.tableView else { return }
            let edgeInsets = self.inheritedEdgeInsets
            tableView.contentInset = edgeInsets
            tableView.scrollIndicatorInsets = edgeInsets
            self.view.addSubview(tableView)
        }
    }
    public var tableController: IQTableController? {
        willSet {
            if let tableController = self.tableController {
                tableController.removeObserver(self)
            }
        }
        didSet {
            if let tableView = self.tableView {
                tableView.tableController = self.tableController
            }
            if let tableController = self.tableController {
                tableController.addObserver(self, priority: 0)
            }
        }
    }
    public var refreshControlHidden: Bool = false {
        didSet { self._updateRefreshControlState() }
    }
    public var refreshControl: UIRefreshControl? {
        set(value) {
            if let refreshControl = self._refreshControl {
                if refreshControl.isRefreshing == true {
                    refreshControl.endRefreshing()
                }
            }
            self._refreshControl = value
            self._updateRefreshControlState()
        }
        get { return self._refreshControl }
    }
    public var isRefreshing: Bool {
        get {
            guard let refreshControl = self._refreshControl else { return false }
            return refreshControl.isRefreshing
        }
    }
    public var footerView: QView? {
        set(value) {
            if self._footerView != value {
                if let view = self._footerView {
                    view.removeFromSuperview()
                }
                self._footerView = value
                if self.isLoaded == true {
                    if let view = self._footerView, let tableView = self.tableView {
                        view.frame = self._footerViewFrame()
                        self.view.insertSubview(view, aboveSubview: tableView)
                    }
                }
            }
        }
        get { return self._footerView }
    }
    public var footerViewHeight: CGFloat = 100 {
        didSet(oldValue) {
            if self.footerViewHeight != oldValue {
                if let view = self._footerView {
                    view.frame = self._footerViewFrame()
                }
                self.didChangeAdditionalEdgeInsets()
            }
        }
    }
    public var loadingView: QLoadingViewType? {
        willSet {
            guard let loadingView = self.loadingView else { return }
            loadingView.removeFromSuperview()
            loadingView.delegate = nil
        }
        didSet {
            guard let loadingView = self.loadingView else { return }
            loadingView.delegate = self
        }
    }
    
    private var _refreshControl: UIRefreshControl? {
        willSet {
            guard let refreshControl = self._refreshControl else { return }
            refreshControl.removeValueChanged(self, action: #selector(self._triggeredRefreshControl(_:)))
        }
        didSet {
            guard let refreshControl = self._refreshControl else { return }
            refreshControl.addValueChanged(self, action: #selector(self._triggeredRefreshControl(_:)))
        }
    }
    private var _footerView: QView?
    private var _keyboard: QKeyboard!

    deinit {
        self.tableController = nil
        self._keyboard.removeObserver(self)
    }
    
    open override func setup() {
        super.setup()
        
        self._keyboard = QKeyboard()
    }

    open override func didLoad() {
        self.tableView = QTableView(frame: self.view.bounds)
        self.tableView.tableController = self.tableController
        if let view = self._footerView {
            view.frame = self._footerViewFrame()
            self.view.addSubview(view)
        }
        self._keyboard.addObserver(self, priority: 0)
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds: bounds)
        if let view = self.tableView {
            view.frame = bounds
        }
        if let view = self._footerView {
            view.frame = self._footerViewFrame()
        }
        if let view = self.loadingView, view.superview != nil {
            self._updateFrame(loadingView: view, bounds: bounds)
        }
    }

    open override func didChangeAdditionalEdgeInsets() {
        super.didChangeAdditionalEdgeInsets()
        if let view = self.tableView {
            self._updateContentInsets(view)
        }
        if let view = self._footerView {
            view.frame = self._footerViewFrame()
        }
        if let view = self.loadingView, view.superview != nil {
            self._updateFrame(loadingView: view, bounds: self.view.bounds)
        }
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self._updateRefreshControlState()
    }
    
    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.tableView.endEditing(false)
    }
    
    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.tableView.endEditing(false)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self._updateRefreshControlState()
    }
    
    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        if let view = self.tableView {
            self._updateContentInsets(view)
            view.reloadData()
        }
    }

    open func beginRefreshing() {
        guard let refreshControl = self._refreshControl else { return }
        refreshControl.beginRefreshing()
    }

    open func endRefreshing() {
        guard let refreshControl = self._refreshControl else { return }
        refreshControl.endRefreshing()
    }

    open func triggeredRefreshControl() {
    }
    
    open func isLoading() -> Bool {
        guard let loadingView = self.loadingView else { return false }
        return loadingView.isAnimating()
    }
    
    open func startLoading() {
        guard let loadingView = self.loadingView else { return }
        loadingView.start()
    }
    
    open func stopLoading() {
        guard let loadingView = self.loadingView else { return }
        loadingView.stop()
    }
    
    // MARK: IQTableControllerObserver
    
    open func scroll(_ controller: IQTableController, tableView: UITableView) {
        if let vc = self.contentOwnerViewController {
            vc.updateContent()
        }
    }
    
    open func update(_ controller: IQTableController) {
    }
    
    // MAKR: IQKeyboardObserver
    
    open func willShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
        var options: UIView.AnimationOptions = []
        switch animationInfo.curve {
        case .linear: options.insert(.curveLinear)
        case .easeIn: options.insert(.curveEaseIn)
        case .easeOut: options.insert(.curveEaseOut)
        default: options.insert(.curveEaseInOut)
        }
        UIView.animate(withDuration: animationInfo.duration, delay: 0, options: options, animations: {
            self.additionalEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: animationInfo.endFrame.height, right: 0)
        })
    }
    
    open func didShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
    }
    
    open func willHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
        var options: UIView.AnimationOptions = []
        switch animationInfo.curve {
        case .linear: options.insert(.curveLinear)
        case .easeIn: options.insert(.curveEaseIn)
        case .easeOut: options.insert(.curveEaseOut)
        default: options.insert(.curveEaseInOut)
        }
        UIView.animate(withDuration: animationInfo.duration, delay: 0, options: options, animations: {
            self.additionalEdgeInsets = UIEdgeInsets.zero
        })
    }
    
    open func didHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
    }
    
    // MAKR: Private

    @objc
    private func _triggeredRefreshControl(_ sender: Any) {
        self.triggeredRefreshControl()
    }

    private func _updateRefreshControlState() {
        if self.isLoaded == true {
            if self.refreshControlHidden == false && self.isPresented == true {
                self.tableView.refreshControl = self._refreshControl
            } else {
                if let refreshControl = self._refreshControl {
                    refreshControl.endRefreshing()
                }
                self.tableView.refreshControl = nil
            }
        }
    }
    
    private func _updateContentInsets(_ view: QTableView) {
        let edgeInsets = self.adjustedContentInset
        let footerHeight = (self.footerView != nil) ? self.footerViewHeight : 0
        view.contentLeftInset = edgeInsets.left
        view.contentRightInset = edgeInsets.right
        view.contentInset = UIEdgeInsets(
            top: edgeInsets.top,
            left: 0,
            bottom: edgeInsets.bottom + footerHeight,
            right: 0
        )
        view.scrollIndicatorInsets = UIEdgeInsets(
            top: edgeInsets.top,
            left: edgeInsets.left,
            bottom: edgeInsets.bottom + footerHeight,
            right: edgeInsets.right
        )
        if view.contentOffset.y <= CGFloat.leastNonzeroMagnitude {
            view.contentOffset = CGPoint(x: 0, y: -edgeInsets.top)
        }
    }
    
    private func _updateFrame(loadingView: QLoadingViewType, bounds: CGRect) {
        loadingView.frame = bounds.inset(by: self.inheritedEdgeInsets)
    }
    
    private func _footerViewFrame() -> CGRect {
        let bounds = self.view.bounds
        let edgeInsets = self.adjustedContentInset
        let height = self.footerViewHeight
        return CGRect(
            x: 0,
            y: bounds.height - edgeInsets.bottom - height,
            width: bounds.width,
            height: height
        )
    }
    
}

extension QTableViewController : IQLoadingViewDelegate {
    
    open func willShow(loadingView: QLoadingViewType) {
        self._updateFrame(loadingView: loadingView, bounds: self.view.bounds)
        self.view.addSubview(loadingView)
    }
    
    open func didHide(loadingView: QLoadingViewType) {
        loadingView.removeFromSuperview()
    }
    
}
