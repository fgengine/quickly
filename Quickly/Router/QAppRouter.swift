//
//  Quickly
//

import UIKit

open class QAppRouter<
    ContainerType: IQContainer
>: IQRouter {

    public var container: ContainerType
    public lazy var window: QWindow? = self.prepareWindow()
    public var currentRouter: IQViewControllerRouter? = nil {
        didSet {
            if let window: QWindow = self.window {
                if let currentRouter: IQViewControllerRouter = self.currentRouter {
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

    public init(container: ContainerType) {
        self.container = container
    }

    private func prepareWindow() -> QWindow? {
        return QWindow(frame: UIScreen.main.bounds)
    }

}
