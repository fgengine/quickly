//
//  Quickly
//

public protocol IQComposable : class {
}

public protocol IQCompositionDelegate : IQTextFieldObserver, IQListFieldObserver, IQDateFieldObserver {
}

public protocol IQComposition : class {

    associatedtype Composable: IQComposable

    var delegate: IQCompositionDelegate? { get }
    var contentView: UIView { get }
    var composable: Composable! { get }

    static func size(composable: Composable, spec: IQContainerSpec) -> CGSize
    static func height(composable: Composable, spec: IQContainerSpec) -> CGFloat

    init(contentView: UIView, delegate: IQCompositionDelegate?)
    init(frame: CGRect, delegate: IQCompositionDelegate?)

    func setup()

    func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool)
    func cleanup()

}

public extension IQComposition {

    static func height(composable: Composable, spec: IQContainerSpec) -> CGFloat {
        return self.size(composable: composable, spec: spec).height
    }

}
