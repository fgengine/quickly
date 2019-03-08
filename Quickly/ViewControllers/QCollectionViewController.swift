//
//  Quickly
//

open class QCollectionViewController : QViewController, IQCollectionControllerObserver, IQKeyboardObserver, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController, IQModalContentViewController {
    
    public enum PagesPosition {
        case top(offset: CGFloat)
        case bottom(offset: CGFloat)
    }

    public var contentOffset: CGPoint {
        get {
            guard let collectionView = self.collectionView else { return CGPoint.zero }
            let contentOffset = collectionView.contentOffset
            let contentInset = collectionView.contentInset
            return CGPoint(
                x: contentInset.left + contentOffset.x,
                y: contentInset.top + contentOffset.y
            )
        }
    }
    public var contentSize: CGSize {
        get {
            guard let collectionView = self.collectionView else { return CGSize.zero }
            return collectionView.contentSize
        }
    }
    public private(set) var collectionView: QCollectionView? {
        willSet {
            guard let collectionView = self.collectionView else { return }
            collectionView.removeFromSuperview()
        }
        didSet {
            guard let collectionView = self.collectionView else { return }
            self.view.addSubview(collectionView)
        }
    }
    public var collectionController: IQCollectionController? {
        set(value) {
            if let collectionView = self.collectionView {
                if let collectionController = collectionView.collectionController {
                    collectionController.remove(observer: self)
                }
                if let collectionController = value {
                    collectionController.add(observer: self, priority: 0)
                }
                collectionView.collectionController = value
            }
        }
        get { return self.collectionView?.collectionController }
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
    public var pagesPosition: PagesPosition = .bottom(offset: 0) {
        didSet {
            guard let pagesView = self.pagesView else { return }
            if self.isLoaded == true {
                self._updateFrame(pagesView: pagesView, bounds: self.view.bounds)
            }
        }
    }
    public var pagesView: QPagesViewType? {
        willSet {
            guard let pagesView = self.pagesView else { return }
            if self.isLoaded == true {
                pagesView.removeFromSuperview()
            }
        }
        didSet {
            guard let pagesView = self.pagesView, let collectionView = self.collectionView else { return }
            if self.isLoaded == true {
                pagesView.sizeToFit()
                self._updateNumberOfPages(pagesView: pagesView, bounds: self.view.bounds)
                self._updateCurrentPage(pagesView: pagesView)
                self.view.insertSubview(pagesView, aboveSubview: collectionView)
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
    private var _edgesForExtendedLayout: UIRectEdge?
    private var _keyboard: QKeyboard!
    
    deinit {
        self.collectionController = nil
        self._keyboard.remove(observer: self)
    }
    
    open override func setup() {
        super.setup()
        
        self._keyboard = QKeyboard()
    }

    open override func didLoad() {
        self.collectionView = QCollectionView(frame: self.view.bounds)
        self._keyboard.add(observer: self, priority: 0)
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds: bounds)
        if let collectionView = self.collectionView {
            collectionView.frame = bounds
        }
        if let pagesView = self.pagesView {
            self._updateNumberOfPages(pagesView: pagesView, bounds: bounds)
        }
        if let loadingView = self.loadingView, loadingView.superview != nil {
            self._updateFrame(loadingView: loadingView, bounds: bounds)
        }
    }

    open override func didChangeContentEdgeInsets() {
        super.didChangeContentEdgeInsets()
        if let collectionView = self.collectionView {
            self._updateContentInsets(collectionView)
        }
        if let pagesView = self.pagesView {
            self._updateFrame(pagesView: pagesView, bounds: self.view.bounds)
        }
        if let loadingView = self.loadingView, loadingView.superview != nil {
            self._updateFrame(loadingView: loadingView, bounds: self.view.bounds)
        }
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self._updateRefreshControlState()
    }
    
    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        if let collectionView = self.collectionView {
            collectionView.endEditing(false)
        }
    }
    
    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        if let collectionView = self.collectionView {
            collectionView.endEditing(false)
        }
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self._updateRefreshControlState()
    }
    
    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        if let collectionView = self.collectionView {
            collectionView.collectionViewLayout.invalidateLayout()
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
    
    // MARK: IQCollectionControllerObserver
    
    open func scroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
        if let pagesView = self.pagesView {
            self._updateCurrentPage(pagesView: pagesView)
        }
        if let viewController = self.contentOwnerViewController {
            viewController.updateContent()
        }
    }
    
    open func zoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
        if let viewController = self.contentOwnerViewController {
            viewController.updateContent()
        }
    }
    
