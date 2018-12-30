//
//  Quickly
//

open class QNibViewController : QViewController, IQStackContentViewController, IQPageContentViewController, IQGroupContentViewController {

    #if DEBUG
    open override var logging: Bool {
        get { return true }
    }
    #endif
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
            self._updateConstraints(self.view, rootView)
        }
    }
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.view.removeConstraints(self._constraints) }
        didSet { self.view.addConstraints(self._constraints) }
    }

    open func nibName() -> String {
        return String(describing: self.classForCoder)
    }

    open func nibBundle() -> Bundle {
        return Bundle.main
    }
    
    open override func load() -> ViewType {
        return QViewControllerDefaultView(viewController: self)
    }

    open override func didLoad() {
        let nib = UINib(nibName: self.nibName(), bundle: self.nibBundle())
        _ = nib.instantiate(withOwner: self, options: nil)
    }
    
    open override func didChangeAdditionalEdgeInsets() {
        if let rootView = self.rootView {
            self._updateConstraints(self.view, rootView)
        }
    }

}

extension QNibViewController {
    
    private func _updateConstraints(_ view: UIView, _ rootView: UIView) {
        let edgeInsets = self.inheritedEdgeInsets
        self._constraints = [
            rootView.topLayout == view.topLayout + edgeInsets.top,
            rootView.leadingLayout == view.leadingLayout + edgeInsets.left,
            rootView.trailingLayout == view.trailingLayout - edgeInsets.right,
            rootView.bottomLayout == view.bottomLayout - edgeInsets.bottom
        ]
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
