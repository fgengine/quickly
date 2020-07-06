//
//  Quickly
//

open class QTableViewControllerFooterView : QView {
    
    public var insets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet(oldValue) {
            if self.insets != oldValue { self.didChangeInsets() }
        }
    }
    
    open func didChangeInsets() {
    }
    
}

open class QTableViewController : QViewController, IQTableControllerObserver, IQKeyboardObserver, IQInputContentViewController, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController, IQModalContentViewController, IQDialogContentViewController, IQHamburgerContentViewController, IQJalousieContentViewController, IQLoadingViewDelegate {

    public private(set) var tableView: QTableView? {
        willSet {
            guard let tableView = self.tableView else { return }
            tableView.removeFromSuperview()
        }
        didSet {
            guard let tableView = self.tableView else { return }
            self.view.addSubview(tableView)
        }
    }
    public var tableController: IQTableController? {
        set(value) {
            if let tableView = self.tableView {
                if let tableController = tableView.tableController {
                    tableController.remove(observer: self)
                }
                if let tableController = value {
                    tableController.add(observer: self, priority: 0)
                }
                tableView.tableController = value
            }
        }
        get { return self.tableView?.tableController }
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
    public var footerView: QTableViewControllerFooterView? {
        set(value) {
            if self._footerView != value {
                if let footerView = self._footerView {
                    footerView.removeFromSuperview()
                }
                self._footerView = value
                if self.isLoaded == true {
                    if let footerView = self._footerView, let tableView = self.tableView {
                        footerView.frame = self._footerViewFrame()
                        footerView.insets = self._footerViewInsets()
                        self.view.insertSubview(footerView, aboveSubview: tableView)
                    }
                }
            }
        }
        get { return self._footerView }
    }
    public var footerViewHeight: CGFloat = 100 {
        didSet(oldValue) {
            if self.footerViewHeight != oldValue {
                if let footerView = self._footerView {
                    footerView.frame = self._footerViewFrame()
                }
                self.didChangeContentEdgeInsets()
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
    public var batchUpdateDelay: TimeInterval {
        didSet { self._batchUpdateTimer?.interval = self.batchUpdateDelay }
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
    private var _footerView: QTableViewControllerFooterView?
    private var _edgesForExtendedLayout: UIRectEdge?
    private var _batchUpdateTimer: QTimer? {
        willSet { self._batchUpdateTimer?.stop() }
        didSet { self._batchUpdateTimer?.start() }
    }
    private var _batchUpdateCounter: UInt
    private var _keyboard: QKeyboard!

    public override init() {
        self.batchUpdateDelay = 0.2
        self._batchUpdateCounter = 0
        super.init()
    }

    deinit {
        self.tableController = nil
        self._batchUpdateTimer = nil
        self._keyboard.remove(observer: self)
    }
    
    open override func setup() {
        super.setup()
        
        self._keyboard = QKeyboard()
    }

    open override func didLoad() {
        self.tableView = QTableView(frame: self.view.bounds)
        if let footerView = self._footerView {
            footerView.frame = self._footerViewFrame()
            footerView.insets = self._footerViewInsets()
            self.view.addSubview(footerView)
        }
        self._keyboard.add(observer: self, priority: 0)
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds: bounds)
        if let tableView = self.tableView {
            tableView.frame = bounds
        }
        if let footerView = self._footerView {
            footerView.frame = self._footerViewFrame()
            footerView.insets = self._footerViewInsets()
        }
        if let loadingView = self.loadingView, loadingView.superview != nil {
            self._updateFrame(loadingView: loadingView, bounds: bounds)
        }
    }

    open override func didChangeContentEdgeInsets() {
        super.didChangeContentEdgeInsets()
        if let tableView = self.tableView {
            self._updateContentInsets(tableView)
        }
        if let footerView = self._footerView {
            footerView.frame = self._footerViewFrame()
            footerView.insets = self._footerViewInsets()
        }
        if let loadingView = self.loadingView, loadingView.superview != nil {
            self._updateFrame(loadingView: loadingView, bounds: self.view.bounds)
        }
    }
    
    open override func prepareInteractivePresent() {
        super.prepareInteractivePresent()
        self._updateRefreshControlState()
        if self._batchUpdateCounter > 0 {
            self._triggeredBatchUpdate()
        }
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self._updateRefreshControlState()
        if self._batchUpdateCounter > 0 {
            self._triggeredBatchUpdate()
        }
    }
    
    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        if let tableView = self.tableView {
            tableView.endEditing(false)
        }
    }
    
    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        if let tableView = self.tableView {
            tableView.endEditing(false)
        }
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self._updateRefreshControlState()
    }
    
    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        if let tableController = self.tableController {
            tableController.reload([ .resetCache ])
        }
    }

    public func beginRefreshing() {
        guard let refreshControl = self._refreshControl else { return }
        refreshControl.beginRefreshing()
    }

    public func endRefreshing() {
        guard let refreshControl = self._refreshControl else { return }
        refreshControl.endRefreshing()
    }

    open func triggeredRefreshControl() {
    }

    public func setNeedBatchUpdate() {
        if let timer = self._batchUpdateTimer {
            timer.restart()
        } else {
            self._batchUpdateTimer = QTimer(interval: self.batchUpdateDelay, onFinished: { [weak self] _ in self?._triggeredBatchUpdate() })
        }
    }

    open func triggeredBatchUpdate() {
    }
    
    public func isLoading() -> Bool {
        guard let loadingView = self.loadingView else { return false }
        return loadingView.isAnimating()
    }
    
    public func startLoading() {
        guard let loadingView = self.loadingView else { return }
        loadingView.start()
    }
    
    public func stopLoading() {
        guard let loadingView = self.loadingView else { return }
        loadingView.stop()
    }
    
    // MARK: IQContentViewController
    
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
    
    open func notifyBeginUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.beginUpdateContent()
        }
    }
    
    open func notifyUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.updateContent()
        }
    }
    
    open func notifyFinishUpdateContent(velocity: CGPoint) -> CGPoint? {
        if let viewController = self.contentOwnerViewController {
            return viewController.finishUpdateContent(velocity: velocity)
        }
        return nil
    }
    
    open func notifyEndUpdateContent() {
        if let viewController = self.contentOwnerViewController {
            viewController.endUpdateContent()
        }
    }
    
    // MARK: IQTableControllerObserver
    
    open func beginScroll(_ controller: IQTableController, tableView: UITableView) {
        self.notifyBeginUpdateContent()
    }
    
    open func scroll(_ controller: IQTableController, tableView: UITableView) {
        self.notifyUpdateContent()
    }
    
    open func finishScroll(_ controller: IQTableController, tableView: UITableView, velocity: CGPoint) -> CGPoint? {
        return self.notifyFinishUpdateContent(velocity: velocity)
    }
    
    open func endScroll(_ controller: IQTableController, tableView: UITableView) {
        self.notifyEndUpdateContent()
    }
    
    open func update(_ controller: IQTableController) {
    }
    
    // MARK: IQKeyboardObserver
    
    open func willShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
        guard self.isPresented == true else {
            return
        }
        if self._edgesForExtendedLayout == nil {
            self._edgesForExtendedLayout = self.edgesForExtendedLayout
            var edgesForExtendedLayout = self.edgesForExtendedLayout
            if edgesForExtendedLayout.contains(.bottom) == true {
                edgesForExtendedLayout.remove(.bottom)
            }
            UIView.animate(withDuration: animationInfo.duration, delay: 0, options: animationInfo.animationOptions([]), animations: {
                self.additionalEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: animationInfo.endFrame.height, right: 0)
                self.edgesForExtendedLayout = edgesForExtendedLayout
            })
        }
    }
    
    open func didShowKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
    }
    
    open func willHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
        guard self.isPresented == true else {
            return
        }
        if let edgesForExtendedLayout = self._edgesForExtendedLayout {
            self._edgesForExtendedLayout = nil
            UIView.animate(withDuration: animationInfo.duration, delay: 0, options: animationInfo.animationOptions([]), animations: {
                self.additionalEdgeInsets = UIEdgeInsets.zero
                self.edgesForExtendedLayout = edgesForExtendedLayout
            })
        }
    }
    
    open func didHideKeyboard(_ keyboard: QKeyboard, animationInfo: QKeyboardAnimationInfo) {
    }
    
    // MARK: IQModalContentViewController
    
    open func modalShouldInteractive() -> Bool {
        return true
    }
    
    // MARK: IQDialogContentViewController
    
    open func dialogDidPressedOutside() {
    }
    
    // MARK: IQHamburgerContentViewController
    
    open func hamburgerShouldInteractive() -> Bool {
        return true
    }
    
    // MARK: IQJalousieContentViewController
    
    open func jalousieShouldInteractive() -> Bool {
        return true
    }

    // MARK: IQLoadingViewDelegate
    
    public func willShow(loadingView: QLoadingViewType) {
        self._updateFrame(loadingView: loadingView, bounds: self.view.bounds)
        self.view.addSubview(loadingView)
    }
    
    public func didHide(loadingView: QLoadingViewType) {
        loadingView.removeFromSuperview()
    }
        
}

