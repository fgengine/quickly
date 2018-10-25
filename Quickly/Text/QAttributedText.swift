//
//  Quickly
//

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
    public private(set) var attributed: NSAttributedString?
    
    public init(_ attributed: NSAttributedString) {
        self.attributed = attributed
    }

    public init(_ text: String, style: IQTextStyle) {
        self.attributed = style.attributed(text)
    }
    
    public init(_ string: String, style: IQTextStyle, parts: [String : QAttributedText]) {
        let mutableAttributed = style.mutableAttributed(string)
        parts.forEach({ (key: String, value: QAttributedText) in
            if let range = mutableAttributed.string.range(of: key), let attributed = value.attributed {
                mutableAttributed.replaceCharacters(in: string.nsRange(from: range), with: attributed)
            }
        })
        self.attributed = mutableAttributed
    }
    
    public func size(size: CGSize) -> CGSize {
        guard let attributed = self.attributed else { return CGSize.zero }
        let rect = attributed.boundingRect(
            with: size,
            options: [ .usesLineFragmentOrigin ],
            context: nil
        )
        return rect.integral.size
    }

}
