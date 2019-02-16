//
//  Quickly
//

public protocol IQComposable : class {
}

public protocol IQComposition : class {

    associatedtype Composable: IQComposable
    
    var contentView: UIView { get }
    var owner: AnyObject? { get }
    var composable: Composable? { get }
    var spec: IQContainerSpec? { get }

    static func size(composable: Composable, spec: IQContainerSpec) -> CGSize
    static func height(composable: Composable, spec: IQContainerSpec) -> CGFloat

    init(contentView: UIView, owner: AnyObject)
    init(frame: CGRect, owner: AnyObject)

    func setup(owner: AnyObject)

    func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool)
    func cleanup()

}

public protocol IQEditableComposition : class {
    
    func beginEditing()
    func endEditing()
    
}

public extension IQComposition {

    static func height(composable: Composable, spec: IQContainerSpec) -> CGFloat {
        return self.size(composable: composable, spec: spec).height
    }

}
