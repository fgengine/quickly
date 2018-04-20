//
//  Quickly
//

open class QStackPageViewController : QViewController, IQStackPageViewController {

    open weak var stackViewController: IQStackViewController?
    open var stackbar: QStackbar? {
        willSet {
            guard let stackbar = self.stackbar else { return }
            if self.isLoaded == true {
                stackbar.removeFromSuperview()
                self.setNeedLayout()
            }
        }
        didSet {
            guard let stackbar = self.stackbar else { return }
            if self.isLoaded == true {
                stackbar.frame = self.stackbarFrame(bounds: self.view.bounds)
                stackbar.edgeInsets = self.stackbarEdgeInsets()
                self.view.insertSubview(stackbar, aboveSubview: self.contentViewController.view)
            }
            self.updateAdditionalEdgeInsets()
        }
    }
    open var stackbarHeight: CGFloat {
        didSet {
            self.updateAdditionalEdgeInsets()
            self.setNeedLayout()
        }
    }
    open var stackbarHidden: Bool {
        didSet {
            self.updateAdditionalEdgeInsets()
            self.setNeedLayout()
        }
    }
    open private(set) var contentViewController: IQStackContentViewController
    open var presentAnimation: IQStackViewControllerPresentAnimation?
    open var dismissAnimation: IQStackViewControllerDismissAnimation?
    open var interactiveDismissAnimation: IQStackViewControllerinteractiveDismissAnimation?

    public init(contentViewController: IQStackContentViewController) {
        self.stackbarHeight = 50
        self.stackbarHidden = false
        self.contentViewController = contentViewController

        super.init()
    }

    open override func setup() {
        super.setup()

        self.updateAdditionalEdgeInsets()

        self.contentViewController.stackPageViewController = self
        self.contentViewController.parent = self
    }

    open override func didLoad() {
        self.contentViewController.view.frame = self.view.bounds
        self.view.addSubview(self.contentViewController.view)

        if let stackbar = self.stackbar {
            self.view.addSubview(stackbar)
        } else {
            self.stackbar = QStackbar()
        }
    }

    open override func layout(bounds: CGRect) {
        super.layout(bounds: bounds)

        if let stackbar = self.stackbar {
            stackbar.edgeInsets = self.stackbarEdgeInsets()
            stackbar.frame = self.stackbarFrame(bounds: bounds)
        }
    }

    open func setStackbar(_ view: QStackbar?, animated: Bool) {
    }

    open func setStackbarHeight(_ value: CGFloat, animated: Bool) {
    }

    open func setStackbarHidden(_ value: Bool, animated: Bool) {
    }

    open func updateContent() {
    }

    open override func supportedOrientations() -> UIInterfaceOrientationMask {
        return self.contentViewController.supportedOrientations()
    }

    open override func preferedStatusBarHidden() -> Bool {
        return self.contentViewController.preferedStatusBarHidden()
    }

    open override func preferedStatusBarStyle() -> UIStatusBarStyle {
        return self.contentViewController.preferedStatusBarStyle()
    }

    open override func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return self.contentViewController.preferedStatusBarAnimation()
    }

    private func updateAdditionalEdgeInsets() {
        self.additionalEdgeInsets = UIEdgeInsets(
            top: (self.stackbar != nil && self.stackbarHidden == false) ? self.stackbarHeight : 0,
            left: 0,
            bottom: 0,
            right: 0
        )
    }

    private func stackbarFrame(bounds: CGRect) -> CGRect {
        let edgeInsets = self.inheritedEdgeInsets
        let fullHeight = self.stackbarHeight + edgeInsets.top
        if self.stackbarHidden == true {
            return CGRect(
                x: bounds.origin.x,
                y: bounds.origin.y - fullHeight,
                width: bounds.size.width,
                height: fullHeight
            )
        }
        return CGRect(
            x: bounds.origin.x,
            y: bounds.origin.y,
            width: bounds.size.width,
            height: fullHeight
        )
    }

    private func stackbarEdgeInsets() -> UIEdgeInsets {
        let edgeInsets = self.inheritedEdgeInsets
        return UIEdgeInsets(
            top: edgeInsets.top,
            left: edgeInsets.left,
            bottom: 0,
            right: edgeInsets.right
        )
    }

}
