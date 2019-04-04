//
//  Quickly
//

open class QHamburgerWireframe< WireframeType: IQWireframe, ContextType: IQContext > : IQChildWireframe {

    open var presentableViewController: IQViewController {
        get { return self.viewController }
    }
    open private(set) var viewController: QHamburgerContainerViewController
    open private(set) weak var parent: WireframeType?
    open private(set) var context: ContextType

    public init(
        parent: WireframeType,
        context: ContextType
    ) {
        self.viewController = QHamburgerContainerViewController()
        self.parent = parent
        self.context = context
        self.setup()
    }
    
    open func setup() {
    }

}
