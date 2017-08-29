//
//  Quickly
//

import UIKit

open class QAppRouter: IQRouter {

    public var container: IQContainer
    public lazy var window: QWindow? = self.prepareWindow()
    public var currentRouter: IQLocalRouter? = nil {
        didSet {
            if let window: QWindow = self.window {
                if let currentRouter: IQLocalRouter = self.currentRouter {
                    window.rootViewController = currentRouter.viewController
                } else {
                    window.rootViewController = nil
                }
                if window.isKeyWindow == false {
                    window.makeKeyAndVisible()
                }
            }
        }
    }

    public init(container: IQContainer) {
        self.container = container
    }

    private func prepareWindow() -> QWindow? {
        return QWindow(frame: UIScreen.main.bounds)
    }

}
