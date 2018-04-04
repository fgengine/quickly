//
//  Quickly
//

@IBDesignable
open class QInvisibleView : QView {

    open override func setup() {
        super.setup()

        #if os(iOS)
            self.backgroundColor = QPlatformColor.clear
        #endif
    }
    
}
