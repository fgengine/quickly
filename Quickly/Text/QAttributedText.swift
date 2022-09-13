//
//  Quickly
//

import UIKit

open class QAttributedText : IQText {
    
    public var string: String {
        get { return self.attributed?.string ?? "" }
    }
    public var font: UIFont? {
        get { return nil }
    }
    public var color: UIColor? {
        get { return nil }
    }
    public var attributed: NSAttributedString? {
        get { return self._attributed }
    }
    
    private var _attributed: NSMutableAttributedString
    
    public init(attributed: NSAttributedString) {
        self._attributed = NSMutableAttributedString(attributedString: attributed)
    }

    public init(text: String, style: IQTextStyle) {
        self._attributed = style.mutableAttributed(text)
    }
    
    public init(text: String, style: IQTextStyle, parts: [String : QAttributedText]) {
        let attributed = style.mutableAttributed(text)
        parts.forEach({ (key: String, value: QAttributedText) in
            if let range = attributed.string.range(of: key), let valueAttributed = value.attributed {
                attributed.replaceCharacters(in: attributed.string.nsRange(from: range), with: valueAttributed)
            }
        })
        self._attributed = attributed
    }
    
    public init(texts: IQText...) {
        let attributed = NSMutableAttributedString()
        for text in texts {
            if let attributedText = text.attributed {
                attributed.append(attributedText)
            } else if let textFont = text.font, let textColor = text.color {
                attributed.append(NSAttributedString(
                    string: text.string,
                    attributes: [
                        .font : textFont,
                        .foregroundColor : textColor
                    ]
                ))
            }
        }
        self._attributed = attributed
    }
    
    public func append(text: String, style: IQTextStyle) {
        self._attributed.append(style.attributed(text))
    }
    
    public func size(size: CGSize) -> CGSize {
        let rect = self._attributed.boundingRect(
            with: size,
            options: [ .usesLineFragmentOrigin ],
            context: nil
        )
        return rect.integral.size
    }

}
