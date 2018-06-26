//
//  Quickly
//

public protocol IQComposable : class {
}

public protocol IQComposition : class {

    associatedtype Composable: IQComposable

    var contentView: UIView { get }
    var composable: Composable! { get }

    static func size(composable: Composable, size: CGSize) -> CGSize
    static func height(composable: Composable, width: CGFloat) -> CGFloat

    init(contentView: UIView)
    init(frame: CGRect)

    func setup()

    func prepare(composable: Composable, animated: Bool)
    func cleanup()

}

public extension IQComposition {

    static func height(composable: Composable, width: CGFloat) -> CGFloat {
        return self.size(composable: composable, size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }

}
