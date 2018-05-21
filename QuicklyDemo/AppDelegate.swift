//
//  QuicklyDemo
//

import Quickly

@UIApplicationMain
class AppDelegate : QApplication< AppContainer, AppRouter > {

    override func prepareContainer() -> AppContainer {
        return AppContainer()
    }

    override func prepareRouter() -> AppRouter {
        return AppRouter(container: self.container)
    }

}

