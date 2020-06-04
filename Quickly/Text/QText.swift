//
//  Quickly
//

open class QText : IQText {
    
    public private(set) var string: String
    public private(set) var font: UIFont?
    public private(set) var color: UIColor?
    public var attributed: NSAttributedString? {
        get { return nil }
    }

    public init(
        text: String,
        font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
        color: UIColor = UIColor.black
    ) {
        self.string = text
        self.font = font
        self.color = color
    }
    
    public init(
        text: String,
        font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize),
        color: UIColor = UIColor.black,
        parts: [String : String]
    ) {
        self.string = text
        parts.forEach({ (key: String, value: String) in
            if let range = text.range(of: key) {
                self.string.replaceSubrange(range, with: value)
            }
        })
        self.font = font
        self.color = color
    }
    
    public func size(size: CGSize) -> CGSize {
        guard let font = self.font, let color = self.color else { return CGSize.zero }
        let attributed = NSAttributedString(
            string: self.string,
            attributes: [
                .font: font,
                .foregroundColor: color
            ]
        )
        let rect = attributed.boundingRect(
            with: size,
            options: [ .usesLineFragmentOrigin ],
            context: nil
        )
        return rect.integral.size
    }

}
