//
//  Quickly
//

import UIKit

@IBDesignable
open class QRoundView : QView {

    private func updateCornerRadius() {
        let boundsSize: CGSize = self.bounds.integral.size
        self.layer.cornerRadius = ceil(min(boundsSize.width - 1, boundsSize.height - 1) / 2)
    }

    open override func setup() {
        super.setup()

        self.clipsToBounds = true
    }

    open override var frame: CGRect {
        didSet { self.updateCornerRadius() }
    }

    open override var bounds: CGRect {
        didSet { self.updateCornerRadius() }
    }

}
