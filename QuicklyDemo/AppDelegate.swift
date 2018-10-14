//
//  QuicklyDemo
//

import Quickly

@UIApplicationMain
class AppDelegate : QApplication< AppContext, AppWireframe > {

    override func prepareContext() -> AppContext {
        return AppContext()
    }

    override func prepareWireframe() -> AppWireframe {
        return AppWireframe(
            context: self.context
        )
    }

}

