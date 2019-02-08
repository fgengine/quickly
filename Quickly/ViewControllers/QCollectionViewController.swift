//
//  Quickly
//

open class QCollectionViewController : QViewController, IQCollectionControllerObserver, IQKeyboardObserver, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController, IQModalContentViewController {

    public var contentOffset: CGPoint {
        get {
            guard let collectionView = self._collectionView else { return CGPoint.zero }
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
            guard let collectionView = self._collectionView else { return CGSize.zero }
            return collectionView.contentSize
        }
    }
    public var collectionController: IQCollectionController? {
        willSet {
            if let collectionController = self.collectionController {
                collectionController.removeObserver(self)
            }
        }
        didSet {
            if let collectionView = self._collectionView {
                collectionView.collectionController = self.collectionController
            }
            if let collectionController = self.collectionController {
                collectionController.addObserver(self, priority: 0)
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
    
    private var _collectionView: QCollectionView! {
        willSet {
            guard let view = self._collectionView else { return }
            view.removeFromSuperview()
        }
        didSet {
            guard let view = self._collectionView else { return }
            let edgeInsets = self.inheritedEdgeInsets
            view.contentInset = edgeInsets
            view.scrollIndicatorInsets = edgeInsets
            self.view.addSubview(view)
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
    private var _keyboard: QKeyboard!
    
    deinit {
        self.collectionController = nil
        self._keyboard.removeObserver(self)
    }
    
    open override func setup() {
        super.setup()
        
        self._keyboard = QKeyboard()
    }

    open override func didLoad() {
        self._collectionView = QCollectionView(frame: self.view.bounds, layout: QCollectionFlowLayout())
        self._collectionView.collectionController = self.collectionController
        self._keyboard.addObserver(self, priority: 0)
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds: bounds)
        if let view = self._collectionView {
            view.frame = bounds
        }
        if let view = self.loadingView, view.superview != nil {
            self._updateFrame(loadingView: view, bounds: bounds)
        }
    }

    open override func didChangeAdditionalEdgeInsets() {
        super.didChangeAdditionalEdgeInsets()
        if let view = self._collectionView {
            self._updateContentInsets(view)
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
        self._collectionView.endEditing(false)
    }
    
    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self._collectionView.endEditing(false)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self._updateRefreshControlState()
    }
    
    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        if let view = self._collectionView {
            self._updateContentInsets(view)
        }
        if let collectionLayout = self._collectionView.collectionLayout {
            collectionLayout.invalidateLayout()
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
    
    // MAKR: IQCollectionControllerObserver
    
    open func scroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
        if let vc = self.contentOwnerViewController {
            vc.updateContent()
        }
    }
    
    open func zoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
        if let vc = self.contentOwnerViewController {
            vc.updateContent()
        }
    }
    
    open func update(_ controller: IQCollectionController) {
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
                self._collectionView.refreshControl = self._refreshControl
            } else {
                if let refreshControl = self._refreshControl {
                    refreshControl.endRefreshing()
                }
                self._collectionView.refreshControl = nil
            }
        }
    }
    
    private func _updateContentInsets(_ view: QCollectionView) {
        let edgeInsets = self.adjustedContentInset
        view.contentLeftInset = edgeInsets.left
        view.contentRightInset = edgeInsets.right
        view.contentInset = UIEdgeInsets(
            top: edgeInsets.top,
            left: 0,
            bottom: edgeInsets.bottom,
            right: 0
        )
        view.scrollIndicatorInsets = edgeInsets
        if view.contentOffset.x < 0 || view.contentOffset.y < 0 {
            let x = (view.contentOffset.x < 0) ? -edgeInsets.left : view.contentOffset.x
            let y = (view.contentOffset.y < 0) ? -edgeInsets.top : view.contentOffset.y
            view.contentOffset = CGPoint(x: x, y: y)
        }
    }
    
    private func _updateFrame(loadingView: QLoadingViewType, bounds: CGRect) {
        loadingView.frame = bounds.inset(by: self.inheritedEdgeInsets)
    }
    
}

extension QCollectionViewController : IQLoadingViewDelegate {
    
    open func willShow(loadingView: QLoadingViewType) {
        self._updateFrame(loadingView: loadingView, bounds: self.view.bounds)
        self.view.addSubview(loadingView)
    }
    
    open func didHide(loadingView: QLoadingViewType) {
        loadingView.removeFromSuperview()
    }
    
}
