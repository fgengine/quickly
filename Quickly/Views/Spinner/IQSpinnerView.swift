//
//  Quickly
//

import UIKit

public protocol IQSpinnerView : IQView {

    func isAnimating() -> Bool
    
    func start()
    func stop()

}

public typealias QSpinnerViewType = UIView & IQSpinnerView
