//
//  Quickly
//

public protocol IQComposable : class {
}

public protocol IQComposition : class {

    associatedtype Composable: IQComposable

    var contentView: UIView { get }
    var composable: Composable! { get }

    static func size(composable: Composable, spec: IQContainerSpec) -> CGSize
    static func height(composable: Composable, spec: IQContainerSpec) -> CGFloat

    init(contentView: UIView)
    init(frame: CGRect)

    func setup()

    func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool)
    func cleanup()

}

public extension IQComposition {

    static func height(composable: Composable, spec: IQContainerSpec) -> CGFloat {
        return self.size(composable: composable, spec: spec).height
    }

}
