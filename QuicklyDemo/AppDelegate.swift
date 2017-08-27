//
//  QuicklyDemo
//

import Quickly

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var router: AppRouter = AppRouter(container: AppContainer())

    var window: UIWindow? {
        set(value) { self.router.window = value as? QWindow }
        get { return self.router.window }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.router.presentChoise()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

