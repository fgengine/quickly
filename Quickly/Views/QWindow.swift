//
//  Quickly
//

open class QWindow : QPlatformWindow, IQView {

    #if os(macOS)

        open override var contentViewController: NSViewController? {
            willSet {
                guard let contentViewController = super.contentViewController else { return }
                if let vc = contentViewController as? IQBaseViewController {
                    vc.willDismiss(animated: false)
                    vc.didDismiss(animated: false)
                }
            }
            didSet {
                guard let contentViewController = super.contentViewController else { return }
                if contentViewController.isViewLoaded == false {
                    contentViewController.loadView()
                }
                if let vc = contentViewController as? IQBaseViewController {
                    vc.willPresent(animated: false)
                    vc.didPresent(animated: false)
                }
            }
        }

    #elseif os(iOS)

        open override var rootViewController: UIViewController? {
            willSet {
                guard let rootViewController = super.rootViewController else { return }
                if let vc = rootViewController as? IQBaseViewController {
                    vc.willDismiss(animated: false)
                    vc.didDismiss(animated: false)
                }
            }
            didSet {
                guard let rootViewController = super.rootViewController else { return }
                rootViewController.loadViewIfNeeded()
                if let vc = rootViewController as? IQBaseViewController {
                    vc.willPresent(animated: false)
                    vc.didPresent(animated: false)
                }
            }
        }

    #endif

    #if os(macOS)

        public override init(
            contentRect: NSRect,
            styleMask style: NSWindow.StyleMask,
            backing backingStoreType: NSWindow.BackingStoreType,
            defer flag: Bool
        ) {
            super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
            self.setup()
        }

    #elseif os(iOS)

        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setup()
        }

    #endif

    open func setup() {
    }

}
