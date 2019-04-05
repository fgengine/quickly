//
//  Quickly
//

open class QHamburgerWireframe< WireframeType: IQWireframe, ContextType: IQContext > : IQChildWireframe {

    open var viewController: IQViewController {
        get { return self.containerViewController }
    }
    open private(set) var containerViewController: QHamburgerContainerViewController
    open private(set) weak var parent: WireframeType?
    open private(set) var context: ContextType

    public init(
        parent: WireframeType,
        context: ContextType
    ) {
        self.containerViewController = QHamburgerContainerViewController()
        self.parent = parent
        self.context = context
        self.setup()
    }
    
    open func setup() {
    }

}
