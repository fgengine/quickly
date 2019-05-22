//
//  Quickly
//

public protocol IQContentOwnerViewController : IQViewController {

    func updateContent()

}

public protocol IQContentViewController : IQViewController {

    var contentOwnerViewController: IQContentOwnerViewController? { get }
    var contentOffset: CGPoint { get }
    var contentSize: CGSize { get }
}

extension IQContentViewController {

    public var contentOwnerViewController: IQContentOwnerViewController? {
        get { return self.parentViewController as? IQContentOwnerViewController }
    }

}

