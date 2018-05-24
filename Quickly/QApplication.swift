//
//  Quickly
//

open class QApplication< ContainerType: IQContainer, RouterType: QAppRouter< ContainerType > > : UIResponder, UIApplicationDelegate {

    public private(set) lazy var container: ContainerType = self.prepareContainer()
    public private(set) lazy var router: RouterType = self.prepareRouter()
    public var window: UIWindow? {
        set(value) { fatalError("Unsupported method '\(#function)'") }
        get { return self.router.window }
    }

    open func prepareContainer() -> ContainerType {
        fatalError("Required override function '\(#function)'")
    }

    open func prepareRouter() -> RouterType {
        fatalError("Required override function '\(#function)'")
    }

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        self.router.launch(launchOptions)
        return true
    }

}
