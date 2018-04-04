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
                if let window = self.window {
                    window.styleMask = self.windowStyleMask
                }
            }
        }
        public var windowSize: NSSize = NSSize(width: 480, height: 320) {
            didSet {
                if let window = self.window {
                    var frame = window.frame
                    frame.size = self.windowSize
                    window.setFrame(frame, display: true)
                }
            }
        }
    #endif
    public lazy var window: QWindow? = self.prepareWindow()
    public lazy var mainViewController: QMainViewController = self.prepareMainViewController()
    public var currentRouter: IQViewControllerRouter? {
        didSet {
            if let currentRouter = self.currentRouter {
                self.mainViewController.contentViewController = currentRouter.viewController
            } else {
                self.mainViewController.contentViewController = nil
            }
            if let window = self.window {
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
            let frameRect = QWindow.frameRect(
                forContentRect: NSRect(origin: NSPoint.zero, size: self.windowSize),
                styleMask: self.windowStyleMask
            )
            if let screen = NSScreen.main {
                let screenRect = screen.visibleFrame
                let centerRect = NSRect(
                    x: screenRect.midX - (frameRect.width / 2),
                    y: screenRect.midY - (frameRect.height / 2),
                    width: frameRect.width,
                    height: frameRect.height
                )
                contentRect = QWindow.contentRect(forFrameRect: centerRect, styleMask: self.windowStyleMask)
            } else {
                let centerRect = NSRect(x: 0, y: 0, width: frameRect.width, height: frameRect.height)
                contentRect = QWindow.contentRect(forFrameRect: centerRect, styleMask: self.windowStyleMask)
            }
            let window = QWindow(
                contentRect: contentRect,
                styleMask: self.windowStyleMask,
                backing: .buffered,
                defer: true
            )
            return window
        #elseif os(iOS)
            return QWindow(frame: UIScreen.main.bounds)
        #endif
    }

    private func prepareMainViewController() -> QMainViewController {
        let vc = QMainViewController()
        if let window = self.window {
            #if os(macOS)
                window.contentViewController = vc
            #elseif os(iOS)
                window.rootViewController = vc
            #endif
        }
        return vc
    }

}
