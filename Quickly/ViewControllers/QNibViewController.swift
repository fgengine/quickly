//
//  Quickly
//

open class QNibViewController : QViewController, IQStackContentViewController {

    open var stackPageViewController: IQStackPageViewController?
    open var stackPageContentOffset: CGPoint {
        get { return CGPoint.zero }
    }
    open var stackPageContentSize: CGSize {
        get {
            guard self.isLoaded == true else { return CGSize.zero }
            return self.view.bounds.size
        }
    }

    @IBOutlet
    open var rootView: UIView! {
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
        return InvisibleView(viewController: self)
    }

    open override func didLoad() {
        let nib = UINib(nibName: self.nibName(), bundle: self.nibBundle())
        _ = nib.instantiate(withOwner: self, options: nil)
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds : bounds)
        if let view = self.rootView {
            view.frame = UIEdgeInsetsInsetRect(self.view.bounds, self.inheritedEdgeInsets)
        }
    }

}
