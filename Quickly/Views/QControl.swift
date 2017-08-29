//
//  Quickly
//

import UIKit

@IBDesignable
open class QControl : UIControl, IQView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    open func setup() {
    }
    
}
