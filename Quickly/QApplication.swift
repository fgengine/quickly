//
//  Quickly
//

open class QApplication< RouteContextType: IQRouteContext, WireframeType: QAppWireframe< RouteContextType > > : UIResponder, UIApplicationDelegate {

    public private(set) lazy var routeContext: RouteContextType = self.prepareRouteContext()
    public private(set) lazy var wireframe: WireframeType = self.prepareWireframe()
    public var window: UIWindow? {
        set(value) { fatalError("Unsupported method '\(#function)'") }
        get { return self.wireframe.window }
    }

    open func prepareRouteContext() -> RouteContextType {
        fatalError("Required override function '\(#function)'")
    }

    open func prepareWireframe() -> WireframeType {
        fatalError("Required override function '\(#function)'")
    }

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.wireframe.launch(launchOptions)
        return true
    }

}