// MARK: Private

private extension QTableViewController {

    @objc
    func _triggeredRefreshControl(_ sender: Any) {
        self.triggeredRefreshControl()
    }
    
    func _triggeredBatchUpdate() {
        self.loadViewIfNeeded()
        self._batchUpdateTimer?.stop()
        self._batchUpdateCounter = 0
        self.triggeredBatchUpdate()
    }

    func _updateRefreshControlState() {
        if let tableView = self.tableView {
            if self.refreshControlHidden == false && self.isPresented == true {
                tableView.refreshControl = self._refreshControl
            } else {
                if let refreshControl = self._refreshControl {
                    refreshControl.endRefreshing()
                }
                tableView.refreshControl = nil
            }
        }
    }
    
    func _updateContentInsets(_ tableView: QTableView) {
        let edgeInsets = self.adjustedContentInset
        let footerHeight = (self.footerView != nil) ? self.footerViewHeight : 0
        let oldContentInset = tableView.contentInset
        let newContentInset = UIEdgeInsets(
            top: edgeInsets.top,
            left: 0,
            bottom: edgeInsets.bottom + footerHeight,
            right: 0
        )
        tableView.contentLeftInset = edgeInsets.left
        tableView.contentRightInset = edgeInsets.right
        tableView.contentInset = newContentInset
        tableView.scrollIndicatorInsets = UIEdgeInsets(
            top: edgeInsets.top,
            left: edgeInsets.left,
            bottom: edgeInsets.bottom + footerHeight,
            right: edgeInsets.right
        )
        let deltaContentInset = UIEdgeInsets(
            top: newContentInset.top - oldContentInset.top,
            left: newContentInset.left - oldContentInset.left,
            bottom: newContentInset.bottom - oldContentInset.bottom,
            right: newContentInset.right - oldContentInset.right
        )
        if abs(deltaContentInset.top) > CGFloat.leastNonzeroMagnitude {
            let oldContentOffset = tableView.contentOffset
            let newContentOffset = CGPoint(
                x: oldContentOffset.x,
                y: max(oldContentOffset.y - deltaContentInset.top, -newContentInset.top)
            )
            tableView.setContentOffset(newContentOffset, animated: false)
        }
    }
    
    func _updateFrame(loadingView: QLoadingViewType, bounds: CGRect) {
        loadingView.frame = bounds
    }
    
    func _footerViewFrame() -> CGRect {
        let bounds = self.view.bounds
        let edgeInsets = self._footerViewInsets()
        let height = self.footerViewHeight + edgeInsets.bottom
        return CGRect(
            x: 0,
            y: bounds.height - height,
            width: bounds.width,
            height: height
        )
    }
    
    func _footerViewInsets() -> UIEdgeInsets {
        let edgeInsets = self.adjustedContentInset
        return UIEdgeInsets(
            top: 0,
            left: edgeInsets.left,
            bottom: edgeInsets.bottom,
            right: edgeInsets.right
        )
    }
    
}
