//
//  Quickly
//

open class QApplication< ContextType: IQContext, WireframeType: QAppWireframe< ContextType > > : UIResponder, UIApplicationDelegate {

    public private(set) lazy var context: ContextType = self.prepareContext()
    public private(set) lazy var wireframe: WireframeType = self.prepareWireframe()
    public var window: UIWindow? {
        set(value) { fatalError("Unsupported method '\(#function)'") }
        get { return self.wireframe.window }
    }

    open func prepareContext() -> ContextType {
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
