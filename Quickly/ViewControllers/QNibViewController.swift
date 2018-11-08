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
            guard let view = self.rootView else { return }
            view.removeFromSuperview()
        }
        didSet {
            guard let view = self.rootView else { return }
            view.frame = self.view.bounds
            self.view.addSubview(view)
        }
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

    open override func layout(bounds: CGRect) {
        if let rootView = self.rootView {
            self._updateRootFrame(rootView, bounds: bounds)
        }
    }
    
    open override func didChangeAdditionalEdgeInsets() {
        if let rootView = self.rootView {
            self._updateRootFrame(rootView, bounds: self.view.bounds)
        }
    }

}

extension QNibViewController {

    private func _updateRootFrame(_ rootView: UIView, bounds: CGRect) {
        let edgeInsets = self.inheritedEdgeInsets
        rootView.frame = bounds.inset(by: edgeInsets)
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
