//
//  Quickly
//

open class QNibViewController : QViewController, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController, IQModalContentViewController {

    public var contentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    public var contentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.view.bounds.size
        }
    }
    public var screenLeftInset: CGFloat = 0
    public var screenRightInset: CGFloat = 0
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
        if let loadingView = self.loadingView, loadingView.superview != nil {
            self._updateConstraints(self.view, loadingView: loadingView)
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

}

extension QNibViewController {
    
    private func _updateConstraints(_ view: UIView, rootView: UIView) {
        let edgeInsets = self.inheritedEdgeInsets
        self._rootConstraints = [
            rootView.topLayout == view.topLayout.offset(edgeInsets.top),
            rootView.leadingLayout == view.leadingLayout.offset(edgeInsets.left),
            rootView.trailingLayout == view.trailingLayout.offset(-edgeInsets.right),
            rootView.bottomLayout == view.bottomLayout.offset(-edgeInsets.bottom)
        ]
    }
    
    private func _updateConstraints(_ view: UIView, loadingView: QLoadingViewType) {
        let edgeInsets = self.inheritedEdgeInsets
        self._loadingConstraints = [
            loadingView.topLayout == view.topLayout.offset(edgeInsets.top),
            loadingView.leadingLayout == view.leadingLayout.offset(edgeInsets.left),
            loadingView.trailingLayout == view.trailingLayout.offset(-edgeInsets.right),
            loadingView.bottomLayout == view.bottomLayout.offset(-edgeInsets.bottom)
        ]
    }

}

extension QNibViewController : IQLoadingViewDelegate {
    
    open func willShow(loadingView: QLoadingViewType) {
        self.view.addSubview(loadingView)
        self._updateConstraints(self.view, loadingView: loadingView)
    }
    
    open func didHide(loadingView: QLoadingViewType) {
        loadingView.removeFromSuperview()
    }
    
}

extension QNibViewController : IQContainerSpec {
    
    open var containerSize: CGSize {
        get { return self.view.bounds.size }
    }
    open var containerLeftInset: CGFloat {
        get { return self.screenLeftInset }
    }
    open var containerRightInset: CGFloat {
        get { return self.screenRightInset }
    }
    
}
