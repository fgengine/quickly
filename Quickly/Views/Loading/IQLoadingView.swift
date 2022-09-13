//
//  Quickly
//

import UIKit

public protocol IQLoadingViewDelegate : AnyObject {
    
    func willShow(loadingView: QLoadingViewType)
    func didHide(loadingView: QLoadingViewType)
    
}

public protocol IQLoadingView : IQView {
    
    var delegate: IQLoadingViewDelegate? { set get }
    
    func isAnimating() -> Bool
    
    func start()
    func stop()
    
}

public protocol IQProgressLoadingView : IQLoadingView {
    
    var progress: CGFloat { set get }
    
    func setProgress(_ progress: CGFloat, animated: Bool)
    
}

public typealias QLoadingViewType = UIView & IQLoadingView
