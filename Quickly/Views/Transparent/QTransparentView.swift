//
//  Quickly
//

open class QTransparentView : QInvisibleView {

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            if hitView != self {
                return hitView
            }
        }
        return nil
    }
    
}
