//
//  Quickly
//

public final class QFormatText : QText {

    public init(_ text: String, style: QTextStyle, parts: [String: IQText]) {
        let attributed = style.mutableAttributed(text)
        parts.forEach { (key: String, value: IQText) in
            if let range = attributed.string.range(of: key) {
                attributed.replaceCharacters(in: text.nsRange(from: range), with: value.attributed)
            }
        }
        super.init(attributed)
    }
    
}
