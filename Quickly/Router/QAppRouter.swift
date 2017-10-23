//
//  Quickly
//

open class QAppRouter<
    ContainerType: IQContainer
>: IQRouter {

    public var container: ContainerType
    #if os(macOS)
        public var windowStyleMask: NSWindow.StyleMask = [ .titled, .closable, .miniaturizable, .resizable ] {
            didSet {
                if let window: QWindow = self.window {
                    window.styleMask = self.windowStyleMask
                }
            }
        }
        public var windowSize: NSSize = NSSize(width: 480, height: 320) {
            didSet {
                if let window: QWindow = self.window {
                    var frame: NSRect = window.frame
                    frame.size = self.windowSize
                    window.setFrame(frame, display: true)
                }
            }
        }
    #endif
    public lazy var window: QWindow? = self.prepareWindow()
    public var currentRouter: IQViewControllerRouter? = nil {
        didSet {
            if let window: QWindow = self.window {
                #if os(macOS)
                    let frame: NSRect = window.frame
                #endif
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
                    window.setFrame(frame, display: true)
                #endif
                #if os(macOS)
                    if window.isMainWindow == false {
                        window.makeKeyAndOrderFront(self)
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
            let frameRect: NSRect = QWindow.frameRect(
                forContentRect: NSRect(origin: NSPoint.zero, size: self.windowSize),
                styleMask: self.windowStyleMask
            )
            if let screen: NSScreen = NSScreen.main {
                let screenRect: NSRect = screen.visibleFrame
                let centerRect: NSRect = NSRect(
                    x: screenRect.midX - (frameRect.width / 2),
                    y: screenRect.midY - (frameRect.height / 2),
                    width: frameRect.width,
                    height: frameRect.height
                )
                contentRect = QWindow.contentRect(forFrameRect: centerRect, styleMask: self.windowStyleMask)
            } else {
                let centerRect: NSRect = NSRect(x: 0, y: 0, width: frameRect.width, height: frameRect.height)
                contentRect = QWindow.contentRect(forFrameRect: centerRect, styleMask: self.windowStyleMask)
            }
            return QWindow(
                contentRect: contentRect,
                styleMask: self.windowStyleMask,
                backing: .buffered,
                defer: true
            )
        #elseif os(iOS)
            return QWindow(frame: UIScreen.main.bounds)
        #endif
    }

}
