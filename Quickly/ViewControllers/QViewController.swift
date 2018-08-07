//
//  Quickly
//

open class QViewController : NSObject, IQViewController {

    public typealias ViewType = IQViewController.ViewType

    open weak var delegate: IQViewControllerDelegate?
    open weak var parent: IQViewController? {
        set(value) {
            guard self._parent !== value else { return }
            if self._parentChanging == false {
                self._parentChanging = true
                if let parent = self.parent {
                    parent.removeChild(self)
                }
                self._parent = value
                if let parent = self.parent {
                    parent.addChild(self)
                }
                self._parentChanging = false
            } else {
                self._parent = value
            }
        }
        get { return self._parent }
    }
    open private(set) var child: [IQViewController] = []
    open var edgesForExtendedLayout: UIRectEdge {
        didSet(oldValue) {
            if self.edgesForExtendedLayout != oldValue {
                self.didChangeAdditionalEdgeInsets()
            }
        }
    }
    open var additionalEdgeInsets: UIEdgeInsets {
        didSet(oldValue) {
            if self.additionalEdgeInsets != oldValue {
                self.didChangeAdditionalEdgeInsets()
            }
        }
    }
    open var inheritedEdgeInsets: UIEdgeInsets {
        get {
            var edgeInsets = UIEdgeInsets.zero
            var edges = self.edgesForExtendedLayout
            var target = self.parent
            while let vc = target {
                let additionalEdgeInsets = vc.additionalEdgeInsets
                let edgesForExtendedLayout = vc.edgesForExtendedLayout
                if edges.contains(.top) == true {
                    if edgesForExtendedLayout.contains(.top) == true {
                        edgeInsets.top += additionalEdgeInsets.top
                    } else {
                        edges.remove(.top)
                    }
                }
                if edges.contains(.left) == true {
                    if edgesForExtendedLayout.contains(.left) == true {
                        edgeInsets.left += additionalEdgeInsets.left
                    } else {
                        edges.remove(.left)
                    }
                }
                if edges.contains(.right) == true {
                    if edgesForExtendedLayout.contains(.right) == true {
                        edgeInsets.right += additionalEdgeInsets.right
                    } else {
                        edges.remove(.right)
                    }
                }
                if edges.contains(.bottom) == true {
                    if edgesForExtendedLayout.contains(.bottom) == true {
                        edgeInsets.bottom += additionalEdgeInsets.bottom
                    } else {
                        edges.remove(.bottom)
                    }
                }
                target = vc.parent
            }
            return edgeInsets
        }
    }
    open var adjustedContentInset: UIEdgeInsets {
        get {
            let inheritedEdgeInsets = self.inheritedEdgeInsets
            return UIEdgeInsets(
                top: self.additionalEdgeInsets.top + inheritedEdgeInsets.top,
                left: self.additionalEdgeInsets.left + inheritedEdgeInsets.left,
                bottom: self.additionalEdgeInsets.bottom + inheritedEdgeInsets.bottom,
                right: self.additionalEdgeInsets.right + inheritedEdgeInsets.right
            )
        }
    }
    open var view: ViewType {
        get {
            self.loadViewIfNeeded()
            return self._view
        }
    }
    open var isLoaded: Bool {
        get { return (self._view != nil) }
    }
    open private(set) var isPresented: Bool
    #if DEBUG
    open var logging: Bool {
        get { return false }
    }
    #endif

    private weak var _parent: IQViewController!
    private var _parentChanging: Bool = false
    private var _view: ViewType!

    public override init() {
        self.edgesForExtendedLayout = .all
        self.additionalEdgeInsets = UIEdgeInsets.zero
        self.isPresented = false
        super.init()
        self.setup()
    }

