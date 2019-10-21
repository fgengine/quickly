//
//  Quickly
//

public protocol IQContentOwnerViewController : IQViewController {

    func beginUpdateContent()
    func updateContent()
    func finishUpdateContent(velocity: CGPoint) -> CGPoint?
    func endUpdateContent()

}

public protocol IQContentViewController : IQViewController {

    var contentOwnerViewController: IQContentOwnerViewController? { get }
    var contentOffset: CGPoint { get }
    var contentSize: CGSize { get }
    
    func notifyBeginUpdateContent()
    func notifyUpdateContent()
    func notifyFinishUpdateContent(velocity: CGPoint) -> CGPoint?
    func notifyEndUpdateContent()
}

extension IQContentViewController {

    public var contentOwnerViewController: IQContentOwnerViewController? {
        get { return self.parentViewController as? IQContentOwnerViewController }
    }

}

