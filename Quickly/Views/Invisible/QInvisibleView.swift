//
//  Quickly
//

#if os(macOS)

    open class QInvisibleView : QView {
    }

#elseif os(iOS)

    open class QInvisibleView : QView {

        open override func setup() {
            super.setup()

            self.backgroundColor = QPlatformColor.clear
        }

    }

#endif