    deinit {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).deinit")
        }
        #endif
    }

    open func setup() {
    }

    open func load() -> ViewType {
        return QViewControllerTransparentView(viewController: self)
    }

    open func loadViewIfNeeded() {
        if self._view == nil {
            self._view = self.load()
            self.didLoad()
        }
    }

    open func didLoad() {
    }

    open func setNeedLayout() {
        if self.isLoaded == true {
            self.view.setNeedsLayout()
        }
    }

    open func layoutIfNeeded() {
        if self.isLoaded == true {
            self.view.layoutIfNeeded()
        }
    }

    open func layout(bounds: CGRect) {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).layout(bounds: \(bounds)")
        }
        #endif
    }

    open func didChangeAdditionalEdgeInsets() {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).didChangeAdditionalEdgeInsets()")
        }
        #endif
        self.setNeedLayout()
        self.child.forEach({
            $0.didChangeAdditionalEdgeInsets()
        })
    }

    open func prepareInteractivePresent() {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).prepareInteractivePresent()")
        }
        #endif
    }

    open func cancelInteractivePresent() {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).cancelInteractivePresent()")
        }
        #endif
    }

    open func finishInteractivePresent() {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).finishInteractivePresent()")
        }
        #endif
    }

    open func willPresent(animated: Bool) {
        self.isPresented = true
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).willPresent(animated: \(animated))")
        }
        #endif
    }

    open func didPresent(animated: Bool) {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).didPresent(animated: \(animated))")
        }
        #endif
    }

    open func prepareInteractiveDismiss() {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).prepareInteractiveDismiss()")
        }
        #endif
    }

    open func cancelInteractiveDismiss() {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).cancelInteractiveDismiss()")
        }
        #endif
    }

    open func finishInteractiveDismiss() {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).finishInteractiveDismiss()")
        }
        #endif
    }

    open func willDismiss(animated: Bool) {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).willDismiss(animated: \(animated))")
        }
        #endif
    }

    open func didDismiss(animated: Bool) {
        self.isPresented = false
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).didDismiss(animated: \(animated))")
        }
        #endif
    }

    open func willTransition(size: CGSize) {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).willTransition(size: \(size))")
        }
        #endif
    }

    open func didTransition(size: CGSize) {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).didTransition(size: \(size))")
        }
        #endif
    }

    open func addViewController(_ viewController: IQViewController) {
        viewController.parent = self
    }

    open func removeViewController(_ viewController: IQViewController) {
        viewController.parent = nil
    }
    
    open func removeFromParentViewController() {
        self.parent = nil
    }

    open func parentOf< ParentType >() -> ParentType? {
        var parent = self.parent
        while let safe = parent {
            if let temp = safe as? ParentType {
                return temp
            }
            parent = safe.parent
        }
        return nil
    }

    open func addChild(_ viewController: IQViewController) {
        if self.child.contains(where: { return $0 === viewController }) == false {
            self.child.append(viewController)
            viewController.parent = self
        }
    }

    open func removeChild(_ viewController: IQViewController) {
        if let index = self.child.index(where: { return $0 === viewController }) {
            self.child.remove(at: index)
            viewController.parent = nil
        }
    }

    open func supportedOrientations() -> UIInterfaceOrientationMask {
        return .all
    }

    open func preferedStatusBarHidden() -> Bool {
        return false
    }

    open func preferedStatusBarStyle() -> UIStatusBarStyle {
        return .default
    }

    open func preferedStatusBarAnimation() -> UIStatusBarAnimation {
        return .fade
    }

    open func setNeedUpdateStatusBar() {
        if let delegate = self.delegate {
            delegate.requestUpdateStatusBar(viewController: self)
        } else if let parent = self.parent {
            parent.setNeedUpdateStatusBar()
        }
    }

}

open class QViewControllerDefaultView : QView, IQViewControllerView {

    public weak var viewController: IQViewController?

    public init(viewController: QViewController, backgroundColor: UIColor = .clear) {
        self.viewController = viewController
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = backgroundColor
        self.clipsToBounds = true
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if let vc = self.viewController {
            vc.layout(bounds: self.bounds)
        }
    }

}

open class QViewControllerTransparentView : QTransparentView, IQViewControllerView {

    public weak var viewController: IQViewController?

    public init(viewController: QViewController) {
        self.viewController = viewController
        super.init(frame: UIScreen.main.bounds)
        self.clipsToBounds = true
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func setNeedsLayout() {
        super.setNeedsLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if let vc = self.viewController {
            vc.layout(bounds: self.bounds)
        }
    }

}
