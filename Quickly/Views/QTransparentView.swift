//
//  Quickly
//

@IBDesignable
open class QTransparentView : QInvisibleView {

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