    open func update(_ controller: IQCollectionController) {
        if let pagesView = self.pagesView {
            self._updateNumberOfPages(pagesView: pagesView, bounds: self.view.bounds)
        }
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
    
    // MARK: Private

    @objc
    private func _triggeredRefreshControl(_ sender: Any) {
        self.triggeredRefreshControl()
    }

    private func _updateRefreshControlState() {
        if let collectionView = self.collectionView {
            if self.refreshControlHidden == false && self.isPresented == true {
                collectionView.refreshControl = self._refreshControl
            } else {
                if let refreshControl = self._refreshControl {
                    refreshControl.endRefreshing()
                }
                collectionView.refreshControl = nil
            }
        }
    }
    
    private func _updateContentInsets(_ collectionView: QCollectionView) {
        let edgeInsets = self.adjustedContentInset
        let oldContentInset = collectionView.contentInset
        let newContentInset = UIEdgeInsets(
            top: edgeInsets.top,
            left: 0,
            bottom: edgeInsets.bottom,
            right: 0
        )
        collectionView.contentLeftInset = edgeInsets.left
        collectionView.contentRightInset = edgeInsets.right
        collectionView.contentInset = newContentInset
        collectionView.scrollIndicatorInsets = edgeInsets
        let deltaContentInset = UIEdgeInsets(
            top: newContentInset.top - oldContentInset.top,
            left: newContentInset.left - oldContentInset.left,
            bottom: newContentInset.bottom - oldContentInset.bottom,
            right: newContentInset.right - oldContentInset.right
        )
        if abs(deltaContentInset.left) > CGFloat.leastNonzeroMagnitude || abs(deltaContentInset.top) > CGFloat.leastNonzeroMagnitude {
            let oldContentOffset = collectionView.contentOffset
            let newContentOffset = CGPoint(
                x: max(oldContentOffset.x - deltaContentInset.left, -newContentInset.left),
                y: max(oldContentOffset.y - deltaContentInset.top, -newContentInset.top)
            )
            collectionView.setContentOffset(newContentOffset, animated: false)
        }
    }
    
    private func _updateFrame(pagesView: QPagesViewType, bounds: CGRect) {
        let edgeInset = self.adjustedContentInset
        let pagesHeight = pagesView.frame.height
        switch self.pagesPosition {
        case .top(let offset):
            pagesView.frame = CGRect(
                x: edgeInset.left,
                y: edgeInset.top + offset,
                width: bounds.width - (edgeInset.left + edgeInset.right),
                height: pagesHeight
            )
        case .bottom(let offset):
            pagesView.frame = CGRect(
                x: edgeInset.left,
                y: bounds.height - (edgeInset.bottom + offset),
                width: bounds.width - (edgeInset.left + edgeInset.right),
                height: pagesHeight
            )
        }
    }
    
    private func _updateFrame(loadingView: QLoadingViewType, bounds: CGRect) {
        loadingView.frame = bounds.inset(by: self.inheritedEdgeInsets)
    }
    
    private func _updateCurrentPage(pagesView: QPagesViewType) {
        if let collectionView = self.collectionView {
            let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
            let contentOffset = collectionView.contentOffset
            if contentSize.width > CGFloat.leastNonzeroMagnitude && contentOffset.x > CGFloat.leastNonzeroMagnitude {
                pagesView.currentProgress = contentSize.width / (contentSize.width - contentOffset.x)
            } else {
                pagesView.currentProgress = 0
            }
        }
    }
    
    private func _updateNumberOfPages(pagesView: QPagesViewType, bounds: CGRect) {
        if let collectionView = self.collectionView {
            let contentBounds = collectionView.bounds
            let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
            if contentBounds.width > CGFloat.leastNonzeroMagnitude {
                pagesView.numberOfPages = UInt(contentSize.width / contentBounds.width)
            }
            pagesView.sizeToFit()
            self._updateFrame(pagesView: pagesView, bounds: bounds)
        }
    }
    
}

extension QCollectionViewController : IQLoadingViewDelegate {
    
    open func willShow(loadingView: QLoadingViewType) {
        self._updateFrame(loadingView: loadingView, bounds: self.view.bounds)
        if let pagesView = self.pagesView {
            self.view.insertSubview(loadingView, aboveSubview: pagesView)
        } else if let collectionView = self.collectionView {
            self.view.insertSubview(loadingView, aboveSubview: collectionView)
        } else {
            self.view.addSubview(loadingView)
        }
    }
    
    open func didHide(loadingView: QLoadingViewType) {
        loadingView.removeFromSuperview()
    }
    
}
