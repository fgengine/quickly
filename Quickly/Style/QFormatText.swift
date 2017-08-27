//
//  Quickly
//

import UIKit

public class QFormatText: QText {

    public init(_ text: String, style: QTextStyle, parts: [String: IQText]) {
        let attributed: NSMutableAttributedString = style.mutableAttributed(text)
        parts.forEach { (key: String, value: IQText) in
            if let range: Range< String.Index > = text.range(of: key) {
                let nsRange: NSRange = text.nsRange(from: range)
                attributed.replaceCharacters(in: nsRange, with: value.attributed)
            }
        }
        super.init(attributed)
    }

}
