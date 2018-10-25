//
//  Quickly
//

public protocol IQButtonStyle : class {

    var parent: IQButtonStyle? { set get }
    var color: UIColor? { set get }
    var border: QViewBorder? { set get }
    var cornerRadius: QViewCornerRadius? { set get }
    var shadow: QViewShadow? { set get }
    var image: QImageViewStyleSheet? { set get }
    var text: QLabelStyleSheet? { set get }

}
