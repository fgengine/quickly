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
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedLayout()
        }
    }
    open var additionalEdgeInsets: UIEdgeInsets {
        didSet {
            guard self.isLoaded == true else { return }
            self.setNeedLayout()
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

    private var _parent: IQViewController!
    private var _parentChanging: Bool = false
    private var _view: ViewType!

    public override init() {
        self.edgesForExtendedLayout = .all
        self.additionalEdgeInsets = UIEdgeInsets.zero
        self.isPresented = false
        super.init()
        self.setup()
    }

    open func setup() {
    }

    open func load() -> ViewType {
        return TransparentView(viewController: self)
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
        self.view.setNeedsLayout()
    }

    open func layoutIfNeeded() {
        self.view.layoutIfNeeded()
    }

    open func layout(bounds: CGRect) {
        for vc in self.child {
            vc.view.frame = bounds
        }
    }

    open func prepareInteractivePresent() {
        #if DEBUG
        print("\(String(describing: self.classForCoder)).prepareInteractivePresent()")
        #endif
        for vc in self.child {
            vc.prepareInteractivePresent()
        }
    }

    open func cancelInteractivePresent() {
        #if DEBUG
        print("\(String(describing: self.classForCoder)).cancelInteractivePresent()")
        #endif
        for vc in self.child {
            vc.cancelInteractivePresent()
        }
    }

    open func finishInteractivePresent() {
        #if DEBUG
        print("\(String(describing: self.classForCoder)).finishInteractivePresent()")
        #endif
        for vc in self.child {
            vc.finishInteractivePresent()
        }
    }

    open func willPresent(animated: Bool) {
        self.isPresented = true
        #if DEBUG
        print("\(String(describing: self.classForCoder)).willPresent(animated: \(animated))")
        #endif
        for vc in self.child {
            vc.willPresent(animated: animated)
        }
    }

    open func didPresent(animated: Bool) {
        #if DEBUG
        print("\(String(describing: self.classForCoder)).didPresent(animated: \(animated))")
        #endif
        for vc in self.child {
            vc.didPresent(animated: animated)
        }
    }

    open func prepareInteractiveDismiss() {
        #if DEBUG
        print("\(String(describing: self.classForCoder)).prepareInteractiveDismiss()")
        #endif
        for vc in self.child {
            vc.prepareInteractiveDismiss()
        }
    }

    open func cancelInteractiveDismiss() {
        #if DEBUG
        print("\(String(describing: self.classForCoder)).cancelInteractiveDismiss()")
        #endif
        for vc in self.child {
            vc.cancelInteractiveDismiss()
        }
    }

    open func finishInteractiveDismiss() {
        #if DEBUG
        print("\(String(describing: self.classForCoder)).finishInteractiveDismiss()")
        #endif
        for vc in self.child {
            vc.finishInteractiveDismiss()
        }
    }

    open func willDismiss(animated: Bool) {
        #if DEBUG
        print("\(String(describing: self.classForCoder)).willDismiss(animated: \(animated))")
        #endif
        for vc in self.child {
            vc.willDismiss(animated: animated)
        }
    }

    open func didDismiss(animated: Bool) {
        self.isPresented = false
        #if DEBUG
        print("\(String(describing: self.classForCoder)).didDismiss(animated: \(animated))")
        #endif
        for vc in self.child {
            vc.didDismiss(animated: animated)
        }
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

    public class InvisibleView : QInvisibleView, IQViewControllerView {

        public weak var viewController: IQViewController?

        public init(viewController: QViewController) {
            self.viewController = viewController
            super.init(frame: UIScreen.main.bounds)
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

    public class TransparentView : QTransparentView, IQViewControllerView {

        public weak var viewController: IQViewController?

        public init(viewController: QViewController) {
            self.viewController = viewController
            super.init(frame: UIScreen.main.bounds)
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

}
