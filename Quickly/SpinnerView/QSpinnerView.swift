//
//  Quickly
//

import UIKit

@IBDesignable
open class QSpinnerView : QView, IQSpinnerView {

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear
    }

    open func isAnimating() -> Bool  {
        return false
    }

    open func start() {
    }

    open func stop() {
    }
    
}
