//
//  Quickly
//

@IBDesignable
open class QInvisibleView : QView {

    open override func setup() {
        super.setup()

        #if os(macOS)
            self.wantsLayer = true
            self.layer!.backgroundColor = QPlatformColor.clear.cgColor
        #elseif os(iOS)
            self.backgroundColor = QPlatformColor.clear
        #endif
    }
    
}
