//
//  Quickly
//

public protocol IQLoadingViewDelegate : class {
    
    func willShow(loadingView: QLoadingViewType)
    func didHide(loadingView: QLoadingViewType)
    
}

public protocol IQLoadingView : IQView {
    
    var delegate: IQLoadingViewDelegate? { set get }
    
    func isAnimating() -> Bool
    
    func start()
    func stop()
    
}

public typealias QLoadingViewType = UIView & IQLoadingView
