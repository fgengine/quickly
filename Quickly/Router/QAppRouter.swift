//
//  Quickly
//

open class QAppRouter<
    ContainerType: IQContainer
>: IQRouter {

    public var container: ContainerType
    public lazy var window: QWindow? = self.prepareWindow()
    public var currentRouter: IQViewControllerRouter? = nil {
        didSet {
            if let window: QWindow = self.window {
                if let currentRouter: IQViewControllerRouter = self.currentRouter {
                    #if os(macOS)
                        window.contentViewController = currentRouter.viewController
                    #elseif os(iOS)
                        window.rootViewController = currentRouter.viewController
                    #endif
                } else {
                    #if os(macOS)
                        window.contentViewController = nil
                    #elseif os(iOS)
                        window.rootViewController = nil
                    #endif
                }
                #if os(macOS)
                    if window.isKeyWindow == false {
                        window.makeKey()
                    }
                #elseif os(iOS)
                    if window.isKeyWindow == false {
                        window.makeKeyAndVisible()
                    }
                #endif
            }
        }
    }

    public init(container: ContainerType) {
        self.container = container
    }

    private func prepareWindow() -> QWindow? {
        #if os(macOS)
            var contentRect: NSRect
            let styleMask: NSWindow.StyleMask = [
                .titled,
                .closable,
                .miniaturizable,
                .resizable
            ]
            if let screen: NSScreen = NSScreen.main {
                contentRect = QWindow.contentRect(forFrameRect: screen.visibleFrame, styleMask: styleMask)
            } else {
                contentRect = NSRect(x: 0, y: 0, width: 100, height: 100)
            }
            return QWindow(
                contentRect: contentRect,
                styleMask: styleMask,
                backing: .buffered,
                defer: true
            )
        #elseif os(iOS)
            return QWindow(frame: UIScreen.main.bounds)
        #endif
    }

}
