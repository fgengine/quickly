//
//  Quickly
//

open class QNibViewController : QViewController, IQInputContentViewController, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController, IQModalContentViewController, IQDialogContentViewController, IQHamburgerContentViewController, IQJalousieContentViewController, IQLoadingViewDelegate {

    @IBOutlet
    public var rootView: UIView! {
        willSet {
            guard let rootView = self.rootView else { return }
            rootView.removeFromSuperview()
        }
        didSet {
            guard let rootView = self.rootView else { return }
            rootView.translatesAutoresizingMaskIntoConstraints = false
            rootView.frame = self.view.bounds
            self.view.addSubview(rootView)
            self._updateConstraints(self.view, rootView: rootView)
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
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.delegate = self
        }
    }
    
    private var _rootConstraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._rootConstraints) }
        didSet { self.view.addConstraints(self._rootConstraints) }
    }
    private var _loadingConstraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._loadingConstraints) }
        didSet { self.view.addConstraints(self._loadingConstraints) }
    }

    open func nibName() -> String {
        return String(describing: self.classForCoder)
    }

    open func nibBundle() -> Bundle {
        return Bundle.main
    }

    open override func didLoad() {
        let nib = UINib(nibName: self.nibName(), bundle: self.nibBundle())
        _ = nib.instantiate(withOwner: self, options: nil)
    }
    
    open override func didChangeContentEdgeInsets() {
        super.didChangeContentEdgeInsets()
        if let rootView = self.rootView {
            self._updateConstraints(self.view, rootView: rootView)
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
        get { return CGPoint.zero }
    }
    
    public var contentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.view.bounds.size
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

    open func willShow(loadingView: QLoadingViewType) {
        self.view.addSubview(loadingView)
        self._updateConstraints(self.view, loadingView: loadingView)
    }

    open func didHide(loadingView: QLoadingViewType) {
        loadingView.removeFromSuperview()
    }

}

// MARK: Private

private extension QNibViewController {
    
    func _updateConstraints(_ view: UIView, rootView: UIView) {
        let edgeInsets = self.inheritedEdgeInsets
        self._rootConstraints = [
            rootView.topLayout == view.topLayout.offset(edgeInsets.top),
            rootView.leadingLayout == view.leadingLayout.offset(edgeInsets.left),
            rootView.trailingLayout == view.trailingLayout.offset(-edgeInsets.right),
            rootView.bottomLayout == view.bottomLayout.offset(-edgeInsets.bottom)
        ]
    }
    
    func _updateConstraints(_ view: UIView, loadingView: QLoadingViewType) {
        self._loadingConstraints = [
            loadingView.topLayout == view.topLayout,
            loadingView.leadingLayout == view.leadingLayout,
            loadingView.trailingLayout == view.trailingLayout,
            loadingView.bottomLayout == view.bottomLayout
        ]
    }

}

// MARK: IQContainerSpec

extension QNibViewController : IQContainerSpec {
    
    open var containerSize: CGSize {
        get { return self.view.bounds.size }
    }
    open var containerLeftInset: CGFloat {
        get { return self.inheritedEdgeInsets.left }
    }
    open var containerRightInset: CGFloat {
        get { return self.inheritedEdgeInsets.right }
    }
    
}
