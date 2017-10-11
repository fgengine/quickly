//
//  Quickly
//

open class QWindow : QPlatformWindow, IQView {

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
