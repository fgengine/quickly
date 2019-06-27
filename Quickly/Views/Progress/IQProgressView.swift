//
//  Quickly
//

public protocol IQProgressView : IQView {

    var progress: CGFloat { set get }
    
    func setProgress(_ progress: CGFloat, animated: Bool)

}

public typealias QProgressViewType = UIView & IQProgressView
