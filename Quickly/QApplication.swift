//
//  Quickly
//

open class QApplication< WireframeType: IQAppWireframe > : UIResponder, UIApplicationDelegate {

    public private(set) lazy var wireframe: WireframeType = self.prepareWireframe()
    public var window: UIWindow? {
        set(value) { fatalError("Unsupported method '\(#function)'") }
        get { return self.wireframe.window }
    }

    open func prepareWireframe() -> WireframeType {
        fatalError("Required override function '\(#function)'")
    }

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.wireframe.launch(launchOptions)
        return true
    }
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if self._checkUrlSheme(url: url) == true {
            return self.wireframe.open(url)
        }
        return false
    }

}

extension QApplication {
    
    private func _checkUrlSheme(url: URL) -> Bool {
        var shemes: [String] = []
        guard let scheme = url.scheme else { return false }
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [Any] else { return false }
        urlTypes.forEach({
            guard let dictionary = $0 as? [String : Any], let urlSchemes = dictionary["CFBundleURLSchemes"] as? [String] else { return }
            shemes.append(contentsOf: urlSchemes)
        })
        return shemes.contains(scheme)
    }
    
}
