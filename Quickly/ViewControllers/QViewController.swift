//
//  Quickly
//

open class QViewController : NSObject, IQViewController {

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
                if self.isLoaded == true {
                    self.didChangeContentEdgeInsets()
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
            if self.edgesForExtendedLayout != oldValue && self.isLoaded == true {
                self.didChangeContentEdgeInsets()
            }
        }
    }
    open var additionalEdgeInsets: UIEdgeInsets {
        didSet(oldValue) {
            if self.additionalEdgeInsets != oldValue && self.isLoaded == true {
                self.didChangeContentEdgeInsets()
            }
        }
    }
    open var inheritedEdgeInsets: UIEdgeInsets {
        get {
            if self._needUpdateInheritedEdgeInsets == true {
                self._needUpdateInheritedEdgeInsets = false
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
                self._inheritedEdgeInsets = edgeInsets
            }
            return self._inheritedEdgeInsets
        }
    }
    open var adjustedContentInset: UIEdgeInsets {
        get {
            let inheritedEdgeInsets = self.inheritedEdgeInsets
            let additionalEdgeInsets = self.additionalEdgeInsets
            return UIEdgeInsets(
                top: additionalEdgeInsets.top + inheritedEdgeInsets.top,
                left: additionalEdgeInsets.left + inheritedEdgeInsets.left,
                bottom: additionalEdgeInsets.bottom + inheritedEdgeInsets.bottom,
                right: additionalEdgeInsets.right + inheritedEdgeInsets.right
            )
        }
    }
    open var view: UIView {
        get {
            self.loadViewIfNeeded()
            return self._view
        }
    }
    open private(set) var isLoading: Bool = false
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
    private var _parentChanging: Bool
    private var _inheritedEdgeInsets: UIEdgeInsets
    private var _needUpdateInheritedEdgeInsets: Bool
    private var _view: View!

    public override init() {
        self.edgesForExtendedLayout = .all
        self.additionalEdgeInsets = UIEdgeInsets.zero
        self.isPresented = false
        self._parentChanging = false
        self._inheritedEdgeInsets = UIEdgeInsets.zero
        self._needUpdateInheritedEdgeInsets = true
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

    open func loadViewIfNeeded() {
        if self._view == nil && self.isLoading == false {
            self.isLoading = true
            self._view = View(viewController: self)
            self.didLoad()
            self.didChangeContentEdgeInsets()
            self.isLoading = false
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
    
    open func didChangeContentEdgeInsets() {
        #if DEBUG
        if self.logging == true {
            print("\(String(describing: self.classForCoder)).didChangeAdditionalEdgeInsets()")
        }
        #endif
        self._needUpdateInheritedEdgeInsets = true
        self.setNeedLayout()
        self.child.forEach({
            $0.didChangeContentEdgeInsets()
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
        if let index = self.child.firstIndex(where: { return $0 === viewController }) {
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
    
    private class View : UIView {
        
        public weak var viewController: IQViewController?
        
        public init(viewController: QViewController) {
            self.viewController = viewController
            super.init(frame: UIScreen.main.bounds)
            self.backgroundColor = UIColor.clear
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
        
        open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let view = super.hitTest(point, with: event)
            if view == self {
                return nil
            }
            return view
        }
        
    }

}
