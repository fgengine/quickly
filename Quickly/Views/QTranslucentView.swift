//
//  Quickly
//

@IBDesignable
open class QTranslucentView : QView {

    open override func setup() {
        super.setup()

        #if os(iOS)
            self.backgroundColor = QPlatformColor.clear
        #endif
    }

    #if os(macOS)
    #elseif os(iOS)

        open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            if let hitView: UIView = super.hitTest(point, with: event) {
                if hitView != self {
                    return hitView
                }
            }
            return nil
        }

    #endif
    
}
