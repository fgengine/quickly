//
//  Quickly
//

open class QGroupWireframe< ContextType: IQContext, WireframeType: IQWireframe > : IQChildWireframe {

    open var baseViewController: IQViewController {
        get { return self.viewController }
    }
    open private(set) var viewController: QGroupContainerViewController
    open private(set) var context: ContextType
    open private(set) weak var parent: WireframeType?

    public init(
        context: ContextType,
        parent: WireframeType
    ) {
        self.viewController = QGroupContainerViewController()
        self.context = context
        self.parent = parent
        self.setup()
    }
    
    open func setup() {
    }

}
