//
//  Quickly
//

open class QGroupWireframe< WireframeType: IQWireframe, ContextType: IQContext > : IQChildWireframe {

    open var viewController: IQViewController {
        get { return self.containerViewController }
    }
    open private(set) var containerViewController: QGroupContainerViewController
    open private(set) weak var parent: WireframeType?
    open private(set) var context: ContextType

    public init(
        parent: WireframeType,
        context: ContextType
    ) {
        self.containerViewController = QGroupContainerViewController()
        self.parent = parent
        self.context = context
        self.setup()
    }
    
    open func setup() {
    }
    
    open func open(_ url: URL) -> Bool {
        return true
    }

}
