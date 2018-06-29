//
//  Quickly
//

public protocol IQTextStyle : class {

    var parent: IQTextStyle? { set get }
    var children: [IQTextStyle] { get }
    var font: UIFont? { set get }
    var color: UIColor? { set get }
    var backgroundColor: UIColor? { set get }
    var strikeColor: UIColor? { set get }
    var strikeWidth: Float? { set get }
    var strikeThrough: Int? { set get }
    var underlineColor: UIColor? { set get }
    var underlineStyle: NSUnderlineStyle? { set get }
    var shadowOffset: CGSize? { set get }
    var shadowBlurRadius: Float? { set get }
    var shadowColor: UIColor? { set get }
    var ligature: Int? { set get }
    var kerning: Float? { set get }
    var baselineOffset: Float? { set get }
    var obliqueness: Float? { set get }
    var expansion: Float? { set get }
    var lineSpacing: Float? { set get }
    var paragraphBetween: Float? { set get }
    var alignment: NSTextAlignment? { set get }
    var firstLineHeadIndent: Float? { set get }
    var headIndent: Float? { set get }
    var tailIndent: Float? { set get }
    var lineBreakMode: NSLineBreakMode? { set get }
    var minimumLineHeight: Float? { set get }
    var maximumLineHeight: Float? { set get }
    var baseWritingDirection: NSWritingDirection? { set get }
    var lineHeightMultiple: Float? { set get }
    var paragraphSpacingBefore: Float? { set get }
    var hyphenationFactor: Float? { set get }
    var attributes: [NSAttributedStringKey: Any] { get }

    func attributed(_ string: String) -> NSAttributedString
    func mutableAttributed(_ string: String) -> NSMutableAttributedString

    func addChild(_ child: IQTextStyle)
    func removeChild(_ child: IQTextStyle)

    func removeFromParent()
    func removeAllChildren()

    func setNeedRebuildAttributes()

}
