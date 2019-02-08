//
//  QuicklyDemo
//

import Quickly

@UIApplicationMain
class AppDelegate : QApplication< AppWireframe > {

    override func prepareWireframe() -> AppWireframe {
        return AppWireframe(
            context: AppContext()
        )
    }

}

