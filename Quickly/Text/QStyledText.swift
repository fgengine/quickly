//
//  Quickly
//

public final class QStyledText : QText {

    public init(_ text: String, style: IQTextStyle) {
        super.init(style.attributed(text))
    }

}
