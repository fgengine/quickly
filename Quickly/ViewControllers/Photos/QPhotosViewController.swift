//
//  Quickly
//

open class QPhotosViewController : QViewController, IQContentViewController, IQInputContentViewController, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController, IQModalContentViewController, IQDialogContentViewController, IQHamburgerContentViewController, IQCollectionControllerObserver, IQKeyboardObserver, IQLoadingViewDelegate {
    
    public private(set) var items: [IQPhotoItem] = []
    public private(set) var selectedItem: IQPhotoItem?
    public private(set) var previewCollectionView: QCollectionView? {
        willSet {
            guard let collectionView = self.previewCollectionView else { return }
            collectionView.removeFromSuperview()
        }
        didSet {
            guard let collectionView = self.previewCollectionView else { return }
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.alwaysBounceHorizontal = true
            collectionView.isPagingEnabled = true
            self.view.addSubview(collectionView)
        }
    }
    public private(set) var thumbnailSeparatorView: QDisplayView? {
        willSet {
            guard let separatorView = self.thumbnailSeparatorView else { return }
            separatorView.removeFromSuperview()
        }
        didSet {
            guard let separatorView = self.thumbnailSeparatorView else { return }
            self.view.addSubview(separatorView)
        }
    }
    public private(set) var thumbnailCollectionView: QCollectionView? {
        willSet {
            guard let collectionView = self.thumbnailCollectionView else { return }
            collectionView.removeFromSuperview()
        }
        didSet {
            guard let collectionView = self.thumbnailCollectionView else { return }
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.alwaysBounceHorizontal = true
            self.view.addSubview(collectionView)
        }
    }
    public var thumbnailSeparatorHeight: CGFloat = 1 {
        didSet(oldValue) {
            if self.thumbnailSeparatorHeight != oldValue {
                if let separatorView = self.thumbnailSeparatorView {
                    separatorView.frame = self._thumbnailSeparatorFrame()
                }
            }
        }
    }
    public var thumbnailItemSpacing: CGFloat = 4 {
        didSet(oldValue) {
            if self.thumbnailItemSpacing != oldValue {
                self._thumbnailCollectionLayout.minimumInteritemSpacing = self.thumbnailItemSpacing
            }
        }
    }
    public var thumbnailsSpacing: CGFloat = 8 {
        didSet(oldValue) {
            if self.thumbnailsSpacing != oldValue {
                if let collectionView = self.previewCollectionView {
                    self._updateContentInsets(previewCollectionView: collectionView)
                }
                if let collectionView = self.thumbnailCollectionView {
                    collectionView.frame = self._thumbnailCollectionFrame()
                    self._updateContentInsets(thumbnailCollectionView: collectionView)
                }
            }
        }
    }
    public var thumbnailHeight: CGFloat = 60 {
        didSet(oldValue) {
            if self.thumbnailHeight != oldValue {
                if let collectionView = self.thumbnailCollectionView {
                    collectionView.frame = self._thumbnailCollectionFrame()
                }
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
    
    private lazy var _previewCollectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    private var _previewCollectionController: PreviewController? {
        set(value) {
            if let collectionView = self.previewCollectionView {
                if let collectionController = collectionView.collectionController {
                    collectionController.remove(observer: self)
                }
                if let collectionController = value {
                    collectionController.add(observer: self, priority: 0)
                }
                collectionView.collectionController = value
            }
        }
        get { return self.previewCollectionView?.collectionController as? PreviewController }
    }
    private lazy var _thumbnailCollectionLayout: ThumbnailLayout = {
        let layout = ThumbnailLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = self.thumbnailItemSpacing
        layout.minimumLineSpacing = 0
        return layout
    }()
    private var _thumbnailCollectionController: ThumbnailController? {
        set(value) {
            if let collectionView = self.thumbnailCollectionView {
                if let collectionController = collectionView.collectionController {
                    collectionController.remove(observer: self)
                }
                if let collectionController = value {
                    collectionController.add(observer: self, priority: 0)
                }
                collectionView.collectionController = value
            }
        }
        get { return self.thumbnailCollectionView?.collectionController as? ThumbnailController }
    }
    private var _edgesForExtendedLayout: UIRectEdge?
    private var _keyboard: QKeyboard!
    
    deinit {
        self._thumbnailCollectionController = nil
        self._previewCollectionController = nil
        self._keyboard.remove(observer: self)
    }
    
    open override func setup() {
        super.setup()
        
        self._keyboard = QKeyboard()
    }

    open override func didLoad() {
        self.previewCollectionView = QCollectionView(frame: self._previewCollectionFrame(), collectionViewLayout: self._previewCollectionLayout)
        self._previewCollectionController = PreviewController(photos: self.items, selectedPhoto: self.selectedItem, didSelectPhoto: { [weak self] photo in
            guard let self = self else { return }
            self.selectedItem = photo
            self._thumbnailCollectionController?.set(selectedPhoto: photo)
        })
        self.thumbnailSeparatorView = QDisplayView(frame: self._thumbnailSeparatorFrame(), backgroundColor: UIColor.clear)
        self.thumbnailCollectionView = QCollectionView(frame: self._thumbnailCollectionFrame(), collectionViewLayout: self._thumbnailCollectionLayout)
        self._thumbnailCollectionController = ThumbnailController(photos: self.items, selectedPhoto: self.selectedItem, didSelectPhoto: { [weak self] photo in
            guard let self = self else { return }
            self.selectedItem = photo
            self._previewCollectionController?.set(selectedPhoto: photo)
        })
        self._keyboard.add(observer: self, priority: 0)
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds: bounds)
        if let collectionView = self.previewCollectionView {
            collectionView.frame = self._previewCollectionFrame()
        }
        if let separatorView = self.thumbnailSeparatorView {
            separatorView.frame = self._thumbnailSeparatorFrame()
        }
        if let collectionView = self.thumbnailCollectionView {
            collectionView.frame = self._thumbnailCollectionFrame()
        }
        if let loadingView = self.loadingView, loadingView.superview != nil {
            loadingView.frame = self._loadingFrame()
        }
    }

    open override func didChangeContentEdgeInsets() {
        super.didChangeContentEdgeInsets()
        if let collectionView = self.previewCollectionView {
            self._updateContentInsets(previewCollectionView: collectionView)
            collectionView.frame = self._previewCollectionFrame()
        }
        if let separatorView = self.thumbnailSeparatorView {
            separatorView.frame = self._thumbnailSeparatorFrame()
        }
        if let collectionView = self.thumbnailCollectionView {
            self._updateContentInsets(thumbnailCollectionView: collectionView)
            collectionView.frame = self._thumbnailCollectionFrame()
        }
        if let loadingView = self.loadingView, loadingView.superview != nil {
            loadingView.frame = self._loadingFrame()
        }
    }
    
    open override func prepareInteractiveDismiss() {
        super.prepareInteractiveDismiss()
        if let collectionView = self.previewCollectionView {
            collectionView.endEditing(false)
        }
        if let collectionView = self.thumbnailCollectionView {
            collectionView.endEditing(false)
        }
    }
    
    open override func willDismiss(animated: Bool) {
        super.willDismiss(animated: animated)
        if let collectionView = self.previewCollectionView {
            collectionView.endEditing(false)
        }
        if let collectionView = self.thumbnailCollectionView {
            collectionView.endEditing(false)
        }
    }
    
    open override func willTransition(size: CGSize) {
        super.willTransition(size: size)
        if let collectionView = self.previewCollectionView {
            collectionView.collectionViewLayout.invalidateLayout()
        }
        if let collectionView = self.thumbnailCollectionView {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    // MARK: Public
    
    public func set(items: [IQPhotoItem], selectedItem: IQPhotoItem?) {
        self.items = items
        if let selectedItem = selectedItem {
            self.selectedItem = selectedItem
        } else {
            self.selectedItem = items.first
        }
        if let controller = self._previewCollectionController {
            controller.set(photos: items, selectedPhoto: selectedItem)
        }
        if let controller = self._thumbnailCollectionController {
            controller.set(photos: items, selectedPhoto: selectedItem)
        }
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

    // MARK: IQContentViewController

    public var contentOffset: CGPoint {
        get {
            guard let collectionView = self.previewCollectionView else { return CGPoint.zero }
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
            guard let collectionView = self.previewCollectionView else { return CGSize.zero }
            return collectionView.contentSize
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

    // MARK: IQDialogContentViewController

    open func dialogDidPressedOutside() {
    }

    // MARK: IQCollectionControllerObserver

    open func beginScroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
        self.notifyBeginUpdateContent()
    }

    open func scroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
        self.notifyUpdateContent()
    }

    open func finishScroll(_ controller: IQCollectionController, collectionView: UICollectionView, velocity: CGPoint) -> CGPoint? {
        return self.notifyFinishUpdateContent(velocity: velocity)
    }

    open func endScroll(_ controller: IQCollectionController, collectionView: UICollectionView) {
        self.notifyEndUpdateContent()
    }

    open func beginZoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
        self.notifyBeginUpdateContent()
    }

    open func zoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
        self.notifyUpdateContent()
    }

    open func endZoom(_ controller: IQCollectionController, collectionView: UICollectionView) {
        self.notifyEndUpdateContent()
    }

    open func update(_ controller: IQCollectionController) {
        self.notifyUpdateContent()
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

    // MARK: IQLoadingViewDelegate

    open func willShow(loadingView: QLoadingViewType) {
        loadingView.frame = self._loadingFrame()
        self.view.addSubview(loadingView)
    }

    open func didHide(loadingView: QLoadingViewType) {
        loadingView.removeFromSuperview()
    }
    
}

// MARK: Private

private extension QPhotosViewController {
    
    func _previewCollectionFrame() -> CGRect {
        return self.view.bounds
    }
    
    func _thumbnailSeparatorFrame() -> CGRect {
        let thumbnailFrame = self._thumbnailCollectionFrame()
        return CGRect(
            x: thumbnailFrame.origin.x,
            y: thumbnailFrame.origin.y - self.thumbnailSeparatorHeight,
            width: thumbnailFrame.width,
            height: self.thumbnailSeparatorHeight
        )
    }
    
    func _thumbnailCollectionFrame() -> CGRect {
        let bounds = self.view.bounds
        let edgeInsets = self.adjustedContentInset
        return CGRect(
            x: bounds.origin.x,
            y: (bounds.origin.y + bounds.height) - (self.thumbnailsSpacing + self.thumbnailHeight + edgeInsets.bottom),
            width: bounds.width,
            height: self.thumbnailsSpacing + self.thumbnailHeight + edgeInsets.bottom
        )
    }
    
    func _loadingFrame() -> CGRect {
        return self.view.bounds
    }
    
    func _updateContentInsets(previewCollectionView: QCollectionView) {
        let edgeInsets = self.adjustedContentInset
        let newContentInset = UIEdgeInsets(
            top: edgeInsets.top,
            left: 0,
            bottom: edgeInsets.bottom + self.thumbnailSeparatorHeight + self.thumbnailHeight,
            right: 0
        )
        previewCollectionView.contentLeftInset = edgeInsets.left
        previewCollectionView.contentRightInset = edgeInsets.right
        previewCollectionView.contentInset = newContentInset
        previewCollectionView.scrollIndicatorInsets = edgeInsets
    }
    
    func _updateContentInsets(thumbnailCollectionView: QCollectionView) {
        let edgeInsets = self.adjustedContentInset
        let newContentInset = UIEdgeInsets(
            top: self.thumbnailsSpacing,
            left: 0,
            bottom: max(edgeInsets.bottom, self.thumbnailsSpacing),
            right: 0
        )
        thumbnailCollectionView.contentLeftInset = edgeInsets.left
        thumbnailCollectionView.contentRightInset = edgeInsets.right
        thumbnailCollectionView.contentInset = newContentInset
        thumbnailCollectionView.scrollIndicatorInsets = edgeInsets
    }
    
}
