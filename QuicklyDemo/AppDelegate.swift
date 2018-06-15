//
//  QuicklyDemo
//

import Quickly

@UIApplicationMain
class AppDelegate : QApplication< AppRouteContext, AppWireframe > {

    override func prepareRouteContext() -> AppRouteContext {
        return AppRouteContext()
    }

    override func prepareWireframe() -> AppWireframe {
        return AppWireframe(self.routeContext)
    }

}

