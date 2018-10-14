//
//  Quickly
//

open class QCollectionViewController : QViewController, IQCollectionControllerObserver, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController {

    #if DEBUG
    open override var logging: Bool {
        get { return true }
    }
    #endif
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
    public var collectionController: IQCollectionController? {
        willSet {
            if let collectionController = self.collectionController {
                collectionController.removeObserver(self)
            }
        }
        didSet {
            if let collectionView = self.collectionView {
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
    private var collectionView: QCollectionView! {
        willSet {
            guard let view = self.collectionView else { return }
            view.removeFromSuperview()
        }
        didSet {
            guard let view = self.collectionView else { return }
            let edgeInsets = self.inheritedEdgeInsets
            view.contentInset = edgeInsets
            view.scrollIndicatorInsets = edgeInsets
            self.view.addSubview(view)
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
    private var keyboard: QKeyboard!
    
    deinit {
        self.collectionController = nil
        self.keyboard.removeObserver(self)
    }
    
    open override func setup() {
        super.setup()
        
        self.keyboard = QKeyboard()
    }

    open override func didLoad() {
        self.collectionView = QCollectionView(frame: self.view.bounds, layout: QCollectionFlowLayout())
        self.collectionView.collectionController = self.collectionController
        self.keyboard.addObserver(self, priority: 0)
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds: bounds)
        if let view = self.collectionView {
            view.frame = bounds
        }
    }

    open override func didChangeAdditionalEdgeInsets() {
        super.didChangeAdditionalEdgeInsets()
        if let view = self.collectionView {
            self._updateContentInsets(view)
        }
    }

    open override func willPresent(animated: Bool) {
        super.willPresent(animated: animated)
        self._updateRefreshControlState()
    }
    
    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        self.collectionView.endEditing(false)
    }
    
    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        self.collectionView.endEditing(false)
    }

    open override func didDismiss(animated: Bool) {
        super.didDismiss(animated: animated)
        self._updateRefreshControlState()
    }
    
    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        if let view = self.collectionView {
            self._updateContentInsets(view)
        }
        if let collectionLayout = self.collectionView.collectionLayout {
            collectionLayout.invalidateLayout()
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

    @objc
    private func _triggeredRefreshControl(_ sender: Any) {
        self.triggeredRefreshControl()
    }

    private func _updateRefreshControlState() {
        if self.isLoaded == true {
            if self.refreshControlHidden == false && self.isPresented == true {
                self.collectionView.refreshControl = self.storeRefreshControl
            } else {
                if let refreshControl = self.storeRefreshControl {
                    refreshControl.endRefreshing()
                }
                self.collectionView.refreshControl = nil
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

}

extension QCollectionViewController : IQKeyboardObserver {
    
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
    
}
